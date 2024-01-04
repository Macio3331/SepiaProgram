; Temat projektu:
;      Nak�adanie efektu sepii na zdj�cie w formacie .jpg
;
; Opis algorytmu:
;      Algorytm oblicza nowe warto�ci RGB ka�dego piksela na podstawie jego starych warto�ci wed�ug wzor�w:
;      nowa warto�� R = 0.393 * stara warto�� R + 0.769 * stara warto�� G + 0.189 * stara warto�� B
;      nowa warto�� G = 0.349 * stara warto�� R + 0.686 * stara warto�� G + 0.168 * stara warto�� B
;      nowa warto�� B = 0.272 * stara warto�� R + 0.534 * stara warto�� G + 0.131 * stara warto�� B
;      Je�li nowa warto�� jest wi�ksza od 255, to ustawiana jest warto�� maksymalna sk�adowej 255.
; 
; 22.11.2023 | semestr 5 | rok akademicki 2023/24 | Musia� Maciej
;
; Wersja: 2.1
; 1.1 Utworzenie interfejsu u�ytkownika i do��czenie wykonywalnych plik�w DLL.
; 1.2 Wprowadzenie wielow�tkowego wywo�ywania funkcji bibliotecznych oraz wczytanie bitmapy z formatu .jpg.
; 1.3 Dodanie algorytmu nak�adaj�cego efekt sepii w j�zyku C++, przekazanie i modyfikacja danych w asemblerze.
; 1.4 Wprowadzenie r�wnomienrego podzia�u danych na w�tki.
; 1.5 Dodanie algorytmu nak�adaj�cego efekt sepii w asemblerze oraz pomiar�w czas�w.
; 2.1 Dodanie paska post�pu programu i optymalizacja dzia�ania.

; Parametry wej�ciowe:
; RCX <- adres tablicy (dowolny miejsce w pami�ci),
; RDX <- offset (mi�dzy 0 a warto�ci� 3 * szeroko�� zdj�cia * (ilo�� w�tk�w - 1),
; R8 <- ilo�� bajt�w do przetworzenia (mi�dzy warto�ci� 3 * szeroko�� zdj�cia * wysoko�� zdj�cia/64 a warto�ci� 3 * szeroko�� zdj�cia * wysoko�� zdj�cia),
; R9 <- ilo�� bajt�w w wierszu (3 * szeroko�� wiersza)
; Parametry wyj�ciowe:
; brak
; Rejestry ulegaj�ce zmianie: 
; RCX, RDX, RAX, R8, R9, R10, R11, R12, R13, XMM6, XMM5, XMM4, XMM3, XMM2, XMM1, XMM0 

.data
max_array oword			00000000000000ff000000ff000000ffh			; zmienna 16-bajtowa interpretowana jako 4 warto�ci ca�kowite w rejestrze xmm: 0, 255, 255, 255
multiply_arrayR oword	00000000000001920000016500000117h			; zmienna 16-bajtowa interpretowana jako 4 warto�ci ca�kowite w rejestrze xmm: 0, 393, 349, 272
multiply_arrayG oword	0000000000000313000002be00000223h			; zmienna 16-bajtowa interpretowana jako 4 warto�ci ca�kowite w rejestrze xmm: 0, 769, 686, 534
multiply_arrayB oword	00000000000000c2000000ac00000086h			; zmienna 16-bajtowa interpretowana jako 4 warto�ci ca�kowite w rejestrze xmm: 0, 189, 168, 131

.code
MyProcAsm proc						; RCX <- adres tablicy, RDX <- offset, R8 <- ilo�� bajt�w do przetworzenia, R9 <- ilo�� bajt�w w wierszu

mov r10, rdx						; offset w r10
mov rdx, 0							; wyzerowanie rdx (potrzebne do dzielenia)
mov rax, r8							; wpisanie ilo�ci bajt�w do rax - przygotowanie do dzielenia
div r9								; dzielenie ilo�ci bajt�w przez ilo�� bajt�w w wierszu - wynik (ilo�� wierszy do przetworzenia) w rax
mov r11, rax						; zachowanie informacji o ilo�ci wierszy do przetworzenia w r11
mov rax, r8							; wpisanie ilo�ci bajt�w do rax - przygotowanie do dzielenia
mov r12, 3							; wpisanie 3 do r12 - przygotowanie do dzielenia
div r12								; dzielenie ilo�ci bajt�w przez 3 - wynik (reszta) w rdx
mov r12, rdx						; zachowanie informacji o reszcie z dzielenia w r12
movdqu xmm6, [max_array]			; wpisanie do xmm6 warto�ci maksymalnych poszczeg�lnych sk�adowych pikseli
movdqu xmm5, [multiply_arrayR]		; wpisanie do xmm5 wsp�czynnik�w sk�adowych koloru R
movdqu xmm4, [multiply_arrayG]		; wpisanie do xmm4 wsp�czynnik�w sk�adowych koloru G
movdqu xmm3, [multiply_arrayB]		; wpisanie do xmm3 wsp�czynnik�w sk�adowych koloru B

loop1:
	sub r11, 1						; odj�cie 1 od ilo�ci wierszy do przetworzenia
	mov rax, 0						; wpisanie 0 do rax - przygotowanie do por�wnania
	cmp r11, rax					; por�wnanie ilo�ci wierszy
	jl endloop1						; skok do ko�ca procedury, je�li wszystkie wiersze zosta�y przetworzone
	mov r13, r9						; kopia ilo�ci bajt�w w wierszu (licznika p�tli)

	loop2:
		sub r13, 3					; odj�cie 3 od ilo�ci bajt�w w wierszu
		mov rax, 0					; wpisanie 0 do rax - przygotowanie do por�wnania
		cmp r13, rax				; por�wnanie ilo�ci bajt�w w wierszu
		jl endloop2					; skok do ko�ca p�tli wewn�trznej

; ======================================== G��WNY ALGORYTM PROGRAMU ========================================

		xorps xmm0, xmm0						; wyzerowanie rejestru xmm0
		mov byte ptr al, [rcx + r10 + 2]		; wpianie starej warto�ci R do al
		shl rax, 32								; przesuni�cie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10 + 2]		; wpianie starej warto�ci R do al
		vmovq xmm1, rax							; przepisanie warto�ci rax do dolnej cz�ci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej cz�ci xmm1 do g�rnej cz�ci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm5				; mno�enie podw�jnych s��w przez odpowiednie wsp�czynniki sepii (R)
		paddd xmm0, xmm2						; dodanie podw�jnych s��w z xmm2 do xmm0

		mov byte ptr al, [rcx + r10 + 1]		; wpianie starej warto�ci G do al
		shl rax, 32								; przesuni�cie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10 + 1]		; wpianie starej warto�ci G do al
		vmovq xmm1, rax							; przepisanie warto�ci rax do dolnej cz�ci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej cz�ci xmm1 do g�rnej cz�ci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm4				; mno�enie podw�jnych s��w przez odpowiednie wsp�czynniki sepii (G)
		paddd xmm0, xmm2						; dodanie podw�jnych s��w z xmm2 do xmm0

		mov byte ptr al, [rcx + r10]			; wpianie starej warto�ci B do al
		shl rax, 32								; przesuni�cie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10]			; wpianie starej warto�ci B do al
		vmovq xmm1, rax							; przepisanie warto�ci rax do dolnej cz�ci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej cz�ci xmm1 do g�rnej cz�ci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm3				; mno�enie podw�jnych s��w przez odpowiednie wsp�czynniki sepii (B)
		paddd xmm0, xmm2						; dodanie podw�jnych s��w z xmm2 do xmm0
		
		psrld xmm0, 10							; podzielenie uzyskanych wynik�w przez 1024
		pminsd xmm0, xmm6						; wpisanie mniejszej warto�ci spo�r�d uzyskanej oraz 255

		vmovq rax, xmm0							; przepisanie dolnej cz�ci xmm0 do rax
		mov byte ptr [rcx + r10], al			; wpisanie nowej warto�ci B do tablicy
		shr rax, 32								; przesuni�cie rax o 4 bajty w prawo
		mov byte ptr [rcx + r10 + 1], al		; wpisanie nowej warto�ci G do tablicy
		movhlps xmm0, xmm0						; przepisanie g�rnej cz�ci xmm0 do dolnej cz�ci xmm0
		vmovq rax, xmm0							; przepisanie dolnej cz�ci xmm0 do rax
		mov byte ptr [rcx + r10 + 2], al		; wpisanie nowej warto�ci R do tablicy
		
