// Temat projektu:
//      Nak³adanie efektu sepii na zdjêcie w formacie .jpg
//
// Opis algorytmu:
//      Algorytm oblicza nowe wartoœci RGB ka¿dego piksela na podstawie jego starych wartoœci wed³ug wzorów:
//      nowa wartoœæ R = 0.393 * stara wartoœæ R + 0.769 * stara wartoœæ G + 0.189 * stara wartoœæ B
//      nowa wartoœæ G = 0.349 * stara wartoœæ R + 0.686 * stara wartoœæ G + 0.168 * stara wartoœæ B
//      nowa wartoœæ B = 0.272 * stara wartoœæ R + 0.534 * stara wartoœæ G + 0.131 * stara wartoœæ B
//      Jeœli nowa wartoœæ jest wiêksza od 255, to ustawiana jest wartoœæ maksymalna sk³adowej 255.
// 
// 22.11.2023 | semestr 5 | rok akademicki 2023/24 | Musia³ Maciej
//
// Wersja: 2.1
// 1.1 Utworzenie interfejsu u¿ytkownika i do³¹czenie wykonywalnych plików DLL.
// 1.2 Wprowadzenie wielow¹tkowego wywo³ywania funkcji bibliotecznych oraz wczytanie bitmapy z formatu .jpg.
// 1.3 Dodanie algorytmu nak³adaj¹cego efekt sepii w jêzyku C++, przekazanie i modyfikacja danych w asemblerze.
// 1.4 Wprowadzenie równomienrego podzia³u danych na w¹tki.
// 1.5 Dodanie algorytmu nak³adaj¹cego efekt sepii w asemblerze oraz pomiarów czasów.
// 2.1 Dodanie paska postêpu programu.

// dllmain.cpp : Definiuje punkt wejœcia dla aplikacji DLL.

// Parametry wejœciowe:
// adres tablicy (dowolny miejsce w pamiêci),
// offset (miêdzy 0 a wartoœci¹ 3 * szerokoœæ zdjêcia * (iloœæ w¹tków - 1),
// iloœæ bajtów do przetworzenia (miêdzy wartoœci¹ 3 * szerokoœæ zdjêcia * wysokoœæ zdjêcia / 64 a wartoœci¹ 3 * szerokoœæ zdjêcia * wysokoœæ zdjêcia),
// iloœæ bajtów w wierszu (3 * szerokoœæ wiersza)
// Parametry wyjœciowe:
// brak

#include "pch.h"

#define EXPORTED_METHOD extern "C" __declspec(dllexport)
EXPORTED_METHOD
void MyProcCpp(char* data, int offset, int amount, int stride)
{
    int number_of_rows = amount / stride;                                       // wyliczenie iloœci wierszy do przetworzenia w danym w¹tku
    int rest = stride % 3;                                                      // wyliczenie reszty z dzielenia bitmapy
                                                                                // (sprawdzenie, czy zosta³y dodane zerowe bajty dla wyrównania bitmapy na koñcu wiersza)
    for (int i = 0; i < number_of_rows; i++)                                    // pêtla zewnêtrzna iteruj¹ca po wierszach
    {
        for (int j = 0; j < stride; j += 3)                                     // pêtla wewnêtrzna iteruj¹ca po pikselach w wierszu
        {
            BYTE oldB = data[offset];                                           // odczytanie starej wartoœci B
            BYTE oldG = data[offset + 1];                                       // odczytanie starej wartoœci G
            BYTE oldR = data[offset + 2];                                       // odczytanie starej wartoœci R

            BYTE newR = min(0.393 * oldR + 0.769 * oldG + 0.189 * oldB, 255);   // obliczenie nowej wartoœci R wed³ug algorytmu
            BYTE newG = min(0.349 * oldR + 0.686 * oldG + 0.168 * oldB, 255);   // obliczenie nowej wartoœci G wed³ug algorytmu
            BYTE newB = min(0.272 * oldR + 0.534 * oldG + 0.131 * oldB, 255);   // obliczenie nowej wartoœci B wed³ug algorytmu

            data[offset] = newB;                                                // zapisanie nowej wartoœci B
            data[offset + 1] = newG;                                            // zapisanie nowej wartoœci G
            data[offset + 2] = newR;                                            // zapisanie nowej wartoœci R
            offset += 3;                                                        // przesuniêcie licznika pikseli na nastêpny piksel
        }
        if (rest == 1) offset -= 2;                                             // ustawienie licznika pikseli na pocz¹tek kolejnego piksela,
                                                                                // jeœli zosta³ dodany jeden piksel
        else if (rest == 2) offset--;                                           // ustawienie licznika pikseli na pocz¹tek kolejnego piksela,
                                                                                // jeœli zosta³y dodane dwa piksele
    }
}