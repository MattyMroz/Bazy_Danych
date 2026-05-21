PROJEKT RBD

Projekt rozproszonej bazy danych powinien zawierać opracowaną strukturę składającą się z części baz umieszczonych na kilku serwerach w środowisku heterogenicznym (np. w środowisku dwóch serwerów MS SQLServer oraz serwera Oracle). Projekt rozproszonej bazy danych powinien zawierać:

1. Opracowanie struktury RBD (podział obiektów w tym tabel, procedur, widoków) na różne serwery w środowisku rozporoszonym oraz opis uzasadnienia tego podziału.

2. Wykorzystanie zapytań AD HOC – funkcja OPENROWSET w dostępie do zdalnych źródeł danych z przetwarzaniem danych po stronie serwera zdalnego i serwera lokalnego:

    - dostęp SQLServer – SQLServer

    - dostęp SQLServer – ORACLE

    - dostęp SQLServer – Access

    - dostęp SQLServer – *.xls

 - wielodostęp w dowolnej konfiguracji SQLServer - ORACLE_Access, *.xls (sprzeganie jednoocześnie różnych źródeł danych)

- dostęp do zdalnych źródeł powinien odbywać się przez pisanie widoków i procedur rozproszonych (rzutowanie różnych typów danych i posługiwanie się funkcjami agregującymi zdalnymi i lokalnymi)

- przetwarzanie zdalne i lokalne w widokach i procedurach

3. Ustanawiania serwerów połączonych (linkowanie zdalnych serwerów) w środowisku SQLServer oraz mapowania praw loginu lokalnego na prawa loginu zdalnego (funkcje sprawdzające źródła zdalne i ich konfigurację) :

    - linkowanie serwerów: SQLServer – SQLServer

    - linkowanie serwerów:  SQLServer – ORACLE (tylko od strony SQL Server do Oracle)

    - linkowanie serwerów:  SQLServer – Access

    - linkowanie serwerów:  SQLServer – *.xls

 - dostęp do zdalnych źródeł powinien odbywać się przez pisanie widoków i procedur rozproszonych  przy ustanowionych serwerach zdalnych (wielodostęp w środowiskach heterogenicznych)

 4. Pisanie (przy ustanowionym serwerze połączonym) zapytań przekazujących– (przetwarzanie lokalne i zdalne danych) w tym z zastosowaniem funkcji: OPENQUERY

5. Wstawianie i modyfikowanie danych na zdalnych źródłach danych z poziomu ustanowionego serwera połączonego

6. Podstawy transakcji rozproszonych. Wykonywanie Transakcji rozproszonych (Begin Distributed Transaction) - wyjaśnienie działania takich transakcji z wykorzystaniem MS Distributed Transaction Coordinator (MS DTC) - konfiguracja MS DTC.

7.  Projekt powinien również uwzględniać replikowanie danych: (Replikacje) do wyboru :

 - Replikacja transakcyjna

 - Replikacja migawkowa

 - Replikacja uzgadniana

Od strony serwera ORACLE w projekcie RBD należy przewidzieć odpowiedni zakres uprawnień i użytkowników:

8. ORACLE - użytkownicy, prawa, role

9. W systemie ORACLE należy również zasymulować pracę z danymi rozproszonymi w środowisku tzn. uchwytami database link

 - linki prywatne

- linki publiczne

10. Symulacja ustanawiania zdalnych źródeł danych  (po założeniu wielu użytkowników w ORACLE - przez linki bazodanowe)

