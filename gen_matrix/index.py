import random

def writeFile(file_name,ndung):
    #f=open(file_name,mode='w', encoding='utf-8')
    f=open(file_name,mode='w')
    f.write(kq)
    f.close()
def render_2D_matrix(nb_rows, nb_cols):
    kq=''
    for i in range(nb_rows):
        for j in range(nb_cols):
            r=random.random()
            kq+='%s    '%r
        kq+='\n'
    return kq

def render_1D_matrix(nb_rows):
    kq=''
    for i in range(nb_rows):
        r=random.random()
        kq+='%s'%r
        kq+='\n'
    return kq

#
#N=1000
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_1000_1000_001.txt',kq)
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_1000_1000_002.txt',kq)
#
#kq=render_1D_matrix(N)
#writeFile('matrix_1000_1_001.txt',kq)


#N=2000
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_2000_2000_001.txt',kq)
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_2000_2000_002.txt',kq)
#
#kq=render_1D_matrix(N)
#writeFile('matrix_2000_1_001.txt',kq)

#N=4000
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_4000_4000_001.txt',kq)
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_4000_4000_002.txt',kq)
#
#kq=render_1D_matrix(N)
#writeFile('matrix_4000_1_001.txt',kq)
#
#N=8000
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_8000_8000_001.txt',kq)
#
#kq=render_2D_matrix(N,N)
#writeFile('matrix_8000_8000_002.txt',kq)
#
#kq=render_1D_matrix(N)
#writeFile('matrix_8000_1_001.txt',kq)
#

#using to build up large matrix
N=1000

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_003.txt',kq)

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_004.txt',kq)

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_005.txt',kq)

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_006.txt',kq)

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_007.txt',kq)

kq=render_2D_matrix(N,N)
writeFile('matrix_1000_1000_008.txt',kq)

kq=render_1D_matrix(N)
writeFile('matrix_1000_1_002.txt',kq)

kq=render_1D_matrix(N)
writeFile('matrix_1000_1_003.txt',kq)

kq=render_1D_matrix(N)
writeFile('matrix_1000_1_004.txt',kq)

