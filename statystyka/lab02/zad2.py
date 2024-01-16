# Zadanie 1: Obliczenie statystyk podstawowych dla danych wartości prawdopodobieństwa
import numpy as np
from scipy.stats import bernoulli, binom, poisson, describe
import matplotlib.pyplot as plt
import seaborn as sns

wartosci = np.array([1, 2, 3, 4, 5, 6])
prawdopodobienstwa = np.array([1 / 6] * 6)

srednia = np.sum(wartosci * prawdopodobienstwa)

wariancja = np.sum((wartosci - srednia) ** 2 * prawdopodobienstwa)

odchylenie_standardowe = np.sqrt(wariancja)

print(srednia, wariancja, odchylenie_standardowe)

# Zadanie 2: Generowanie próbek dla rozkładów Bernoulliego, dwumianowego i Poissona oraz obliczenie ich statystyk

n = 100
p_bernoulli = 0.5
p_binom = 0.5
lambda_poisson = 5

probki_bernoulli = bernoulli.rvs(p_bernoulli, size=n)
probki_binomialne = binom.rvs(n, p_binom, size=n)
probki_poissona = poisson.rvs(lambda_poisson, size=n)

statystyki_bernoulli = describe(probki_bernoulli)
statystyki_dwumianowe = describe(probki_binomialne)
statystyki_poissona = describe(probki_poissona)

print(statystyki_bernoulli, statystyki_dwumianowe, statystyki_poissona)

# Zadanie 3: Tworzenie wykresów rozkładu prawdopodobieństwa dla rozkładów Bernoulliego, dwumianowego i Poissona
sns.set_style('whitegrid')

fig, axes = plt.subplots(3, 1, figsize=(10, 15))

sns.histplot(statystyki_bernoulli, kde=False, ax=axes[0], bins=2)
axes[0].set_title('Histogram rozkładu Bernoulliego (n=100, p=0.5)')
axes[0].set_xlabel('Wartości')
axes[0].set_ylabel('Liczba wystąpień')

sns.histplot(statystyki_dwumianowe, kde=True, ax=axes[1], bins=30)
axes[1].set_title('Histogram rozkładu dwumianowego (n=100, p=0.5)')
axes[1].set_xlabel('Wartości')
axes[1].set_ylabel('Liczba wystąpień')

sns.histplot(statystyki_poissona, kde=True, ax=axes[2], bins=20)
axes[2].set_title('Histogram rozkładu Poissona (n=100, λ=5)')
axes[2].set_xlabel('Wartości')
axes[2].set_ylabel('Liczba wystąpień')

plt.tight_layout()
plt.show()

# Zadanie 5: Wygenerowanie rozkładu prawdopodobieństwa dla rozkładu dwumianowego
n_dwumianowy = 20
p_dwumianowy = 0.4
k_wartosci = np.arange(0, 21)
prawdopodobienstwa_dwumianowe = binom.pmf(k_wartosci, n_dwumianowy, p_dwumianowy)
suma_prawdopodobienstw_dwumianowych = np.sum(prawdopodobienstwa_dwumianowe)

print(suma_prawdopodobienstw_dwumianowych)

# Zadanie 6: Wygenerowanie danych dla rozkładu normalnego i obliczenie statystyk
n_normalny = 100
srednia_normalna = 0
odchylenie_standardowe_normalne = 2
probki_normalne = np.random.normal(srednia_normalna, odchylenie_standardowe_normalne, n_normalny)
statystyki_normalne = describe(probki_normalne)

# Sprawdzenie dokładności przy większej liczbie danych
n_normalny_duze = 1000
probki_normalne_duze = np.random.normal(srednia_normalna, odchylenie_standardowe_normalne, n_normalny_duze)
statystyki_normalne_duze = describe(probki_normalne_duze)

# statystyki dla 100 i 1000 danych
print(statystyki_normalne, statystyki_normalne_duze)

# Zadanie 7: Rysowanie histogramów dla różnych rozkładów normalnych
srednia_normalna_1 = 1
odchylenie_standardowe_normalne_1 = 2
srednia_normalna_2 = -1
odchylenie_standardowe_normalne_2 = 0.5

probki_normalne_1 = np.random.normal(srednia_normalna_1, odchylenie_standardowe_normalne_1, n_normalny)
probki_normalne_2 = np.random.normal(srednia_normalna_2, odchylenie_standardowe_normalne_2, n_normalny)

plt.figure(figsize=(10, 6))
sns.histplot(probki_normalne_1, kde=True, color='blue', label='Średnia=1, Odchylenie=2')
sns.histplot(probki_normalne, kde=True, color='green', label='Standardowy')
sns.histplot(probki_normalne_2, kde=True, color='red', label='Średnia=-1, Odchylenie=0.5')
plt.title('Histogramy dla różnych rozkładów normalnych')
plt.xlabel('Wartości')
plt.ylabel('Liczba wystąpień')
plt.legend()

plt.show()
