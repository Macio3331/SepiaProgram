; Temat projektu:
;      Nak³adanie efektu sepii na zdjêcie w formacie .jpg
;
; Opis algorytmu:
;      Algorytm oblicza nowe wartoœci RGB ka¿dego piksela na podstawie jego starych wartoœci wed³ug wzorów:
;      nowa wartoœæ R = 0.393 * stara wartoœæ R + 0.769 * stara wartoœæ G + 0.189 * stara wartoœæ B
;      nowa wartoœæ G = 0.349 * stara wartoœæ R + 0.686 * stara wartoœæ G + 0.168 * stara wartoœæ B
;      nowa wartoœæ B = 0.272 * stara wartoœæ R + 0.534 * stara wartoœæ G + 0.131 * stara wartoœæ B
;      Jeœli nowa wartoœæ jest wiêksza od 255, to ustawiana jest wartoœæ maksymalna sk³adowej 255.
; 
; 22.11.2023 | semestr 5 | rok akademicki 2023/24 | Musia³ Maciej
;
; Wersja: 2.1
; 1.1 Utworzenie interfejsu u¿ytkownika i do³¹czenie wykonywalnych plików DLL.
; 1.2 Wprowadzenie wielow¹tkowego wywo³ywania funkcji bibliotecznych oraz wczytanie bitmapy z formatu .jpg.
; 1.3 Dodanie algorytmu nak³adaj¹cego efekt sepii w jêzyku C++, przekazanie i modyfikacja danych w asemblerze.
; 1.4 Wprowadzenie równomienrego podzia³u danych na w¹tki.
; 1.5 Dodanie algorytmu nak³adaj¹cego efekt sepii w asemblerze oraz pomiarów czasów.
; 2.1 Dodanie paska postêpu programu i optymalizacja dzia³ania.

