import matplotlib.pyplot as plt
%matplotlib inline
plt.style.use('ggplot')

plt.figure(num=None, figsize=(12, 6), dpi=80, facecolor='w', edgecolor='k')

x = ['gfortran', 'open acc multiple core','open acc gpu', 'cuda']
energy = [27.2220001, 0.5115370, 1.153926 ,1.730000]

x_pos = [i for i, _ in enumerate(x)]

plt.bar(x_pos, energy, color='green')
plt.xlabel("Platforms")
plt.ylabel("Time (seconds)")
plt.title("Using different platforms in order to compare run time: demo calc in quantum where N=1000")

plt.xticks(x_pos, x)

plt.show()

