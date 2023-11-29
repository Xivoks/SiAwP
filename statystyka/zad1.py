import pandas as pd
from matplotlib import pyplot as plt

file_path = 'MDR_RR_TB_burden_estimates_2023-11-29.csv'
data = pd.read_csv(file_path)

selected_column = data.select_dtypes(include='number').columns[7]
num_data = data[selected_column]

mean = num_data.mean()
median = num_data.median()
std_dev = num_data.std()
min_value = num_data.min()
max_value = num_data.max()

# print("Średnia: ",round(mean,2))
# print("Mediana: ",round(median,2))
# print("Odchylenie standardowe: ",round(std_dev,2))
# print("Minimalna wartość: ",round(min_value,2))
# print("Maksymalna wartość: ",round(max_value,2))

# Punkt 2: Wczytanie pliku "Wzrost.csv" i zastosowanie funkcji z modułu statistics.

import statistics

file_path_wzrost = 'Wzrost.csv'
data_wzrost = pd.read_csv(file_path_wzrost)

# Konwersja nazw kolumn na listę wartości
wzrost_values = [float(height) for height in data_wzrost.columns]

df_wzrost = pd.DataFrame(wzrost_values, columns=['Wzrost'])

variance_wzrost = statistics.variance(df_wzrost['Wzrost'])
std_dev_wzrost = statistics.stdev(df_wzrost['Wzrost'])

# print("Wariancja: ",variance_wzrost)
# print("Odchylenie standardowe: ",std_dev_wzrost)


import scipy.stats as stats

second_numeric_column = data.select_dtypes(include='number').columns[1]
second_numeric_data = data[second_numeric_column]

describe_stats = stats.describe(second_numeric_data)
kurtosis = stats.kurtosis(second_numeric_data)
skewness = stats.skew(second_numeric_data)

# print("Statystyki opisowe dla wybranej kolumny:")
# print(f"- Liczba obserwacji (nobs): {describe_stats.nobs} (Ilość wartości w kolumnie)")
# print(f"- Zakres wartości (minmax): od {describe_stats.minmax[0]} do {describe_stats.minmax[1]} (Minimalna i maksymalna wartość)")
# print(f"- Średnia (mean): {describe_stats.mean} (Średnia arytmetyczna wartości)")
# print(f"- Wariancja (variance): {describe_stats.variance} (Miara rozproszenia danych wokół średniej)")
# print(f"- Skośność (skewness): {skewness} (Miara asymetrii rozkładu danych wokół średniej)")
# print(f"- Kurtoza (kurtosis): {kurtosis} (Miara 'ostrości' szczytu rozkładu i grubości jego ogonów)")
#
# print("\nDodatkowe statystyki:")
# print(f"- Kurtoza: {kurtosis} (Wartość > 0 wskazuje na rozkład 'szpiczasty', < 0 na 'płaski')")
# print(f"- Skośność: {skewness} (Wartość > 0 wskazuje na rozkład przesunięty w lewo, < 0 w prawo)")


data_brain_size = pd.read_csv('brain_size.csv', sep=';')

mean_viq = data_brain_size['VIQ'].mean()

num_females = data_brain_size[data_brain_size['Gender'] == 'Female'].shape[0]
num_males = data_brain_size[data_brain_size['Gender'] == 'Male'].shape[0]

plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.hist(data_brain_size['VIQ'], bins=10, color='skyblue', edgecolor='black')
plt.title('Histogram VIQ')

plt.subplot(1, 3, 2)
plt.hist(data_brain_size['PIQ'], bins=10, color='lightgreen', edgecolor='black')
plt.title('Histogram PIQ')

plt.subplot(1, 3, 3)
plt.hist(data_brain_size['FSIQ'], bins=10, color='salmon', edgecolor='black')
plt.title('Histogram FSIQ')

plt.tight_layout()
plt.show()

# Histogramy tylko dla kobiet
data_females = data_brain_size[data_brain_size['Gender'] == 'Female']

plt.figure(figsize=(15, 5))

plt.subplot(1, 3, 1)
plt.hist(data_females['VIQ'], bins=10, color='skyblue', edgecolor='black')
plt.title('Histogram VIQ (Female)')

plt.subplot(1, 3, 2)
plt.hist(data_females['PIQ'], bins=10, color='lightgreen', edgecolor='black')
plt.title('Histogram PIQ (Female)')

plt.subplot(1, 3, 3)
plt.hist(data_females['FSIQ'], bins=10, color='salmon', edgecolor='black')
plt.title('Histogram FSIQ (Female)')

plt.tight_layout()
plt.show()


print(f"Średnia dla kolumny VIQ: {mean_viq}")

print("Liczba kobiet:", num_females)
print("Liczba mężczyzn:", num_males)