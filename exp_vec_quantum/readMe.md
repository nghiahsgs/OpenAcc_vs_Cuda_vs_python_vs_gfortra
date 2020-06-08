+ Thi nghiem nay dung de so sanh hieu suat cua Open Acc va Cuda

+ input:
        + N la so nguyen duong
        + 2 ma tran C(NxN) va B (NxN) va E(N*1) (load from file)

+ output:
```fortran
total=0.d0
do r=1,n_loop
        do s=1,n_loop
                do q=1,n_loop
                        total=total+C(r,s)*B(s,q)*(cos(E(q)-E(r))-cos(E(s)-E(q)))/(10+E(s)-E(q)/2-E(r)/2)

                enddo
        enddo
enddo
```

Open acc va cuda dung chung dau vao => so sanh ket qua va thoi gian dau ra