; Parametry wejœciowe:
; RCX <- adres tablicy (dowolny miejsce w pamiêci),
; RDX <- offset (miêdzy 0 a wartoœci¹ 3 * szerokoœæ zdjêcia * (iloœæ w¹tków - 1),
; R8 <- iloœæ bajtów do przetworzenia (miêdzy wartoœci¹ 3 * szerokoœæ zdjêcia * wysokoœæ zdjêcia/64 a wartoœci¹ 3 * szerokoœæ zdjêcia * wysokoœæ zdjêcia),
; R9 <- iloœæ bajtów w wierszu (3 * szerokoœæ wiersza)
; Parametry wyjœciowe:
; brak
; Rejestry ulegaj¹ce zmianie: 
; RCX, RDX, RAX, R8, R9, R10, R11, R12, R13, XMM6, XMM5, XMM4, XMM3, XMM2, XMM1, XMM0 

.data
max_array oword			00000000000000ff000000ff000000ffh			; zmienna 16-bajtowa interpretowana jako 4 wartoœci ca³kowite w rejestrze xmm: 0, 255, 255, 255
multiply_arrayR oword	00000000000001920000016500000117h			; zmienna 16-bajtowa interpretowana jako 4 wartoœci ca³kowite w rejestrze xmm: 0, 393, 349, 272
multiply_arrayG oword	0000000000000313000002be00000223h			; zmienna 16-bajtowa interpretowana jako 4 wartoœci ca³kowite w rejestrze xmm: 0, 769, 686, 534
multiply_arrayB oword	00000000000000c2000000ac00000086h			; zmienna 16-bajtowa interpretowana jako 4 wartoœci ca³kowite w rejestrze xmm: 0, 189, 168, 131

.code
MyProcAsm proc						; RCX <- adres tablicy, RDX <- offset, R8 <- iloœæ bajtów do przetworzenia, R9 <- iloœæ bajtów w wierszu

mov r10, rdx						; offset w r10
mov rdx, 0							; wyzerowanie rdx (potrzebne do dzielenia)
mov rax, r8							; wpisanie iloœci bajtów do rax - przygotowanie do dzielenia
div r9								; dzielenie iloœci bajtów przez iloœæ bajtów w wierszu - wynik (iloœæ wierszy do przetworzenia) w rax
mov r11, rax						; zachowanie informacji o iloœci wierszy do przetworzenia w r11
mov rax, r8							; wpisanie iloœci bajtów do rax - przygotowanie do dzielenia
mov r12, 3							; wpisanie 3 do r12 - przygotowanie do dzielenia
div r12								; dzielenie iloœci bajtów przez 3 - wynik (reszta) w rdx
mov r12, rdx						; zachowanie informacji o reszcie z dzielenia w r12
movdqu xmm6, [max_array]			; wpisanie do xmm6 wartoœci maksymalnych poszczególnych sk³adowych pikseli
movdqu xmm5, [multiply_arrayR]		; wpisanie do xmm5 wspó³czynników sk³adowych koloru R
movdqu xmm4, [multiply_arrayG]		; wpisanie do xmm4 wspó³czynników sk³adowych koloru G
movdqu xmm3, [multiply_arrayB]		; wpisanie do xmm3 wspó³czynników sk³adowych koloru B

loop1:
	sub r11, 1						; odjêcie 1 od iloœci wierszy do przetworzenia
	mov rax, 0						; wpisanie 0 do rax - przygotowanie do porównania
	cmp r11, rax					; porównanie iloœci wierszy
	jl endloop1						; skok do koñca procedury, jeœli wszystkie wiersze zosta³y przetworzone
	mov r13, r9						; kopia iloœci bajtów w wierszu (licznika pêtli)

	loop2:
		sub r13, 3					; odjêcie 3 od iloœci bajtów w wierszu
		mov rax, 0					; wpisanie 0 do rax - przygotowanie do porównania
		cmp r13, rax				; porównanie iloœci bajtów w wierszu
		jl endloop2					; skok do koñca pêtli wewnêtrznej

; ======================================== G£ÓWNY ALGORYTM PROGRAMU ========================================

		xorps xmm0, xmm0						; wyzerowanie rejestru xmm0
		mov byte ptr al, [rcx + r10 + 2]		; wpianie starej wartoœci R do al
		shl rax, 32								; przesuniêcie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10 + 2]		; wpianie starej wartoœci R do al
		vmovq xmm1, rax							; przepisanie wartoœci rax do dolnej czêœci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej czêœci xmm1 do górnej czêœci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm5				; mno¿enie podwójnych s³ów przez odpowiednie wspó³czynniki sepii (R)
		paddd xmm0, xmm2						; dodanie podwójnych s³ów z xmm2 do xmm0

		mov byte ptr al, [rcx + r10 + 1]		; wpianie starej wartoœci G do al
		shl rax, 32								; przesuniêcie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10 + 1]		; wpianie starej wartoœci G do al
		vmovq xmm1, rax							; przepisanie wartoœci rax do dolnej czêœci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej czêœci xmm1 do górnej czêœci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm4				; mno¿enie podwójnych s³ów przez odpowiednie wspó³czynniki sepii (G)
		paddd xmm0, xmm2						; dodanie podwójnych s³ów z xmm2 do xmm0

		mov byte ptr al, [rcx + r10]			; wpianie starej wartoœci B do al
		shl rax, 32								; przesuniêcie rax o 4 bajty w lewo
		mov byte ptr al, [rcx + r10]			; wpianie starej wartoœci B do al
		vmovq xmm1, rax							; przepisanie wartoœci rax do dolnej czêœci xmm1
		movlhps xmm1, xmm1						; przepisanie dolnej czêœci xmm1 do górnej czêœci xmm1
		xorps xmm2, xmm2						; wyzerowanie rejestru xmm2
		vpmulld xmm2, xmm1, xmm3				; mno¿enie podwójnych s³ów przez odpowiednie wspó³czynniki sepii (B)
		paddd xmm0, xmm2						; dodanie podwójnych s³ów z xmm2 do xmm0
		
		psrld xmm0, 10							; podzielenie uzyskanych wyników przez 1024
		pminsd xmm0, xmm6						; wpisanie mniejszej wartoœci spoœród uzyskanej oraz 255

		vmovq rax, xmm0							; przepisanie dolnej czêœci xmm0 do rax
		mov byte ptr [rcx + r10], al			; wpisanie nowej wartoœci B do tablicy
		shr rax, 32								; przesuniêcie rax o 4 bajty w prawo
		mov byte ptr [rcx + r10 + 1], al		; wpisanie nowej wartoœci G do tablicy
		movhlps xmm0, xmm0						; przepisanie górnej czêœci xmm0 do dolnej czêœci xmm0
		vmovq rax, xmm0							; przepisanie dolnej czêœci xmm0 do rax
		mov byte ptr [rcx + r10 + 2], al		; wpisanie nowej wartoœci R do tablicy
		
; ==========================================================================================================

		add r10, 3					; przesuniêcie offsetu o 3
		jmp loop2					; skok do nastêpnej iteracji pêtli wewnêtrznej

	endloop2:
		mov rax, 2					; wpisanie 2 do rax - przygotowanie do porównania
		cmp r12, rax				; porównanie reszty w r12 z 2
		je add_offset1				; skok do dodania 1, jeœli elementy s¹ równe
		mov rax, 1					; wpisanie 1 do rax - przygotowanie do porównania
		cmp r12, rax				; porównianie reszty w r12 z 1
		je add_offset2				; skok do dodania 1, jeœli elementy s¹ równe
		jmp loop1					; skok do kolejnej iteracji pêtli zewnêtrznej

	add_offset1:
		add r10, 1					; dodanie 1 do offsetu
		jmp loop1					; skok do kolejnej iteracji pêtli zewnêtrznej

	add_offset2:
		add r10, 2					; dodanie 2 do offsetu
		jmp loop1					; skok do kolejnej iteracji pêtli zewnêtrznej

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