; ==========================================================================================================

		add r10, 3					; przesuni�cie offsetu o 3
		jmp loop2					; skok do nast�pnej iteracji p�tli wewn�trznej

	endloop2:
		mov rax, 2					; wpisanie 2 do rax - przygotowanie do por�wnania
		cmp r12, rax				; por�wnanie reszty w r12 z 2
		je add_offset1				; skok do dodania 1, je�li elementy s� r�wne
		mov rax, 1					; wpisanie 1 do rax - przygotowanie do por�wnania
		cmp r12, rax				; por�wnianie reszty w r12 z 1
		je add_offset2				; skok do dodania 1, je�li elementy s� r�wne
		jmp loop1					; skok do kolejnej iteracji p�tli zewn�trznej

	add_offset1:
		add r10, 1					; dodanie 1 do offsetu
		jmp loop1					; skok do kolejnej iteracji p�tli zewn�trznej

	add_offset2:
		add r10, 2					; dodanie 2 do offsetu
		jmp loop1					; skok do kolejnej iteracji p�tli zewn�trznej

endloop1:
	ret

MyProcAsm endp
end

;multiply_arrayR oword	000000000000000000000189015d0110h			; 0, 393, 349, 272
;multiply_arrayG oword	00000000000000000000030102ae0216h			; 0, 769, 686, 534
;multiply_arrayB oword	0000000000000000000000bd00a80083h			; 0, 189, 168, 131

;multiply_arrayR oword 000000003ec9374c3eb2b0213e8b4396h			; 0, 3ec9374ch, 3eb2b021h, 3e8b4396h .393, .349, .272 
;multiply_arrayG oword 000000003f44dd2f3f2f9db23f08b439h			; 0, 3f44dd2fh, 3f2f9db2h, 3f08b439h .769, .686, .534
;multiply_arrayB oword 000000003e4189373e2c08313e0624ddh			; 0, 3e418937h, 3e2c0831h, 3e0624ddh .189, .168, .131