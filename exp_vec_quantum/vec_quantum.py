import math
import io
import time

def load_matrix_2D_from_file(file_name):
    f=io.open(file_name, mode='r', encoding='utf-8')
    ndung=f.read()
    f.close()

    A=[]
    list_rows=ndung.split('\n')

    for row in list_rows[:-1]:
        row_add=[]

        list_cols=row.split('    ')
        for col in list_cols[:-1]:
            row_add.append(float(col))
        A.append(row_add)
    return A

def load_matrix_1D_from_file(file_name):
    f=io.open(file_name, mode='r', encoding='utf-8')
    ndung=f.read()
    f.close()

    A=[]
    list_rows=ndung.split('\n')

    for row in list_rows[:-1]:
        A.append(float(row))
    return A

C=load_matrix_2D_from_file('matrix_1000_1000_001.txt')
B=load_matrix_2D_from_file('matrix_1000_1000_002.txt')
E=load_matrix_1D_from_file('matrix_1000_1_001.txt')

#start log time
t1=time.time()

N=1000
total=0
for r in range(N):
    for s in range(N):
        for q in range(N):
            total+=C[r][s]*B[s][q]*(math.cos(E[q]-E[r])-math.cos(E[s]-E[q]))/(10+E[s]-E[q]/2-E[r]/2)

#end log time
t2=time.time()
print('result %s'%total)
print('total time %s (seconds)'%(t2-t1))
