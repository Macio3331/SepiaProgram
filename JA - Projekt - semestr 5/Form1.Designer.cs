namespace JA___Projekt___semestr_5
{
    partial class ProgramSepia
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.labelTitle = new System.Windows.Forms.Label();
            this.buttonPhoto = new System.Windows.Forms.Button();
            this.buttonStart = new System.Windows.Forms.Button();
            this.labelThreads = new System.Windows.Forms.Label();
            this.pictureBoxMain = new System.Windows.Forms.PictureBox();
            this.labelPath = new System.Windows.Forms.Label();
            this.labelMessage = new System.Windows.Forms.Label();
            this.radioButtonAsembler = new System.Windows.Forms.RadioButton();
            this.radioButtonCpp = new System.Windows.Forms.RadioButton();
            this.trackBarThreads = new System.Windows.Forms.TrackBar();
            this.label1 = new System.Windows.Forms.Label();
            this.label64 = new System.Windows.Forms.Label();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxMain)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.trackBarThreads)).BeginInit();
            this.SuspendLayout();
            // 
            // labelTitle
            // 
            this.labelTitle.AutoSize = true;
            this.labelTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelTitle.Location = new System.Drawing.Point(5, 9);
            this.labelTitle.MinimumSize = new System.Drawing.Size(783, 31);
            this.labelTitle.Name = "labelTitle";
            this.labelTitle.Size = new System.Drawing.Size(783, 31);
            this.labelTitle.TabIndex = 0;
            this.labelTitle.Text = "Program służący do nakładania efektu sepii na wybrane zdjęcie!";
            this.labelTitle.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // buttonPhoto
            // 
            this.buttonPhoto.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonPhoto.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.buttonPhoto.Location = new System.Drawing.Point(219, 54);
            this.buttonPhoto.Name = "buttonPhoto";
            this.buttonPhoto.Size = new System.Drawing.Size(352, 47);
            this.buttonPhoto.TabIndex = 2;
            this.buttonPhoto.Text = "Wybierz zdjęcie";
            this.buttonPhoto.UseVisualStyleBackColor = true;
            this.buttonPhoto.Click += new System.EventHandler(this.buttonPhoto_Click);
            // 
            // buttonStart
            // 
            this.buttonStart.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonStart.Font = new System.Drawing.Font("Microsoft Sans Serif", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.buttonStart.Location = new System.Drawing.Point(11, 415);
            this.buttonStart.Name = "buttonStart";
            this.buttonStart.Size = new System.Drawing.Size(768, 74);
            this.buttonStart.TabIndex = 5;
            this.buttonStart.Text = "Uruchom algorytm";
            this.buttonStart.UseVisualStyleBackColor = true;
            this.buttonStart.Click += new System.EventHandler(this.buttonStart_Click);
            // 
            // labelThreads
            // 
            this.labelThreads.AutoSize = true;
            this.labelThreads.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F);
            this.labelThreads.Location = new System.Drawing.Point(12, 240);
            this.labelThreads.Name = "labelThreads";
            this.labelThreads.Size = new System.Drawing.Size(144, 25);
            this.labelThreads.TabIndex = 7;
            this.labelThreads.Text = "Ilość wątków: 1";
            // 
            // pictureBoxMain
            // 
            this.pictureBoxMain.Location = new System.Drawing.Point(512, 158);
            this.pictureBoxMain.Name = "pictureBoxMain";
            this.pictureBoxMain.Size = new System.Drawing.Size(212, 212);
            this.pictureBoxMain.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxMain.TabIndex = 10;
            this.pictureBoxMain.TabStop = false;
            // 
            // labelPath
            // 
            this.labelPath.AutoSize = true;
            this.labelPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelPath.Location = new System.Drawing.Point(14, 117);
            this.labelPath.Name = "labelPath";
            this.labelPath.Size = new System.Drawing.Size(88, 25);
            this.labelPath.TabIndex = 11;
            this.labelPath.Text = "Ścieżka:";
            // 
            // labelMessage
            // 
            this.labelMessage.AutoSize = true;
            this.labelMessage.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.labelMessage.Location = new System.Drawing.Point(14, 345);
            this.labelMessage.Name = "labelMessage";
            this.labelMessage.Size = new System.Drawing.Size(0, 25);
            this.labelMessage.TabIndex = 12;
            // 
            // radioButtonAsembler
            // 
            this.radioButtonAsembler.AutoSize = true;
            this.radioButtonAsembler.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.radioButtonAsembler.Location = new System.Drawing.Point(17, 158);
            this.radioButtonAsembler.Name = "radioButtonAsembler";
            this.radioButtonAsembler.Size = new System.Drawing.Size(113, 29);
            this.radioButtonAsembler.TabIndex = 13;
            this.radioButtonAsembler.TabStop = true;
            this.radioButtonAsembler.Text = "Asembler";
            this.radioButtonAsembler.UseVisualStyleBackColor = true;
            // 
            // radioButtonCpp
            // 
            this.radioButtonCpp.AutoSize = true;
            this.radioButtonCpp.Font = new System.Drawing.Font("Microsoft Sans Serif", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.radioButtonCpp.Location = new System.Drawing.Point(17, 193);
            this.radioButtonCpp.Name = "radioButtonCpp";
            this.radioButtonCpp.Size = new System.Drawing.Size(69, 29);
            this.radioButtonCpp.TabIndex = 14;
            this.radioButtonCpp.TabStop = true;
            this.radioButtonCpp.Text = "C++";
            this.radioButtonCpp.UseVisualStyleBackColor = true;
            // 
            // trackBarThreads
            // 
            this.trackBarThreads.Location = new System.Drawing.Point(17, 279);
            this.trackBarThreads.Maximum = 64;
            this.trackBarThreads.Minimum = 1;
            this.trackBarThreads.Name = "trackBarThreads";
            this.trackBarThreads.Size = new System.Drawing.Size(423, 45);
            this.trackBarThreads.TabIndex = 15;
            this.trackBarThreads.Value = 1;
            this.trackBarThreads.Scroll += new System.EventHandler(this.trackBarThreads_Scroll);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(8, 311);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(13, 13);
            this.label1.TabIndex = 16;
            this.label1.Text = "1";
            // 
            // label64
            // 
            this.label64.AutoSize = true;
            this.label64.Location = new System.Drawing.Point(427, 311);
            this.label64.Name = "label64";
            this.label64.Size = new System.Drawing.Size(19, 13);
            this.label64.TabIndex = 17;
            this.label64.Text = "64";
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(512, 376);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(212, 23);
            this.progressBar.TabIndex = 18;
            // 
            // ProgramSepia
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlDark;
            this.ClientSize = new System.Drawing.Size(792, 501);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.label64);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.trackBarThreads);
            this.Controls.Add(this.radioButtonCpp);
            this.Controls.Add(this.radioButtonAsembler);
            this.Controls.Add(this.labelMessage);
            this.Controls.Add(this.labelPath);
            this.Controls.Add(this.pictureBoxMain);
            this.Controls.Add(this.labelThreads);
            this.Controls.Add(this.buttonStart);
            this.Controls.Add(this.buttonPhoto);
            this.Controls.Add(this.labelTitle);
            this.MaximumSize = new System.Drawing.Size(808, 540);
            this.MinimumSize = new System.Drawing.Size(808, 540);
            this.Name = "ProgramSepia";
            this.Text = "ProgramSepia";
            this.Load += new System.EventHandler(this.ProgramSepia_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxMain)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.trackBarThreads)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelTitle;
        private System.Windows.Forms.Button buttonPhoto;
        private System.Windows.Forms.Button buttonStart;
        private System.Windows.Forms.Label labelThreads;
        private System.Windows.Forms.PictureBox pictureBoxMain;
        private System.Windows.Forms.Label labelPath;
        private System.Windows.Forms.Label labelMessage;
        private System.Windows.Forms.RadioButton radioButtonAsembler;
        private System.Windows.Forms.RadioButton radioButtonCpp;
        private System.Windows.Forms.TrackBar trackBarThreads;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label64;
        private System.Windows.Forms.ProgressBar progressBar;
    }
}

