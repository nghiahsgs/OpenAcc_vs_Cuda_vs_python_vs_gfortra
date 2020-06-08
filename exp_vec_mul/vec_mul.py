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

A=load_matrix_2D_from_file('matrix_1000_1000_001.txt')
B=load_matrix_2D_from_file('matrix_1000_1000_002.txt')

#start log time
t1=time.time()

N=1000
total=0
for i in range(1000):
    for j in range(1000):
        total+=A[i][j]*B[i][j]
total=total/(N*N)

#end log time
t2=time.time()
print('result %s'%total)
print('total time %s (seconds)'%(t2-t1))
