import matplotlib.pyplot as plt
%matplotlib inline
plt.style.use('ggplot')

plt.figure(num=None, figsize=(12, 6), dpi=80, facecolor='w', edgecolor='k')

x = ['python', 'gfortran', 'open acc multiple core','open acc gpu', 'cuda']
energy = [0.231669902802,4.00000019E-03,9.0852998E-02,0.8277830,0.000000]

x_pos = [i for i, _ in enumerate(x)]

plt.bar(x_pos, energy, color='green')
plt.xlabel("Platforms")
plt.ylabel("Time (seconds)")
plt.title("Using different platforms in order to compare run time: A (NxN) + B (NxN) where N=1000")

plt.xticks(x_pos, x)

plt.show()

