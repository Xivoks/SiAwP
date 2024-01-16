import numpy as np
import pandas as pd
from scipy import stats

# Generowanie próby losowej dla rozkładu normalnego i testowanie hipotezy o średniej
srednia = 2
odchylenie = 30
liczba_elementow = 200

probka_normalna = np.random.normal(srednia, odchylenie, liczba_elementow)
t_statystyka, p_wartosc = stats.ttest_1samp(probka_normalna, 2.5)

print(t_statystyka, p_wartosc)

# Wczytanie danych z pliku CSV i test hipotezy dla średniego spożycia napojów
df_napoje = pd.read_csv('napoje.csv', sep=';')

# Test hipotezy dla średnich spożycia napojów
srednia_hipoteza_lech = 60500
t_stat_lech, p_wartosc_lech = stats.ttest_1samp(df_napoje['lech'], srednia_hipoteza_lech)
srednia_hipoteza_cola = 222000
t_stat_cola, p_wartosc_cola = stats.ttest_1samp(df_napoje['cola'], srednia_hipoteza_cola)
srednia_hipoteza_regionalne = 43500
t_stat_regionalne, p_wartosc_regionalne = stats.ttest_1samp(df_napoje['regionalne'], srednia_hipoteza_regionalne)

print(t_stat_lech, p_wartosc_lech), (t_stat_cola, p_wartosc_cola), (t_stat_regionalne, p_wartosc_regionalne)

# Sprawdzenie normalności zmiennych w pliku napoje.csv
wyniki_normalnosci = {}
for kolumna in df_napoje.columns[2:]:  # Pomijamy kolumny 'mies' i 'rok'
    statystyka, p_wartosc = stats.shapiro(df_napoje[kolumna])
    wyniki_normalnosci[kolumna] = (statystyka, p_wartosc)

print(wyniki_normalnosci)
#Testowanie równości średnich dla wybranych par napojów
wyniki_testow_t = {}

pary_napojow = [('okocim', 'lech'), ('fanta ', 'regionalne'), ('cola', 'pepsi')]

for napoj1, napoj2 in pary_napojow:
    t_stat, p_wartosc = stats.ttest_ind(df_napoje[napoj1], df_napoje[napoj2])
    wyniki_testow_t[f'{napoj1} vs {napoj2}'] = (t_stat, p_wartosc)

print(wyniki_testow_t)

#Testowanie równości wariancji dla wybranych par napojów

wyniki_testow_levene = {}

pary_napojow_wariancje = [('okocim', 'lech'), ('żywiec', 'fanta '), ('regionalne', 'cola')]

for napoj1, napoj2 in pary_napojow_wariancje:
    w_stat, p_wartosc = stats.levene(df_napoje[napoj1], df_napoje[napoj2])
    wyniki_testow_levene[f'{napoj1} vs {napoj2}'] = (w_stat, p_wartosc)

print(wyniki_testow_levene)

#Ponowne testowanie równości średnich dla piw regionalnych między latami 2001 i 2015

piwa_regionalne_2001 = df_napoje[df_napoje['rok'] == 2001]['regionalne']
piwa_regionalne_2015 = df_napoje[df_napoje['rok'] == 2015]['regionalne']

min_length = min(len(piwa_regionalne_2001), len(piwa_regionalne_2015))
piwa_regionalne_2001 = piwa_regionalne_2001.iloc[:min_length]
piwa_regionalne_2015 = piwa_regionalne_2015.iloc[:min_length]
t_stat_rok_par, p_wartosc_rok_par = stats.ttest_rel(piwa_regionalne_2001, piwa_regionalne_2015)

print(t_stat_rok_par, p_wartosc_rok_par)

df_napoje_po_reklamie = pd.read_csv('napoje_po_reklamie.csv', sep=';')
napoje_2016 = df_napoje[df_napoje['rok'] == 2016]

napoje_zalezne = ['cola', 'fanta ', 'pepsi']

wyniki_testow_t_zalezne_ponownie = {}

for napoj in napoje_zalezne:
    min_length = min(len(napoje_2016[napoj]), len(df_napoje_po_reklamie[napoj]))
    probki_2016 = napoje_2016[napoj].iloc[:min_length]
    probki_po_reklamie = df_napoje_po_reklamie[napoj].iloc[:min_length]

    t_stat_zalezne, p_wartosc_zalezne = stats.ttest_rel(probki_2016, probki_po_reklamie)
    wyniki_testow_t_zalezne_ponownie[f'2016 vs po reklamie - {napoj}'] = (t_stat_zalezne, p_wartosc_zalezne)

print(wyniki_testow_t_zalezne_ponownie)





