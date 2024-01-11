// Temat projektu:
//      Nakładanie efektu sepii na zdjęcie w formacie .jpg
//
// Opis algorytmu:
//      Algorytm oblicza nowe wartości RGB każdego piksela na podstawie jego starych wartości według wzorów:
//      nowa wartość R = 0.393 * stara wartość R + 0.769 * stara wartość G + 0.189 * stara wartość B
//      nowa wartość G = 0.349 * stara wartość R + 0.686 * stara wartość G + 0.168 * stara wartość B
//      nowa wartość B = 0.272 * stara wartość R + 0.534 * stara wartość G + 0.131 * stara wartość B
//      Jeśli nowa wartość jest większa od 255, to ustawiana jest wartość maksymalna składowej 255.
// 
// 22.11.2023 | semestr 5 | rok akademicki 2023/24 | Musiał Maciej
//
// Wersja: 2.1
// 1.1 Utworzenie interfejsu użytkownika i dołączenie wykonywalnych plików DLL.
// 1.2 Wprowadzenie wielowątkowego wywoływania funkcji bibliotecznych oraz wczytanie bitmapy z formatu .jpg.
// 1.3 Dodanie algorytmu nakładającego efekt sepii w języku C++, przekazanie i modyfikacja danych w asemblerze.
// 1.4 Wprowadzenie równomienrego podziału danych na wątki.
// 1.5 Dodanie algorytmu nakładającego efekt sepii w asemblerze oraz pomiarów czasów.
// 2.1 Dodanie paska postępu programu.

using System;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Drawing.Imaging;
using System.Diagnostics;
using System.IO;

namespace JA___Projekt___semestr_5
{
    
    public partial class ProgramSepia : Form
    {
        [DllImport(@"C:\Users\macio\source\repos\JA - Projekt - semestr 5\x64\Release\JA - Asembler.dll")]
        static extern void MyProcAsm(byte[] data, int offset, int amount, int stride);

        [DllImport(@"C:\Users\macio\source\repos\JA - Projekt - semestr 5\x64\Release\JA - C++.dll")]
        static extern void MyProcCpp(byte[] data, int offset, int amount, int stride);

        private delegate void MyProc(byte[] data, int offset, int amount, int stride);

        string path = "";
        int numberOfThreads = 1;

        public ProgramSepia()
        {
            InitializeComponent();
        }

        private void ProgramSepia_Load(object sender, EventArgs e)
        {
            radioButtonAsembler.Checked = true;
            progressBar.Visible = false;
        }

        private void buttonPhoto_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Title = "Wybierz plik";
            openFileDialog.Filter = "JPG and JPEG files (*.jpg; *.jpeg)|*.jpg;*.jpeg";
            openFileDialog.Multiselect = false;
            openFileDialog.FilterIndex = 1;

            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                labelMessage.Text = "Wczytywanie zdjęcia...";
                path = openFileDialog.FileName;
                labelPath.Text = "Ścieżka: " + path;
                labelMessage.Text = "";
                Bitmap bitmap = new Bitmap(path);
                pictureBoxMain.Image = bitmap;
                labelMessage.Text = "";
            }
        }

        private void trackBarThreads_Scroll(object sender, EventArgs e)
        {
            numberOfThreads = trackBarThreads.Value;
            labelThreads.Text = "Ilość wątków: " + numberOfThreads;
        }

        private void buttonStart_Click(object sender, EventArgs e)
        {
            if (path == "")
            {
                labelMessage.Text = "Wybierz plik!";
                return;
            }
            else labelMessage.Text = "";

            progressBar.Visible = true;
            progressBar.Minimum = 0;
            progressBar.Value = 1;
            progressBar.Maximum = numberOfThreads;
            progressBar.Step = 1;

            labelMessage.Text = "Wczytywanie bitmapy...";
            MyProc func;
            if (radioButtonAsembler.Checked) func = MyProcAsm;
            else func = MyProcCpp;

            Bitmap bitmap = new Bitmap(path);
            Rectangle rect = new Rectangle(0, 0, bitmap.Width, bitmap.Height);
            BitmapData bitmapData = bitmap.LockBits(rect, ImageLockMode.ReadWrite, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            IntPtr bitmapPointer = bitmapData.Scan0;

            labelMessage.Text = "Podział danych...";

            int bytesCount = Math.Abs(bitmapData.Stride) * bitmap.Height;
            byte[] data = new byte[bytesCount];
            Marshal.Copy(bitmapPointer, data, 0, bytesCount);

            Thread[] threads = new Thread[numberOfThreads];
            int numberOfRows = bitmapData.Height / numberOfThreads;
            int amount = bitmapData.Stride * numberOfRows;
            int rest = bitmapData.Height % numberOfThreads;
            for (int i = 0; i < numberOfThreads; i++)
            {
                int offset = i * amount;
                if (i < rest)
                {
                    offset += bitmapData.Stride * i;
                    threads[i] = new Thread(() => func(data, offset, amount + bitmapData.Stride, bitmapData.Stride));
                }
                else
                {
                    offset += bitmapData.Stride * rest;
                    threads[i] = new Thread(() => func(data, offset, amount, bitmapData.Stride));
                }
            }

            labelMessage.Text = "Wykonanie algorytmu...";
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            for (int i = 0; i < numberOfThreads; i++)
                threads[i].Start();
            for (int i = 0; i < numberOfThreads; i++)
            {
                progressBar.PerformStep();
                threads[i].Join();
            }
            stopwatch.Stop();

            Marshal.Copy(data, 0, bitmapPointer, bytesCount);
            bitmap.UnlockBits(bitmapData);

            pictureBoxMain.Image = bitmap;

            progressBar.Visible = false;

            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "JPG and JPEG files (*.jpg; *.jpeg)|*.jpg;*.jpeg";
            saveFileDialog.Title = "Wybierz plik";
            saveFileDialog.FilterIndex = 1;
            if (saveFileDialog.ShowDialog() == DialogResult.OK) bitmap.Save(saveFileDialog.FileName, ImageFormat.Jpeg);

            labelMessage.Text = "Czas wykonania: " + stopwatch.ElapsedMilliseconds + "ms";
        }
    }
}
