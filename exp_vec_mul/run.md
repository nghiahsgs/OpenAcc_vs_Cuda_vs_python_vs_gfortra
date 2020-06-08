+ run using python
        + python3 vec_mul.py
+ run using gfortran
        + gfortran vec_mul.f95 && ./a.out
+ run using PGI
        + PGI open acc (GPU): /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=tesla:cc75,host -Minfo vec_mul_open_acc.f95
        + PGI open acc (multiple core):
+ run using nvcc (cuda):
        + usr/local/cuda-10.2/bin/nvcc vec_mul.cu -arch=sm_75
~                                                                