11. Pisanie niemodyfikowalnych widoków rozproszonych w ORACLE z database linkami -umożliwiających pracę na danych lokalnych i zdalnych (pamiętając o prawidłowym rzutowaniu typów.

12. Pisanie wyzwalaczy INSTEAD OF do widoków rozproszonych

13. Pisanie procedur składowanych ORACLE

\documentclass[12pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[polish]{babel}
\usepackage{geometry}
\usepackage{graphicx}
\usepackage{array}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage{amssymb}
\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows.meta, positioning}
\usepackage[hidelinks]{hyperref}
\usepackage{longtable}

\geometry{margin=2.5cm}

\begin{document}

% =============================================================================
% STRONA TYTULOWA
% =============================================================================
\begin{titlepage}
    \centering
    \vspace*{1cm}
    
    \Large\textbf{Politechnika Łódzka}\\[0.3cm]
    {\large Wydział Elektrotechniki, Elektroniki, Informatyki i Automatyki}\\[2cm]
    
    {\Huge\textbf{Szkoła Muzyczna I Stopnia}}\\[0.5cm]
    {\Large Obiektowa Baza Danych Oracle}\\[1cm]
    
    {\large Rozproszone i Obiektowe Bazy Danych}\\[3cm]
    
    \begin{tabular}{ll}
        \textbf{Autorzy:} & Igor Typiński (251237) \\
                          & Mateusz Mróz (251190) \\[0.5cm]
        \textbf{Grupa:}   & 5 \\[0.5cm]
        \textbf{Temat:}   & Szkoła muzyczna (z naciskiem na rozwój ucznia)
    \end{tabular}
    
    \vfill
    {\large Łódź, luty 2026}
\end{titlepage}

% =============================================================================
% SPIS TRESCI
% =============================================================================
\tableofcontents
\newpage

% =============================================================================
% 1. OPIS PROJEKTU
% =============================================================================
\section{Opis projektu}

\subsection{Cel i zakres}

Projekt przedstawia obiektową bazę danych dla~szkoły muzycznej I~stopnia, ze~szczególnym uwzględnieniem śledzenia rozwoju uczniów. Szkoła prowadzi nauczanie gry na~instrumentach w~trybie indywidualnym oraz zajęcia grupowe (kształcenie słuchu, rytmika). System został zaprojektowany z~myślą o~codziennej pracy sekretariatu, nauczycieli, dyrekcji szkoły oraz samych uczniów i~ich rodziców.

Głównym celem projektu jest stworzenie kompleksowego systemu informatycznego umożliwiającego:

\begin{itemize}
    \item \textbf{Zarządzanie danymi uczniów} -- rejestracja nowych uczniów, przechowywanie danych osobowych, automatyczne obliczanie wieku, przypisanie do~grupy (klasy)
    
    \item \textbf{Zarządzanie danymi nauczycieli} -- ewidencja kadry pedagogicznej, każdy nauczyciel uczy jednego przedmiotu
    
    \item \textbf{Planowanie lekcji} -- tworzenie harmonogramu zajęć indywidualnych (1~uczeń) i~grupowych (cała klasa) z~walidacją konfliktów terminów oraz heurystyką sugestii wolnego terminu
    
    \item \textbf{Rezerwacja sal lekcyjnych} -- przydzielanie sal z~odpowiednim wyposażeniem (przechowywane jako VARRAY) do~poszczególnych lekcji
    
    \item \textbf{Ocenianie postępu uczniów} -- wystawianie ocen cząstkowych i~semestralnych z~walidacją uprawnień nauczyciela
    
    \item \textbf{Kontrola reguł biznesowych} -- automatyczna walidacja uczestników lekcji (albo~uczeń albo~grupa), zakresu ocen, konfliktów czasowych, kompetencji nauczycieli
    
    \item \textbf{Generowanie raportów} -- plan dnia, plan ucznia, plan nauczyciela, raport grup, statystyki szkoły
\end{itemize}

System uwzględnia specyfikę szkoły muzycznej I~stopnia z~6-letnim cyklem nauczania. Lekcje odbywają się w~godzinach popołudniowych (14:00--20:00), co~odpowiada potrzebom uczniów uczęszczających równolegle do~szkoły ogólnokształcącej.

\subsection{Przyjęte ograniczenia}

W projekcie przyjęto następujące ograniczenia biznesowe:

\begin{enumerate}
    \item \textbf{Cykl nauczania:} 6~lat -- klasy I-VI szkoły muzycznej I~stopnia
    
    \item \textbf{Godziny pracy szkoły:} 14:00--20:00 -- lekcje mogą być planowane tylko w~tych godzinach
    
    \item \textbf{Dni pracy szkoły:} poniedziałek--piątek -- szkoła nie~prowadzi zajęć w~weekendy
    
    \item \textbf{Czas trwania lekcji:} stały 45~minut dla~wszystkich zajęć
    
    \item \textbf{Siatka godzinowa:} lekcje rozpoczynają się o~pełnych godzinach (14:00, 15:00, 16:00...)
    
    \item \textbf{Jeden instrument na~ucznia:} każdy uczeń uczy się jednego instrumentu głównego
    
    \item \textbf{Jeden przedmiot na~nauczyciela:} każdy nauczyciel uczy jednego przedmiotu
    
    \item \textbf{XOR lekcji:} lekcja jest ALBO~indywidualna (1~uczeń) ALBO~grupowa (klasa) -- nigdy obie opcje jednocześnie
    
    \item \textbf{Maksymalne wyposażenie sali:} 10~elementów (ograniczenie VARRAY)
    
    \item \textbf{Skala ocen:} 1--6 (polska skala szkolna)
    
    \item \textbf{Typy sal:} indywidualna lub~grupowa
    
    \item \textbf{Typy przedmiotów:} indywidualny (instrument) lub~grupowy (kształcenie słuchu, rytmika)
    
    \item \textbf{Brak konfliktów czasowych:} ta sama sala, nauczyciel, uczeń lub~grupa nie~mogą mieć dwóch lekcji w~tym samym czasie
    
    \item \textbf{Walidacja kompetencji:} nauczyciel może prowadzić tylko lekcje z~przedmiotu, który jest do~niego przypisany
    
    \item \textbf{Walidacja typu sali:} lekcje grupowe wymagają sali typu~'grupowa'
    
    \item \textbf{Zgodność typu przedmiotu z~typem lekcji:} przedmiot indywidualny (np.~Fortepian) może być prowadzony tylko jako~lekcja indywidualna, przedmiot grupowy (np.~Kształcenie słuchu) może być prowadzony tylko jako~lekcja grupowa
    
    \item \textbf{Brak limitów godzin:} system nie~narzuca limitów tygodniowych liczby lekcji dla~nauczyciela lub~ucznia (jedynym ograniczeniem jest dostępność czasowa i~brak konfliktów w~planie)
    
    \item \textbf{Synonimiczność instrumentów:} system automatycznie uznaje "Pianino" i~"Fortepian" za~ten sam instrument przy~sprawdzaniu wyposażenia sal i~uprawnień ucznia
    
    \item \textbf{Wyłączność oceniania:} nauczyciel może wystawiać oceny wyłącznie z~przedmiotu, do~którego jest przypisany w~systemie
    
    \item \textbf{Zgodność instrumentu przy~ocenianiu:} dla~przedmiotów indywidualnych nauczyciel może wystawić ocenę tylko uczniowi, którego instrument główny odpowiada ocenianemu przedmiotowi (np.~ocena z~Fortepianu tylko dla~uczniów grających na~Fortepianie)
    
    \item \textbf{Logika średniej ocen:} średnia ocen z~przedmiotu obliczana jest automatycznie z~wyłączeniem ocen semestralnych
    
    \item \textbf{Horyzont planowania:} heurystyka doboru wolnych terminów przeszukuje grafik w~przód na~maksymalnie 7~dni od~podanej daty
\end{enumerate}

\subsection{Technologia}

\begin{itemize}
    \item \textbf{Oracle Database} -- obiektowo-relacyjna baza danych
    \item \textbf{Podejście obiektowo-relacyjne} -- typy obiektowe z metodami, REF/DEREF, VARRAY
    \item \textbf{Język PL/SQL} -- pakiety, procedury, funkcje, triggery
\end{itemize}

% =============================================================================
% 2. TYPY OBIEKTOWE
% =============================================================================
\newpage
\section{Typy obiektowe}

W~projekcie zdefiniowano 8~typów obiektowych z~łącznie 10~metodami.

\begin{table}[h]
\centering
\begin{tabular}{|l|c|p{7cm}|}
\hline
\textbf{Typ} & \textbf{Metody} & \textbf{Opis} \\
\hline
t\_wyposazenie & -- & VARRAY(10) nazw elementów wyposażenia \\
t\_przedmiot & 1 & Przedmiot nauczania (indywidualny/grupowy) \\
t\_grupa & -- & Klasa uczniów (symbol, poziom I-VI) \\
t\_nauczyciel & 2 & Nauczyciel z~REF do~przedmiotu \\
t\_sala & 2 & Sala lekcyjna z~VARRAY wyposażenia \\
t\_uczen & 2 & Uczeń z~REF do~grupy \\
t\_lekcja & 2 & Lekcja z~wyborem: REF do~ucznia lub~grupy \\
t\_ocena & 1 & Ocena postępu ucznia \\
\hline
\multicolumn{2}{|r|}{\textbf{Razem:}} & \textbf{8 typów, 10 metod} \\
\hline
\end{tabular}
\caption{Typy obiektowe w projekcie}
\end{table}

\subsection{t\_wyposazenie}

Kolekcja VARRAY przechowująca nazwy elementów wyposażenia sali lekcyjnej.

\texttt{CREATE OR REPLACE TYPE t\_wyposazenie AS VARRAY(10) OF VARCHAR2(50);}

Ograniczenie do~10~elementów wynika z~założenia, że~sala ma~skończoną liczbę istotnych elementów wyposażenia (fortepian, metronom, lustro, pulpity itp.). Kolekcja przeszukiwana jest przez~funkcję prywatną \texttt{sala\_ma\_instrument()} przy~planowaniu lekcji.

\subsection{t\_przedmiot}

Reprezentuje przedmiot nauczania w słowniku przedmiotów.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item nazwa (VARCHAR2(50)) -- nazwa przedmiotu (np.~Fortepian, Kształcenie słuchu)
    \item typ (VARCHAR2(20)) -- typ: 'indywidualny' lub~'grupowy'
    \item czas\_min (NUMBER) -- czas trwania lekcji (stałe 45 minut)
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item czy\_grupowy() RETURN VARCHAR2 -- zwraca 'T' jeśli typ = 'grupowy', inaczej 'N'
\end{itemize}

\subsection{t\_grupa}

Reprezentuje klasę (grupę) uczniów w~szkole muzycznej.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item symbol (VARCHAR2(10)) -- symbol grupy (np.~'1A', '2A', '3A')
    \item poziom (NUMBER) -- poziom klasy 1-6 (klasa I-VI szkoły muzycznej)
\end{itemize}

Typ nie posiada metod -- jest prostym kontenerem danych słownikowych.

\subsection{t\_nauczyciel}

Reprezentuje nauczyciela szkoły muzycznej wraz z~referencją do~przedmiotu.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item imie (VARCHAR2(50)) -- imię nauczyciela
    \item nazwisko (VARCHAR2(50)) -- nazwisko nauczyciela
    \item data\_zatr (DATE) -- data zatrudnienia
    \item ref\_przedmiot (REF t\_przedmiot) -- referencja do~przedmiotu który~uczy
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item pelne\_nazwisko() RETURN VARCHAR2 -- zwraca imię i nazwisko
    \item staz\_lat() RETURN NUMBER -- oblicza liczbę lat pracy w szkole
\end{itemize}

\subsection{t\_sala}

Reprezentuje salę lekcyjną z kolekcją VARRAY wyposażenia.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item numer (VARCHAR2(10)) -- numer sali (np.~'101', '102')
    \item typ (VARCHAR2(20)) -- typ: 'indywidualna' lub~'grupowa'
    \item pojemnosc (NUMBER) -- maksymalna liczba osób
    \item wyposazenie (t\_wyposazenie) -- VARRAY elementów wyposażenia
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item czy\_grupowa() RETURN VARCHAR2 -- zwraca 'T' jeśli typ = 'grupowa', inaczej 'N'
    \item lista\_wyposazenia() RETURN VARCHAR2 -- zwraca wyposażenie jako tekst rozdzielony przecinkami (iteracja po VARRAY)
\end{itemize}

\subsection{t\_uczen}

Reprezentuje ucznia szkoły muzycznej z referencją do grupy.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item imie (VARCHAR2(50)) -- imię ucznia
    \item nazwisko (VARCHAR2(50)) -- nazwisko ucznia
    \item data\_ur (DATE) -- data urodzenia
    \item instrument (VARCHAR2(50)) -- instrument główny (np.~Fortepian, Skrzypce)
    \item ref\_grupa (REF t\_grupa) -- referencja do~grupy (klasy)
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item pelne\_nazwisko() RETURN VARCHAR2 -- zwraca imię i nazwisko
    \item wiek() RETURN NUMBER -- oblicza aktualny wiek w latach
\end{itemize}

\subsection{t\_lekcja}

Reprezentuje pojedynczą lekcję muzyki z~wyborem uczestnika (albo~uczeń albo~grupa).

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item ref\_przedmiot (REF t\_przedmiot) -- referencja do~przedmiotu
    \item ref\_nauczyciel (REF t\_nauczyciel) -- referencja do~nauczyciela
    \item ref\_sala (REF t\_sala) -- referencja do~sali
    \item ref\_uczen (REF t\_uczen) -- referencja do~ucznia (lekcja indywidualna)
    \item ref\_grupa (REF t\_grupa) -- referencja do~grupy (lekcja grupowa)
    \item data\_lekcji (DATE) -- data lekcji
    \item godz\_rozp (NUMBER) -- godzina rozpoczęcia (14, 15, 16... -- pełne godziny)
    \item czas\_min (NUMBER) -- czas trwania w minutach (stałe 45)
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item godzina\_koniec() RETURN NUMBER -- oblicza godzinę zakończenia (np. 14.75 dla lekcji 14:00-14:45)
    \item czy\_indywidualna() RETURN VARCHAR2 -- zwraca 'T' jeśli ref\_uczen IS NOT NULL, inaczej 'N'
\end{itemize}

\textbf{Reguła przypisania:} Lekcja musi mieć wypełnione ALBO~ref\_uczen (lekcja indywidualna) ALBO~ref\_grupa (lekcja grupowa), nigdy oba jednocześnie i~nigdy żadne. Walidowane przez~trigger \texttt{trg\_lekcja\_xor}.

\subsection{t\_ocena}

Reprezentuje ocenę postępu ucznia.

\textbf{Atrybuty:}
\begin{itemize}[nosep]
    \item id (NUMBER) -- unikalny identyfikator
    \item ref\_uczen (REF t\_uczen) -- referencja do~ucznia
    \item ref\_nauczyciel (REF t\_nauczyciel) -- referencja do~nauczyciela wystawiającego
    \item ref\_przedmiot (REF t\_przedmiot) -- referencja do~przedmiotu
    \item wartosc (NUMBER) -- wartość oceny 1--6
    \item data\_oceny (DATE) -- data wystawienia oceny
    \item semestralna (VARCHAR2(1)) -- 'T' dla~oceny semestralnej, 'N' dla~cząstkowej
\end{itemize}

\textbf{Metody:}
\begin{itemize}[nosep]
    \item opis\_oceny() RETURN VARCHAR2 -- zwraca ocenę słownie (celujący, bardzo dobry, dobry, dostateczny, dopuszczający, niedostateczny)
\end{itemize}

% =============================================================================
% 3. TABELE OBIEKTOWE
% =============================================================================
\newpage
\section{Tabele obiektowe}

Utworzono 7 tabel obiektowych przechowujących dane.

\begin{table}[h]
\centering
\begin{tabular}{|l|l|l|}
\hline
\textbf{Tabela} & \textbf{Typ bazowy} & \textbf{Referencje / Kolekcje} \\
\hline
przedmioty & t\_przedmiot & -- \\
grupy & t\_grupa & -- \\
nauczyciele & t\_nauczyciel & ref\_przedmiot \\
sale & t\_sala & zawiera VARRAY (wyposazenie) \\
uczniowie & t\_uczen & ref\_grupa \\
lekcje & t\_lekcja & ref\_przedmiot, ref\_nauczyciel, ref\_sala, \\
       &           & ref\_uczen (indyw.), ref\_grupa (grup.) \\
oceny & t\_ocena & ref\_uczen, ref\_nauczyciel, ref\_przedmiot \\
\hline
\end{tabular}
\caption{Tabele obiektowe i ich referencje}
\end{table}

\subsection{przedmioty}

Słownik przedmiotów nauczania.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenie UNIQUE: nazwa
    \item Ograniczenia NOT NULL: nazwa, typ, czas\_min
    \item CHECK: typ IN ('indywidualny', 'grupowy')
    \item CHECK: czas\_min = 45
\end{itemize}

\subsection{grupy}

Słownik grup (klas) uczniów.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenie UNIQUE: symbol
    \item Ograniczenia NOT NULL: symbol, poziom
    \item CHECK: poziom BETWEEN 1 AND 6
\end{itemize}

\subsection{nauczyciele}

Dane nauczycieli z referencją do~przedmiotu.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenia NOT NULL: imie, nazwisko, data\_zatr
    \item Referencja: ref\_przedmiot → przedmioty
\end{itemize}

\subsection{sale}

Informacje o salach lekcyjnych z kolekcją VARRAY wyposażenia.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenie UNIQUE: numer
    \item Ograniczenia NOT NULL: numer, typ, pojemnosc
    \item CHECK: typ IN ('indywidualna', 'grupowa')
    \item CHECK: pojemnosc > 0
    \item Zawiera kolekcję t\_wyposazenie (VARRAY)
\end{itemize}

\subsection{uczniowie}

Dane uczniów szkoły muzycznej z referencją do~grupy.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenia NOT NULL: imie, nazwisko, data\_ur, instrument
    \item Referencja: ref\_grupa → grupy
\end{itemize}

\subsection{lekcje}

Zaplanowane lekcje muzyki z~wyborem typu uczestnictwa.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenia NOT NULL: data\_lekcji, godz\_rozp, czas\_min
    \item CHECK: godz\_rozp BETWEEN 14 AND 19
    \item CHECK: czas\_min = 45
    \item Referencje: ref\_przedmiot, ref\_nauczyciel, ref\_sala
    \item Relacja uczestników: ref\_uczen (dla~indywidualnych), ref\_grupa (dla~grupowych)
    \item Trigger: trg\_lekcja\_xor wymusza poprawność danych
\end{itemize}

\subsection{oceny}

Oceny postępu uczniów.

\begin{itemize}[nosep]
    \item Klucz główny: id
    \item Ograniczenia NOT NULL: wartosc, data\_oceny, semestralna
    \item CHECK: wartosc BETWEEN 1 AND 6
    \item CHECK: semestralna IN ('T', 'N')
    \item Referencje: ref\_uczen, ref\_nauczyciel, ref\_przedmiot
\end{itemize}

\subsection{Referencje (REF/DEREF)}

W~projekcie zastosowano 9~referencji do~modelowania relacji między~obiektami:

\begin{itemize}[nosep]
    \item Nauczyciel wskazuje na~przedmiot, którego uczy (1~REF)
    \item Uczeń wskazuje na~grupę, do~której należy (1~REF)
    \item Lekcja wskazuje na~przedmiot, nauczyciela, salę oraz ucznia lub~grupę (4-5~REF)
    \item Ocena wskazuje na~ucznia, nauczyciela i~przedmiot (3~REF)
\end{itemize}

Dzięki DEREF możliwe jest odwołanie się do atrybutów i metod obiektu wskazywanego:

\texttt{SELECT DEREF(l.ref\_uczen).pelne\_nazwisko() AS uczen,}

\texttt{\hspace{1.5cm}DEREF(l.ref\_sala).numer AS sala,}

\texttt{\hspace{1.5cm}DEREF(l.ref\_przedmiot).nazwa AS przedmiot}

\texttt{FROM lekcje l WHERE l.ref\_uczen IS NOT NULL;}

\subsection{Sekwencje}

Utworzono 7 sekwencji do generowania identyfikatorów:

\begin{itemize}[nosep]
    \item seq\_przedmioty -- dla tabeli przedmioty
    \item seq\_grupy -- dla tabeli grupy
    \item seq\_nauczyciele -- dla tabeli nauczyciele
    \item seq\_sale -- dla tabeli sale
    \item seq\_uczniowie -- dla tabeli uczniowie
    \item seq\_lekcje -- dla tabeli lekcje
    \item seq\_oceny -- dla tabeli oceny
\end{itemize}

% =============================================================================
% 4. PAKIETY PL/SQL
% =============================================================================
\newpage
\section{Pakiety PL/SQL}

Logika biznesowa zaimplementowana w~5~pakietach z~łącznie 25~podprogramami.

\begin{table}[h]
\centering
\begin{tabular}{|l|c|p{7cm}|}
\hline
\textbf{Pakiet} & \textbf{Podprogramy} & \textbf{Funkcjonalności} \\
\hline
pkg\_slowniki & 9 & Zarządzanie słownikami (przedmioty, grupy, sale) \\
pkg\_osoby & 7 & Zarządzanie nauczycielami i uczniami \\
pkg\_lekcje & 5 (+4 prywatne) & Planowanie lekcji z walidacją i heurystyką \\
pkg\_oceny & 4 (+1 prywatna) & Zarządzanie ocenami \\
pkg\_raporty & 2 & Raporty i statystyki \\
\hline
\multicolumn{2}{|r|}{\textbf{Razem:}} & \textbf{25 podprogramów publicznych} \\
\hline
\end{tabular}
\caption{Pakiety PL/SQL}
\end{table}

\subsection{pkg\_slowniki}

Pakiet do zarządzania słownikami (przedmioty, grupy, sale).

\textbf{Procedury dodawania:}
\begin{itemize}[nosep]
    \item dodaj\_przedmiot(p\_nazwa, p\_typ) -- dodaje przedmiot do~słownika
    \item dodaj\_grupe(p\_symbol, p\_poziom) -- dodaje grupę (klasę)
    \item dodaj\_sale(p\_numer, p\_typ, p\_pojemnosc, p\_wyposazenie) -- dodaje salę z~VARRAY wyposażenia
\end{itemize}

\textbf{Funkcje pobierania referencji:}
\begin{itemize}[nosep]
    \item get\_ref\_przedmiot(p\_id) RETURN REF t\_przedmiot
    \item get\_ref\_grupa(p\_id) RETURN REF t\_grupa
    \item get\_ref\_sala(p\_id) RETURN REF t\_sala
\end{itemize}

\textbf{Procedury listowania:}
\begin{itemize}[nosep]
    \item lista\_przedmiotow() -- wyświetla listę przedmiotów
    \item lista\_grup() -- wyświetla listę grup
    \item lista\_sal() -- wyświetla listę sal z wyposażeniem (wywołuje metodę lista\_wyposazenia())
\end{itemize}

\subsection{pkg\_osoby}

Pakiet do zarządzania nauczycielami i uczniami.

\textbf{Procedury dodawania:}
\begin{itemize}[nosep]
    \item dodaj\_nauczyciela(p\_imie, p\_nazwisko, p\_id\_przedmiotu) -- dodaje nauczyciela z~REF do~przedmiotu
    \item dodaj\_ucznia(p\_imie, p\_nazwisko, p\_data\_ur, p\_instrument, p\_id\_grupy) -- dodaje ucznia z~REF do~grupy
\end{itemize}

\textbf{Funkcje pobierania referencji:}
\begin{itemize}[nosep]
    \item get\_ref\_nauczyciel(p\_id) RETURN REF t\_nauczyciel
    \item get\_ref\_uczen(p\_id) RETURN REF t\_uczen
\end{itemize}

\textbf{Procedury listowania:}
\begin{itemize}[nosep]
    \item lista\_nauczycieli() -- wyświetla nauczycieli z~przedmiotami (DEREF)
    \item lista\_uczniow() -- wyświetla uczniów z~grupami (DEREF)
    \item lista\_uczniow\_grupy(p\_id\_grupy) -- wyświetla uczniów danej grupy (\textbf{kursor jawny} OPEN/FETCH/CLOSE)
\end{itemize}

\subsection{pkg\_lekcje}

Pakiet do zarządzania lekcjami z pełną walidacją konfliktów i heurystyką sugestii terminu.

\textbf{Procedury publiczne:}
\begin{itemize}[nosep]
    \item dodaj\_lekcje\_indywidualna(...) -- planuje lekcję indywidualną z walidacją
    \item dodaj\_lekcje\_grupowa(...) -- planuje lekcję grupową z walidacją
    \item plan\_ucznia(p\_id\_ucznia) -- wyświetla plan ucznia (UNION lekcji indywidualnych i~grupowych)
    \item plan\_nauczyciela(p\_id\_nauczyciela) -- wyświetla plan nauczyciela
    \item plan\_dnia(p\_data) -- wyświetla wszystkie lekcje w~danym dniu
\end{itemize}

\textbf{Funkcje prywatne:}
\begin{itemize}[nosep]
    \item czy\_weekend(p\_data) -- sprawdza czy data wypada w sobotę lub niedzielę
    \item sprawdz\_kolizje(...) -- sprawdza dostępność sali, nauczyciela, ucznia/grupy
    \item sala\_ma\_instrument(p\_id\_sali, p\_instrument) -- przeszukuje \textbf{VARRAY} wyposażenia sali
    \item znajdz\_alternatywe(...) -- \textbf{heurystyka First Fit} szukająca wolnego terminu (pomija weekendy)
\end{itemize}

\textbf{Walidacje w procedurze dodaj\_lekcje\_indywidualna:}
\begin{itemize}[nosep]
    \item Data nie może wypadać w~weekend (sobota/niedziela)
    \item Kompetencje nauczyciela (czy uczy tego przedmiotu -- sprawdzenie REF)
    \item Zgodność instrumentu ucznia z~przedmiotem
    \item Konflikt sali -- brak nakładających się terminów
    \item Konflikt nauczyciela -- brak nakładających się terminów
    \item Konflikt ucznia -- brak nakładających się terminów
\end{itemize}

\textbf{Dodatkowe walidacje w procedurze dodaj\_lekcje\_grupowa:}
\begin{itemize}[nosep]
    \item Data nie może wypadać w~weekend (sobota/niedziela)
    \item Typ sali -- lekcja grupowa wymaga sali typu 'grupowa'
    \item Przepełnienie sali -- pojemność >= liczba uczniów w~grupie
    \item Konflikt grupy -- brak nakładających się terminów
\end{itemize}

\subsection{pkg\_oceny}

Pakiet do zarządzania ocenami postępu uczniów.

\textbf{Procedury publiczne:}
\begin{itemize}[nosep]
    \item wystaw\_ocene(p\_id\_ucznia, p\_id\_nauczyciela, p\_id\_przedmiotu, p\_wartosc) -- ocena cząstkowa
    \item wystaw\_ocene\_semestralna(...) -- ocena semestralna (semestralna='T')
    \item oceny\_ucznia(p\_id\_ucznia) -- wyświetla wszystkie oceny ucznia z~opisem słownym
\end{itemize}

\textbf{Funkcja publiczna:}
\begin{itemize}[nosep]
    \item srednia\_ucznia(p\_id\_ucznia, p\_id\_przedmiotu) RETURN NUMBER -- średnia ocen cząstkowych (0~gdy brak)
\end{itemize}

\textbf{Procedura prywatna:}
\begin{itemize}[nosep]
    \item sprawdz\_uprawnienia\_oceniania(...) -- waliduje czy nauczyciel uczy danego przedmiotu
\end{itemize}

\subsection{pkg\_raporty}

Pakiet do generowania raportów i statystyk.

\textbf{Procedury:}
\begin{itemize}[nosep]
    \item raport\_grup() -- wyświetla liczbę uczniów w~każdej grupie (podzapytanie skorelowane)
    \item statystyki() -- wyświetla ogólne statystyki szkoły (liczba uczniów, nauczycieli, grup, sal, lekcji, ocen)
\end{itemize}

% =============================================================================
% 5. WYZWALACZE
% =============================================================================
\newpage
\section{Wyzwalacze (Triggery)}

Zdefiniowano 2~wyzwalacze realizujące krytyczne reguły biznesowe. Walidacja konfliktów terminów jest zaimplementowana w~pakiecie \texttt{pkg\_lekcje}, aby~uniknąć błędu ORA-04091 (Mutating Table).

\begin{table}[h]
\centering
\small
\begin{tabular}{|l|l|p{6cm}|}
\hline
\textbf{Trigger} & \textbf{Typ} & \textbf{Działanie} \\
\hline
trg\_lekcja\_xor & BEFORE INSERT/UPDATE & Weryfikacja uczestników: lekcja musi mieć ALBO~ucznia ALBO~grupę (nigdy oba, nigdy żadne) \\
\hline
trg\_ocena\_zakres & BEFORE INSERT/UPDATE & Walidacja zakresu ocen 1-6 z przyjaznym komunikatem błędu \\
\hline
\end{tabular}
\caption{Wyzwalacze w projekcie}
\end{table}

\subsection{trg\_lekcja\_xor}

Trigger wymuszający poprawność przypisania uczestników dla lekcji:

\begin{verbatim}
CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON lekcje
FOR EACH ROW
BEGIN
    IF (:NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL) OR
       (:NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Lekcja musi miec ALBO ucznia (indywidualna) ALBO grupe (grupowa)');
    END IF;
END;
\end{verbatim}

\subsection{trg\_ocena\_zakres}

Trigger walidujący zakres ocen z przyjaznym komunikatem:

\begin{verbatim}
CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON oceny
FOR EACH ROW
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Ocena musi byc w zakresie 1-6. Podano: ' || :NEW.wartosc);
    END IF;
END;
\end{verbatim}

% =============================================================================
% 6. OBSLUGA BLEDOW
% =============================================================================
\newpage
\section{Obsługa błędów}

W projekcie zastosowano mechanizmy obsługi wyjątków z własnymi kodami błędów.

\subsection{Kody błędów aplikacji}

\begin{table}[h]
\centering
\small
\begin{tabular}{|c|l|p{6cm}|}
\hline
\textbf{Kod} & \textbf{Źródło} & \textbf{Znaczenie} \\
\hline
-20001 & trg\_lekcja\_xor & Nieprawidłowe przypisanie uczestników (lekcja musi mieć ucznia LUB~grupę) \\
\hline
-20002 & trg\_ocena\_zakres & Ocena poza zakresem 1-6 \\
\hline
-20003 & pkg\_slowniki.get\_ref\_przedmiot & Nie znaleziono przedmiotu o podanym ID \\
\hline
-20004 & pkg\_slowniki.get\_ref\_grupa & Nie znaleziono grupy o podanym ID \\
\hline
-20005 & pkg\_slowniki.get\_ref\_sala & Nie znaleziono sali o podanym ID \\
\hline
-20006 & pkg\_osoby.get\_ref\_nauczyciel & Nie znaleziono nauczyciela o podanym ID \\
\hline
-20007 & pkg\_osoby.get\_ref\_uczen & Nie znaleziono ucznia o podanym ID \\
\hline
-20008 & pkg\_lekcje.dodaj\_lekcje\_indywidualna & Konflikt terminów (+ sugestia alternatywy) \\
\hline
-20009 & pkg\_lekcje.dodaj\_lekcje\_grupowa & Konflikt terminów (+ sugestia alternatywy) \\
\hline
-20010 & pkg\_lekcje & Nauczyciel nie uczy podanego przedmiotu \\
\hline
-20011 & pkg\_lekcje & Lekcja grupowa w sali indywidualnej \\
\hline
-20012 & pkg\_lekcje & Instrument ucznia niezgodny z przedmiotem \\
\hline
-20013 & pkg\_oceny & Nauczyciel nie ma uprawnień do oceniania \\
\hline
-20014 & pkg\_lekcje & Przepełnienie sali (grupa > pojemność) \\
\hline
-20015 & pkg\_lekcje & Przedmiot grupowy nie może być prowadzony jako lekcja indywidualna \\
\hline
-20016 & pkg\_lekcje & Przedmiot indywidualny nie może być prowadzony jako lekcja grupowa \\
\hline
-20017 & pkg\_oceny & Próba wystawienia oceny z przedmiotu uczniowi grającemu na innym instrumencie \\
\hline
-20018 & pkg\_lekcje & Lekcja zaplanowana na weekend (sobota/niedziela) \\
\hline
\end{tabular}
\caption{Kody błędów aplikacji}
\end{table}

\subsection{Przykład komunikatu z sugestią}

Gdy system wykryje konflikt terminów, automatycznie sugeruje alternatywny termin:

\begin{verbatim}
ORA-20008: Blad planowania: Sala jest juz zajeta w tym terminie!
SUGEROWANY TERMIN: 2025-06-02 o godzinie 15:00 w sali 101
\end{verbatim}

% =============================================================================
% 7. HEURYSTYKA SUGESTII TERMINU
% =============================================================================
\newpage
\section{Heurystyka sugestii terminu (First Fit)}

System implementuje algorytm \textbf{First Fit} do automatycznego sugerowania wolnego terminu w przypadku konfliktu.

\subsection{Algorytm znajdz\_alternatywe()}

\begin{enumerate}
    \item Zacznij od~następnej godziny po~nieudanym terminie
    \item Sprawdzaj godziny robocze (14:00 -- 19:00)
    \item Jeśli dzień się skończy, przeskocz do~następnego dnia na~14:00
    \item Szukaj maksymalnie przez~7~dni (limit bezpieczeństwa)
    \item Dla~każdego terminu iteruj po~dostępnych salach
\end{enumerate}

\subsection{Dopasowanie sali}

\begin{table}[h]
\centering
\begin{tabular}{|l|p{9cm}|}
\hline
\textbf{Typ lekcji} & \textbf{Kryteria doboru sali} \\
\hline
Indywidualna & Funkcja \texttt{sala\_ma\_instrument()} przeszukuje \textbf{VARRAY wyposażenia} sali, szukając elementu pasującego do~instrumentu ucznia. Obsługuje synonimy (np.~Pianino = Fortepian). \\
\hline
Grupowa & Szuka tylko sal typu 'grupowa' z~pojemnością >= liczba uczniów w~grupie \\
\hline
\end{tabular}
\caption{Kryteria doboru sali w heurystyce}
\end{table}

\subsection{Funkcja sala\_ma\_instrument()}

Funkcja przeszukuje kolekcję VARRAY wyposażenia sali:

\begin{verbatim}
FUNCTION sala_ma_instrument(p_id_sali NUMBER, p_instrument VARCHAR2) 
RETURN BOOLEAN IS
    v_wyposazenie t_wyposazenie;
BEGIN
    SELECT s.wyposazenie INTO v_wyposazenie FROM sale s WHERE s.id = p_id_sali;
    IF v_wyposazenie IS NULL THEN RETURN FALSE; END IF;
    
    FOR i IN 1..v_wyposazenie.COUNT LOOP
        IF UPPER(v_wyposazenie(i)) LIKE '%' || UPPER(p_instrument) || '%' THEN
            RETURN TRUE;
        END IF;
        -- Synonim: Pianino = Fortepian
        IF UPPER(p_instrument) = 'FORTEPIAN' AND 
           UPPER(v_wyposazenie(i)) LIKE '%PIANINO%' THEN
            RETURN TRUE;
        END IF;
    END LOOP;
    RETURN FALSE;
END;
\end{verbatim}

% =============================================================================
% 8. SCENARIUSZE UZYCIA
% =============================================================================
\newpage
\section{Scenariusze użycia}

Projekt zawiera kompleksowe scenariusze testowe demonstrujące funkcjonalności systemu.

\subsection{Scenariusz 1: Administrator rozszerza ofertę szkoły}

Administrator dodaje nowy przedmiot (Flet), salę z wyposażeniem (VARRAY) oraz nauczyciela:

\begin{itemize}[nosep]
    \item \texttt{pkg\_slowniki.dodaj\_przedmiot('Flet', 'indywidualny')}
    \item \texttt{pkg\_slowniki.dodaj\_sale('105', 'indywidualna', 4, t\_wyposazenie('Flet poprzeczny', 'Pulpit', 'Metronom'))}
    \item \texttt{pkg\_osoby.dodaj\_nauczyciela('Tomasz', 'Flecista', 6)} -- REF do~przedmiotu ID=6
\end{itemize}

\subsection{Scenariusz 2: Sekretariat tworzy grupę i zapisuje uczniów}

Sekretariat tworzy nową klasę 4A i zapisuje uczniów z referencją do grupy:

\begin{itemize}[nosep]
    \item \texttt{pkg\_slowniki.dodaj\_grupe('4A', 4)}
    \item \texttt{pkg\_osoby.dodaj\_ucznia('Jakub', 'Melodyjny', DATE '2014-07-20', 'Flet', 4)} -- REF do~grupy ID=4
    \item \texttt{pkg\_osoby.lista\_uczniow\_grupy(4)} -- używa \textbf{kursora jawnego}
\end{itemize}

\subsection{Scenariusz 3: Planowanie lekcji grupowych}

Sekretariat planuje zajęcia grupowe z walidacją typu sali i pojemności:

\begin{itemize}[nosep]
    \item \texttt{pkg\_lekcje.dodaj\_lekcje\_grupowa(4, 4, 3, 4, DATE '2025-06-09', 17)}
    \item System waliduje: typ sali = 'grupowa', pojemność >= liczba uczniów, brak konfliktów
\end{itemize}

\subsection{Scenariusz 4: Planowanie lekcji indywidualnych z konfliktem}

Demonstracja walidacji konfliktów i heurystyki sugestii:

\begin{itemize}[nosep]
    \item \textbf{Sukces:} \texttt{pkg\_lekcje.dodaj\_lekcje\_indywidualna(6, 6, 5, 10, DATE '2025-06-09', 14)}
    \item \textbf{Konflikt:} Próba dodania lekcji w~zajętym terminie → błąd -20008 z~sugestią alternatywnego terminu
    \item System przeszukuje VARRAY wyposażenia sal szukając pasującego instrumentu
\end{itemize}

\subsection{Scenariusz 5: Nauczyciel wystawia oceny}

Nauczyciel wystawia oceny z walidacją uprawnień:

\begin{itemize}[nosep]
    \item \texttt{pkg\_oceny.wystaw\_ocene(10, 6, 6, 5)} -- ocena cząstkowa
    \item \texttt{pkg\_oceny.wystaw\_ocene\_semestralna(10, 6, 6, 5)} -- ocena semestralna
    \item \textbf{Błąd -20013:} Nauczyciel próbuje wystawić ocenę z przedmiotu którego nie uczy
\end{itemize}

\subsection{Scenariusz 6: Uczeń sprawdza oceny i plan}

Uczeń (lub rodzic) przegląda swoje dane:

\begin{itemize}[nosep]
    \item \texttt{pkg\_oceny.oceny\_ucznia(10)} -- lista ocen z~opisem słownym (metoda opis\_oceny())
    \item \texttt{SELECT pkg\_oceny.srednia\_ucznia(10, 6) FROM DUAL} -- średnia z~przedmiotu
    \item \texttt{pkg\_lekcje.plan\_ucznia(10)} -- plan lekcji (UNION indywidualnych i~grupowych)
\end{itemize}

\subsection{Scenariusz 7: Raporty dla dyrekcji}

Dyrekcja generuje raporty podsumowujące:

\begin{itemize}[nosep]
    \item \texttt{pkg\_raporty.raport\_grup()} -- liczba uczniów w~każdej klasie
    \item \texttt{pkg\_raporty.statystyki()} -- ogólne statystyki szkoły
    \item \texttt{pkg\_lekcje.plan\_nauczyciela(6)} -- plan nauczyciela (kontrola obciążenia)
\end{itemize}

\subsection{Scenariusz 8: Walidacje i przypadki brzegowe}

Demonstracja walidacji i obsługi błędów:

\begin{itemize}[nosep]
    \item \textbf{Logika przypisania:} Lekcja bez~ucznia i~bez~grupy → błąd -20001
    \item \textbf{Trigger ocen:} Ocena = 7 → błąd -20002
    \item \textbf{Typ sali:} Lekcja grupowa w~sali indywidualnej → błąd -20011
    \item \textbf{Instrument:} Uczeń z~Fletem na~lekcji Fortepianu → błąd -20012
    \item \textbf{Kompetencje:} Nauczyciel Fletu prowadzi lekcję Fortepianu → błąd -20010
    \item \textbf{Weekend (sobota):} Lekcja indywidualna na~sobotę → błąd -20018
    \item \textbf{Weekend (niedziela):} Lekcja grupowa na~niedzielę → błąd -20018
\end{itemize}

\subsection{Scenariusz 9: Demonstracja VARRAY}

Pokazanie działania kolekcji VARRAY wyposażenia sal:

\begin{itemize}[nosep]
    \item \texttt{pkg\_slowniki.lista\_sal()} -- lista sal z~wyposażeniem
    \item Metoda \texttt{lista\_wyposazenia()} iteruje po~VARRAY i~zwraca tekst
    \item Funkcja \texttt{sala\_ma\_instrument()} przeszukuje VARRAY przy~planowaniu
\end{itemize}

\subsection{Scenariusz 10: Demonstracja REF/DEREF}

Pokazanie działania referencji obiektowych:

\begin{itemize}[nosep]
    \item Nauczyciele z~przedmiotami (DEREF na~REF do~przedmiotu)
    \item Uczniowie z~grupami (DEREF na~REF do~grupy)
    \item Lekcje z~pełnymi danymi (wielokrotny DEREF)
\end{itemize}

\subsection{Scenariusz 11: Demonstracja metod obiektowych}

Pokazanie działania metod zdefiniowanych w typach:

\begin{itemize}[nosep]
    \item \texttt{t\_uczen.pelne\_nazwisko()}, \texttt{t\_uczen.wiek()}
    \item \texttt{t\_nauczyciel.pelne\_nazwisko()}, \texttt{t\_nauczyciel.staz\_lat()}
    \item \texttt{t\_przedmiot.czy\_grupowy()}, \texttt{t\_sala.czy\_grupowa()}
    \item \texttt{t\_lekcja.czy\_indywidualna()}, \texttt{t\_lekcja.godzina\_koniec()}
    \item \texttt{t\_ocena.opis\_oceny()}
\end{itemize}

% =============================================================================
% 9. DIAGRAM RELACJI OBIEKTOW
% =============================================================================
\newpage
\section{Diagram relacji obiektów}

\begin{figure}[h]
\centering
\includegraphics[width=\textwidth,keepaspectratio]{Relational_1.png}
\caption{Diagram relacji obiektów w bazie danych}
\end{figure}

% =============================================================================
% 10. STRUKTURA PLIKÓW
% =============================================================================
\newpage
\section{Struktura plików projektu}

\begin{table}[h]
\centering
\begin{tabular}{|l|p{9cm}|}
\hline
\textbf{Plik} & \textbf{Zawartość} \\
\hline
01\_typy.sql & Definicje 8~typów obiektowych z~10~metodami, VARRAY \\
02\_tabele.sql & 7~tabel obiektowych, 7~sekwencji \\
03\_pakiety.sql & 5~pakietów PL/SQL z~25~podprogramami publicznymi \\
04\_triggery.sql & 2 wyzwalacze walidacyjne (typ lekcji, zakres ocen) \\
05\_dane.sql & Dane testowe (5~przedm., 3~grupy, 5~naucz., 4~sale, 9~uczn.) \\
06\_scenariusze.sql & Scenariusze testowe 1-11 (dokumentacja API + testy) \\
\hline
\end{tabular}
\caption{Pliki projektu}
\end{table}

\textbf{Kolejność uruchamiania:}
\begin{enumerate}[nosep]
    \item 01\_typy.sql -- typy obiektowe z metodami
    \item 02\_tabele.sql -- tabele obiektowe i sekwencje
    \item 03\_pakiety.sql -- pakiety PL/SQL
    \item 04\_triggery.sql -- wyzwalacze
    \item 05\_dane.sql -- dane testowe
    \item 06\_scenariusze.sql -- scenariusze testowe (opcjonalne)
\end{enumerate}

\end{document}





# Hurtownia i dystrybucja przetworzonych produktów spożywczych

## 1. Opis projektu

### 1.1 Cel i zakres

Celem projektu jest zaprojektowanie i implementacja Rozproszonej Bazy Danych (RBD) obsługującej procesy biznesowe dużej hurtowni i firmy dystrybucyjnej zajmującej się przetworzonymi produktami spożywczymi (np. konserwy, mrożonki, słoiki, soki, dania gotowe).

Firma posiada rozproszoną strukturę organizacyjną, w której Centrala, Główne Centrum Logistyczne oraz oddziały regionalne korzystają z różnych środowisk bazodanowych.


Baza będzie zawierać informacje o asortymencie (z uwzględnieniem dat ważności _i numerów partii_), dostawcach (producentach żywności), klientach (sieci handlowe, sklepy lokalne, branża hotelarska), zamówieniach hurtowych oraz stanach magazynowych w różnych lokalizacjach.

Głównym założeniem jest połączenie różnych systemów bazodanowych (MS SQL, Oracle, Excel) tak, aby ze sobą współpracowały. Dzięki temu zyskamy:
    - łatwe przesyłanie, łączenie i edytowanie danych,
    - możliwość pobierania informacji z kilku baz jednocześnie,
    - automatyczne kopiowanie danych między serwerami (replikacja),
    - bezpieczny zapis danych – jeśli jedna baza ulegnie awarii, system (dzięki MS DTC) cofnie zmiany również w drugiej, żeby nic się nie zepsuło.

### 1.2 Architektura Systemu i Podział Ról

System opiera się na czterech współpracujących ze sobą środowiskach. Każde z nich ma ściśle określoną rolę:

* **MS SQL Server (Centrum Operacyjne)**
  * **Rola:** Główne serce systemu obsługujące codzienną dynamikę hurtowni.
  * **Dane:** Bieżące stany magazynowe, spływające zamówienia, daty ważności partii towaru oraz dokumenty wydań (WZ).
  * **Połączenia:** Działa jako centralny punkt komunikacyjny – posiada stałe połączenia (Linked Servers) do wszystkich pozostałych źródeł.

* **Oracle (Centrala Finansowa)**
  * **Rola:** Centrala zarządzająca strategicznymi informacjami i finansami.
  * **Dane:** Kartoteki kluczowych klientów, umowy długoterminowe, rozliczenia oraz faktury.
  * **Połączenia:** Posiada własne połączenie (Database Link) do MS SQL Server, aby na bieżąco łączyć dane finansowe z fizycznymi stanami na magazynie.

* **MS Access (Lokalny Oddział / Sklep)**
  * **Rola:** Niewielka baza obsługująca pojedynczy, mały punkt sprzedaży.
  * **Dane:** Historia lokalnej sprzedaży detalicznej oraz zwrotów.
  * **Połączenia:** Serwer MS SQL regularnie łączy się z tą bazą, aby pobrać dane potrzebne do stworzenia globalnych raportów sprzedaży.

* **Pliki Excel (Katalogi Dostawców)**
  * **Rola:** Zewnętrzne, szybko zmieniające się informacje od producentów żywności.
  * **Dane:** Aktualne cenniki, kody EAN, wagi produktów i informacje o alergenach.
  * **Połączenia:** Są odczytywane przez MS SQL Server "w locie" (ad hoc), co pozwala na błyskawiczną aktualizację oferty bez konieczności ręcznego przepisywania danych.



### 1.3 Założenia biznesowe i projektowe

Aby system działał zgodnie z wymaganiami technicznymi dla projektu RBD, przyjęto następujące założenia:

**A. Założenia biznesowe (Logika hurtowni):**
* **Identyfikowalność żywności:** Każdy produkt posiada numer partii oraz datę przydatności do spożycia.
* **Rozproszenie klientów:** Zamówienia spływają do bazy MS SQL, ale weryfikacja limitu kredytowego klienta odbywa się na bieżąco w bazie Oracle (Centrala).
* **Zarządzanie zapasami:** Sprzedaż towaru powoduje natychmiastowe zdjęcie go ze stanu w SQL Server oraz aktualizację rejestru sprzedaży w Oracle.






**B. Założenia technologiczne (Realizacja wymogów prowadzącego):**
1. **Widoki i procedury rozproszone:** Zostaną napisane widoki łączące dane ze wszystkich serwerów (np. widok `v_GlobalnaSprzedaz` łączący faktury z Oracle, stany z SQL Server i cenniki z .xls). Wymusi to rzutowanie odpowiednich typów danych między Oracle a T-SQL.
2. **Wielodostęp i Ad Hoc:** Utworzone zostaną zapytania z funkcją `OPENROWSET` integrujące jednocześnie dane z SQL Server, Accessa i pliku Excel (np. podczas generowania raportu rentowności).
3. **Modyfikacja danych zdalnych:** Z poziomu SQL Server będzie można wstawiać i modyfikować dane (np. statusy klientów) w bazie Oracle poprzez zestawiony Linked Server.
4. **Transakcje rozproszone (MS DTC):** Utworzenie procedury z instrukcją `BEGIN DISTRIBUTED TRANSACTION`. Np. operacja "Realizuj Zamówienie" zdejmie towar z magazynu (SQL Server) i jednocześnie zaktualizuje saldo klienta (Oracle). Jeśli jeden serwer ulegnie awarii, MS DTC wycofa całą transakcję (Rollback).
5. **Replikacja:** Wdrożona zostanie **replikacja migawkowa (Snapshot Replication)** ze strony SQL Server do Accessa lub pomiędzy dwiema instancjami SQL (np. synchronizacja słownika produktów z bazy głównej do bazy raportowej).
6. **Zarządzanie w ORACLE:** Zostaną utworzeni odpowiedni użytkownicy, role oraz nadane uprawnienia. Zostanie zasymulowana praca z wieloma użytkownikami przy wykorzystaniu prywatnych i publicznych *Database Links*.
7. **Wyzwalacze INSTEAD OF:** Zostaną napisane w bazie Oracle na widokach rozproszonych, co pozwoli na transparentne dla użytkownika aktualizowanie danych na zdalnym MS SQL.







# Schemat Bazy Danych — Hurtownia Żywności Przetworzonej

---

## MS SQL SERVER — Centrum Operacyjne

### `Categories`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| CategoryID | INT | PK, IDENTITY(1,1) | Identyfikator kategorii |
| CategoryName | NVARCHAR(50) | NOT NULL, UNIQUE | Nazwa kategorii (np. Konserwy, Mrożonki) |
| Description | NVARCHAR(255) | NULL | Opis kategorii |

---

### `Suppliers`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| SupplierID | INT | PK, IDENTITY(1,1) | Identyfikator dostawcy |
| CompanyName | NVARCHAR(100) | NOT NULL | Nazwa firmy dostawcy |
| ContactName | NVARCHAR(100) | NULL | Osoba kontaktowa |
| Country | NVARCHAR(50) | NOT NULL | Kraj dostawcy |
| Phone | NVARCHAR(30) | NULL | Telefon |
| Email | NVARCHAR(100) | NULL, CHECK (Email LIKE '%@%') | Email |
| IsActive | BIT | NOT NULL, DEFAULT 1 | Czy dostawca aktywny |

---

### `Products`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| ProductID | INT | PK, IDENTITY(1,1) | Identyfikator produktu |
| CategoryID | INT | FK → Categories(CategoryID), NOT NULL | Kategoria |
| SupplierID | INT | FK → Suppliers(SupplierID), NOT NULL | Dostawca |
| ProductName | NVARCHAR(100) | NOT NULL | Nazwa produktu |
| EANCode | CHAR(13) | UNIQUE, NOT NULL | Kod kreskowy EAN-13 |
| UnitWeight_g | DECIMAL(10,2) | NOT NULL, CHECK > 0 | Waga jednostkowa (gramy) |
| UnitPrice | DECIMAL(10,2) | NOT NULL, CHECK >= 0 | Cena jednostkowa netto |
| UnitsInPackage | INT | NOT NULL, DEFAULT 1, CHECK > 0 | Sztuk w opakowaniu zbiorczym |
| Allergens | NVARCHAR(255) | NULL | Lista alergenów |
| IsDiscontinued | BIT | NOT NULL, DEFAULT 0 | Produkt wycofany z oferty |

---

### `Batches`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| BatchID | INT | PK, IDENTITY(1,1) | Identyfikator partii |
| ProductID | INT | FK → Products(ProductID), NOT NULL | Produkt |
| SupplierID | INT | FK → Suppliers(SupplierID), NOT NULL | Dostawca partii |
| BatchNumber | NVARCHAR(50) | NOT NULL, UNIQUE | Numer partii produkcyjnej |
| ProductionDate | DATE | NOT NULL | Data produkcji |
| ExpiryDate | DATE | NOT NULL, CHECK > ProductionDate | Data ważności |
| ReceivedDate | DATE | NOT NULL, DEFAULT GETDATE() | Data przyjęcia na magazyn |
| InitialQuantity | INT | NOT NULL, CHECK > 0 | Ilość przyjęta (szt.) |

---

### `Warehouses`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| WarehouseID | INT | PK, IDENTITY(1,1) | Identyfikator magazynu |
| WarehouseName | NVARCHAR(100) | NOT NULL | Nazwa magazynu |
| City | NVARCHAR(50) | NOT NULL | Miasto |
| Address | NVARCHAR(200) | NOT NULL | Adres |
| StorageType | NVARCHAR(20) | NOT NULL, CHECK IN ('ambient','chilled','frozen') | Typ przechowywania |
| Capacity_m3 | DECIMAL(10,2) | NOT NULL, CHECK > 0 | Pojemność w m³ |

---

### `StockLevels`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| StockID | INT | PK, IDENTITY(1,1) | Identyfikator pozycji stanu |
| WarehouseID | INT | FK → Warehouses(WarehouseID), NOT NULL | Magazyn |
| BatchID | INT | FK → Batches(BatchID), NOT NULL | Partia towaru |
| QuantityOnHand | INT | NOT NULL, DEFAULT 0, CHECK >= 0 | Dostępna ilość (szt.) |
| QuantityReserved | INT | NOT NULL, DEFAULT 0, CHECK >= 0 | Zarezerwowana ilość |
| LastUpdated | DATETIME | NOT NULL, DEFAULT GETDATE() | Data ostatniej aktualizacji |
| UNIQUE | — | UNIQUE(WarehouseID, BatchID) | Jedna pozycja na partię i magazyn |

---

### `Orders`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| OrderID | INT | PK, IDENTITY(1,1) | Identyfikator zamówienia |
| CustomerID | INT | NOT NULL | ID klienta (z bazy Oracle) |
| WarehouseID | INT | FK → Warehouses(WarehouseID), NOT NULL | Realizujący magazyn |
| OrderDate | DATETIME | NOT NULL, DEFAULT GETDATE() | Data złożenia zamówienia |
| RequiredDate | DATE | NOT NULL | Oczekiwana data dostawy |
| ShippedDate | DATE | NULL | Faktyczna data wysyłki |
| Status | NVARCHAR(20) | NOT NULL, DEFAULT 'pending', CHECK IN ('pending','confirmed','shipped','delivered','cancelled') | Status zamówienia |
| TotalAmount | DECIMAL(12,2) | NOT NULL, DEFAULT 0, CHECK >= 0 | Wartość zamówienia netto |
| Notes | NVARCHAR(500) | NULL | Uwagi do zamówienia |

---

### `OrderItems`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| OrderItemID | INT | PK, IDENTITY(1,1) | Identyfikator pozycji |
| OrderID | INT | FK → Orders(OrderID), NOT NULL | Zamówienie |
| ProductID | INT | FK → Products(ProductID), NOT NULL | Produkt |
| BatchID | INT | FK → Batches(BatchID), NULL | Konkretna partia (opcjonalnie) |
| Quantity | INT | NOT NULL, CHECK > 0 | Zamówiona ilość |
| UnitPrice | DECIMAL(10,2) | NOT NULL, CHECK >= 0 | Cena w momencie zamówienia |
| Discount | DECIMAL(4,2) | NOT NULL, DEFAULT 0, CHECK BETWEEN 0 AND 1 | Rabat (0.00–1.00) |

---

### `DeliveryNotes` *(dokumenty WZ)*
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| DeliveryNoteID | INT | PK, IDENTITY(1,1) | Identyfikator dokumentu WZ |
| OrderID | INT | FK → Orders(OrderID), NOT NULL, UNIQUE | Powiązane zamówienie (1:1) |
| IssuedDate | DATETIME | NOT NULL, DEFAULT GETDATE() | Data wystawienia WZ |
| IssuedBy | NVARCHAR(100) | NOT NULL | Wystawca dokumentu |
| TruckPlate | NVARCHAR(20) | NULL | Numer rejestracyjny pojazdu |
| RecipientName | NVARCHAR(100) | NOT NULL | Odbiorca (nazwa) |
| RecipientSignature | NVARCHAR(100) | NULL | Podpis odbiorcy |

---

### `SupplierPriceLists` *(tabela pośrednia — dane importowane z Excel)*
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| PriceListID | INT | PK, IDENTITY(1,1) | Identyfikator rekordu |
| SupplierID | INT | FK → Suppliers(SupplierID), NOT NULL | Dostawca |
| EANCode | CHAR(13) | NOT NULL | Kod EAN produktu |
| ProductNameRaw | NVARCHAR(100) | NOT NULL | Nazwa wg dostawcy (surowa) |
| PriceNet | DECIMAL(10,2) | NOT NULL, CHECK >= 0 | Cena netto od dostawcy |
| Currency | CHAR(3) | NOT NULL, DEFAULT 'PLN' | Waluta |
| ValidFrom | DATE | NOT NULL | Ważny od |
| ValidTo | DATE | NULL, CHECK > ValidFrom | Ważny do |
| ImportedAt | DATETIME | NOT NULL, DEFAULT GETDATE() | Data importu z pliku Excel |
| SourceFileName | NVARCHAR(255) | NOT NULL | Nazwa pliku źródłowego |

---
---

## ORACLE — Centrala Finansowa

### `Customers`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| CustomerID | NUMBER | PK | Identyfikator klienta |
| CompanyName | VARCHAR2(100) | NOT NULL | Nazwa firmy |
| CustomerType | VARCHAR2(20) | NOT NULL, CHECK IN ('retail_chain','local_shop','horeca') | Typ klienta |
| TaxNumber | CHAR(10) | NOT NULL, UNIQUE | NIP |
| Country | VARCHAR2(50) | NOT NULL | Kraj |
| City | VARCHAR2(50) | NOT NULL | Miasto |
| Address | VARCHAR2(200) | NOT NULL | Adres |
| CreditLimit | NUMBER(12,2) | NOT NULL, DEFAULT 0, CHECK >= 0 | Limit kredytowy |
| CurrentBalance | NUMBER(12,2) | NOT NULL, DEFAULT 0 | Bieżące saldo |
| IsActive | CHAR(1) | NOT NULL, DEFAULT 'Y', CHECK IN ('Y','N') | Aktywny |
| RegisteredAt | DATE | NOT NULL, DEFAULT SYSDATE | Data rejestracji |

---

### `Contracts`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| ContractID | NUMBER | PK | Identyfikator umowy |
| CustomerID | NUMBER | FK → Customers(CustomerID), NOT NULL | Klient |
| ContractNumber | VARCHAR2(30) | NOT NULL, UNIQUE | Numer umowy |
| StartDate | DATE | NOT NULL | Data rozpoczęcia |
| EndDate | DATE | NOT NULL, CHECK > StartDate | Data zakończenia |
| DiscountRate | NUMBER(4,2) | NOT NULL, DEFAULT 0, CHECK BETWEEN 0 AND 1 | Stały rabat (0.00–1.00) |
| PaymentTerms_days | NUMBER(3) | NOT NULL, DEFAULT 30 | Termin płatności (dni) |
| Status | VARCHAR2(20) | NOT NULL, DEFAULT 'active', CHECK IN ('active','expired','terminated') | Status umowy |

---

### `Invoices`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| InvoiceID | NUMBER | PK | Identyfikator faktury |
| CustomerID | NUMBER | FK → Customers(CustomerID), NOT NULL | Klient |
| OrderID_MSSQL | NUMBER | NOT NULL | ID zamówienia z MS SQL Server |
| InvoiceNumber | VARCHAR2(30) | NOT NULL, UNIQUE | Numer faktury |
| IssueDate | DATE | NOT NULL, DEFAULT SYSDATE | Data wystawienia |
| DueDate | DATE | NOT NULL, CHECK > IssueDate | Termin płatności |
| NetAmount | NUMBER(12,2) | NOT NULL, CHECK >= 0 | Kwota netto |
| VATRate | NUMBER(4,2) | NOT NULL, DEFAULT 0.23 | Stawka VAT |
| GrossAmount | NUMBER(12,2) | NOT NULL, CHECK >= 0 | Kwota brutto |
| Status | VARCHAR2(20) | NOT NULL, DEFAULT 'unpaid', CHECK IN ('unpaid','paid','overdue','cancelled') | Status faktury |

---

### `InvoiceItems`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| InvoiceItemID | NUMBER | PK | Identyfikator pozycji |
| InvoiceID | NUMBER | FK → Invoices(InvoiceID), NOT NULL | Faktura |
| ProductID_MSSQL | NUMBER | NOT NULL | ID produktu z MS SQL Server |
| ProductName | VARCHAR2(100) | NOT NULL | Nazwa produktu (snapshot) |
| Quantity | NUMBER | NOT NULL, CHECK > 0 | Ilość |
| UnitPrice | NUMBER(10,2) | NOT NULL, CHECK >= 0 | Cena jednostkowa |
| Discount | NUMBER(4,2) | NOT NULL, DEFAULT 0, CHECK BETWEEN 0 AND 1 | Rabat |

---

### `Employees`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| EmployeeID | NUMBER | PK | Identyfikator pracownika |
| FirstName | VARCHAR2(50) | NOT NULL | Imię |
| LastName | VARCHAR2(50) | NOT NULL | Nazwisko |
| Department | VARCHAR2(50) | NOT NULL | Dział |
| Position | VARCHAR2(100) | NOT NULL | Stanowisko |
| HireDate | DATE | NOT NULL | Data zatrudnienia |
| Salary | NUMBER(10,2) | NOT NULL, CHECK > 0 | Wynagrodzenie |
| ManagerID | NUMBER | FK → Employees(EmployeeID), NULL | Przełożony (self-ref) |

---
---

## MS ACCESS — Lokalny Oddział / Sklep

### `RetailSales`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| SaleID | AUTOINCREMENT | PK | Identyfikator sprzedaży |
| SaleDate | DATETIME | NOT NULL, DEFAULT Now() | Data sprzedaży |
| CustomerName | TEXT(100) | NOT NULL | Nazwa klienta detalicznego |
| TotalAmount | CURRENCY | NOT NULL, CHECK >= 0 | Wartość sprzedaży |
| PaymentMethod | TEXT(20) | NOT NULL, CHECK IN ('cash','card','transfer') | Metoda płatności |
| Notes | MEMO | NULL | Uwagi |

---

### `RetailSaleItems`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| SaleItemID | AUTOINCREMENT | PK | Identyfikator pozycji |
| SaleID | INTEGER | FK → RetailSales(SaleID), NOT NULL | Sprzedaż |
| ProductID_MSSQL | INTEGER | NOT NULL | ID produktu z MS SQL Server |
| ProductName | TEXT(100) | NOT NULL | Nazwa produktu (lokalnie) |
| Quantity | INTEGER | NOT NULL, CHECK > 0 | Ilość |
| UnitPrice | CURRENCY | NOT NULL, CHECK >= 0 | Cena jednostkowa |

---

### `Returns`
| Kolumna | Typ | Ograniczenia | Opis |
|---|---|---|---|
| ReturnID | AUTOINCREMENT | PK | Identyfikator zwrotu |
| SaleID | INTEGER | FK → RetailSales(SaleID), NOT NULL | Powiązana sprzedaż |
| ReturnDate | DATETIME | NOT NULL, DEFAULT Now() | Data zwrotu |
| Reason | TEXT(255) | NOT NULL | Powód zwrotu |
| RefundAmount | CURRENCY | NOT NULL, CHECK >= 0 | Kwota zwrotu |

---
---

## EXCEL (*.xls) — Katalogi Dostawców *(zewnętrzne źródło, import ad hoc)*

> Poniższe kolumny reprezentują oczekiwaną strukturę arkusza Excel
> po imporcie przez `OPENROWSET`. Dane trafiają do tabeli `SupplierPriceLists` w SQL Server.

### `[Arkusz1$]`
| Kolumna (nagłówek w pliku) | Oczekiwany typ | Opis |
|---|---|---|
| EAN_Code | TEXT / CHAR(13) | Kod kreskowy EAN produktu |
| Product_Name | TEXT | Nazwa produktu wg dostawcy |
| Price_Net | DECIMAL | Cena netto (waluta w kolejnej kolumnie) |
| Currency | TEXT | Waluta (np. PLN, EUR) |
| Weight_g | DECIMAL | Waga jednostkowa w gramach |
| Units_In_Package | INTEGER | Sztuk w opakowaniu zbiorczym |
| Allergens | TEXT | Lista alergenów (tekst wolny) |
| Valid_From | DATE | Data początku obowiązywania cennika |
| Valid_To | DATE | Data końca obowiązywania (może być pusta) |

---
---

## Relacje między węzłami (klucze obce między bazami)

| Tabela źródłowa | Kolumna | → | Tabela docelowa | Kolumna | Węzeł |
|---|---|---|---|---|---|
| Orders (SQL) | CustomerID | → | Customers (Oracle) | CustomerID | SQL → Oracle |
| Invoices (Oracle) | OrderID_MSSQL | → | Orders (SQL) | OrderID | Oracle → SQL |
| InvoiceItems (Oracle) | ProductID_MSSQL | → | Products (SQL) | ProductID | Oracle → SQL |
| RetailSaleItems (Access) | ProductID_MSSQL | → | Products (SQL) | ProductID | Access → SQL |
| SupplierPriceLists (SQL) | EANCode | → | Products (SQL) | EANCode | Excel → SQL |

> Relacje między węzłami nie są egzekwowane natywnie przez silniki baz danych.
> Integralność zapewniają widoki rozproszone, procedury składowane
> oraz transakcje z użyciem MS DTC.