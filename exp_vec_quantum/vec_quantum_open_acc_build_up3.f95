!build up matrix from file and trafer this matrix to gpu in order to calc
program main
        integer :: N=1000
        double precision, dimension(1000,1000) ::C_x,B_x
        double precision, dimension(4000,4000) ::C,B

        double precision, dimension(1000) ::E_x
        double precision, dimension(4000) ::E

        character(len=1024)::file_name_C,file_name_B,file_name_E

        double precision :: total
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q,x,i,j


        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)

        !load matrix from file in order to build C,B
        do x=1,4
                write(file_name_C ,"(A19,I1)") "matrix_1000_1000_00",2*x-1
                open(unit=1, file=trim(file_name_C))
                do i=1,N
                        read(1,*) C_x(i,:)
                end do

                write(file_name_B ,"(A19,I1)") "matrix_1000_1000_00",2*x
                open(unit=1, file=trim(file_name_B))
                do i=1,N
                        read(1,*) B_x(i,:)
                end do
                
                !update element in matrix C
                do i=(x-1)*N+1,x*N
                        do j=(x-1)*N+1,x*N
                                C(i,j)=C_x(i-(x-1)*N,j-(x-1)*N)
                                B(i,j)=B_x(i-(x-1)*N,j-(x-1)*N)
                        end do
                end do
        end do
        !load matrix from file in order to build E
        do x=1,4
                write(file_name_E ,"(A19,I1)") "matrix_1000_1_00",x
                open(unit=1, file=trim(file_name_E))
                do i=1,N
                        read(1,*) E_x(i)
                end do

                !update element in matrix E
                do i=(x-1)*N+1,x*N
                        E(i)=E_x(i-(x-1)*N)
                end do
        end do
        
        total=0.d0
        !$acc kernels loop reduction(+:total)

        do r=1,4*N
                do s=1,4*N
                        do q=1,4*N
                                total=total+C(r,s)*B(s,q)*(cos(E(q)-E(r))-cos(E(s)-E(q)))/(10+E(s)-E(q)/2-E(r)/2)
                        enddo
                enddo
        enddo
        !$acc end kernels
        
        !end log time
        call system_clock(t2)

        print *,'result',total
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main

