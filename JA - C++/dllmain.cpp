// Temat projektu:
//      Nak�adanie efektu sepii na zdj�cie w formacie .jpg
//
// Opis algorytmu:
//      Algorytm oblicza nowe warto�ci RGB ka�dego piksela na podstawie jego starych warto�ci wed�ug wzor�w:
//      nowa warto�� R = 0.393 * stara warto�� R + 0.769 * stara warto�� G + 0.189 * stara warto�� B
//      nowa warto�� G = 0.349 * stara warto�� R + 0.686 * stara warto�� G + 0.168 * stara warto�� B
//      nowa warto�� B = 0.272 * stara warto�� R + 0.534 * stara warto�� G + 0.131 * stara warto�� B
//      Je�li nowa warto�� jest wi�ksza od 255, to ustawiana jest warto�� maksymalna sk�adowej 255.
// 
// 22.11.2023 | semestr 5 | rok akademicki 2023/24 | Musia� Maciej
//
// Wersja: 2.1
// 1.1 Utworzenie interfejsu u�ytkownika i do��czenie wykonywalnych plik�w DLL.
// 1.2 Wprowadzenie wielow�tkowego wywo�ywania funkcji bibliotecznych oraz wczytanie bitmapy z formatu .jpg.
// 1.3 Dodanie algorytmu nak�adaj�cego efekt sepii w j�zyku C++, przekazanie i modyfikacja danych w asemblerze.
// 1.4 Wprowadzenie r�wnomienrego podzia�u danych na w�tki.
// 1.5 Dodanie algorytmu nak�adaj�cego efekt sepii w asemblerze oraz pomiar�w czas�w.
// 2.1 Dodanie paska post�pu programu.

// dllmain.cpp : Definiuje punkt wej�cia dla aplikacji DLL.

// Parametry wej�ciowe:
// adres tablicy (dowolny miejsce w pami�ci),
// offset (mi�dzy 0 a warto�ci� 3 * szeroko�� zdj�cia * (ilo�� w�tk�w - 1),
// ilo�� bajt�w do przetworzenia (mi�dzy warto�ci� 3 * szeroko�� zdj�cia * wysoko�� zdj�cia / 64 a warto�ci� 3 * szeroko�� zdj�cia * wysoko�� zdj�cia),
// ilo�� bajt�w w wierszu (3 * szeroko�� wiersza)
// Parametry wyj�ciowe:
// brak

#include "pch.h"

#define EXPORTED_METHOD extern "C" __declspec(dllexport)
EXPORTED_METHOD
void MyProcCpp(char* data, int offset, int amount, int stride)
{
    int number_of_rows = amount / stride;                                       // wyliczenie ilo�ci wierszy do przetworzenia w danym w�tku
    int rest = stride % 3;                                                      // wyliczenie reszty z dzielenia bitmapy
                                                                                // (sprawdzenie, czy zosta�y dodane zerowe bajty dla wyr�wnania bitmapy na ko�cu wiersza)
    for (int i = 0; i < number_of_rows; i++)                                    // p�tla zewn�trzna iteruj�ca po wierszach
    {
        for (int j = 0; j < stride; j += 3)                                     // p�tla wewn�trzna iteruj�ca po pikselach w wierszu
        {
            BYTE oldB = data[offset];                                           // odczytanie starej warto�ci B
            BYTE oldG = data[offset + 1];                                       // odczytanie starej warto�ci G
            BYTE oldR = data[offset + 2];                                       // odczytanie starej warto�ci R

            BYTE newR = min(0.393 * oldR + 0.769 * oldG + 0.189 * oldB, 255);   // obliczenie nowej warto�ci R wed�ug algorytmu
            BYTE newG = min(0.349 * oldR + 0.686 * oldG + 0.168 * oldB, 255);   // obliczenie nowej warto�ci G wed�ug algorytmu
            BYTE newB = min(0.272 * oldR + 0.534 * oldG + 0.131 * oldB, 255);   // obliczenie nowej warto�ci B wed�ug algorytmu

            data[offset] = newB;                                                // zapisanie nowej warto�ci B
            data[offset + 1] = newG;                                            // zapisanie nowej warto�ci G
            data[offset + 2] = newR;                                            // zapisanie nowej warto�ci R
            offset += 3;                                                        // przesuni�cie licznika pikseli na nast�pny piksel
        }
        if (rest == 1) offset -= 2;                                             // ustawienie licznika pikseli na pocz�tek kolejnego piksela,
                                                                                // je�li zosta� dodany jeden piksel
        else if (rest == 2) offset--;                                           // ustawienie licznika pikseli na pocz�tek kolejnego piksela,
                                                                                // je�li zosta�y dodane dwa piksele
    }
}