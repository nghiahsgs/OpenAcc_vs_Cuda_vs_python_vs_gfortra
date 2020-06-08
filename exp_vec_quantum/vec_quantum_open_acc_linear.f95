program main
        double precision, dimension(1000,1000) ::C,B
        double precision, dimension(1000) ::E
        double precision :: total,total_all
        integer :: N=1000
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q,nb_loop
        character(len=1024)::file_name_C,file_name_B,file_name_E


        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)
        
        total_all=0d0
        do nb_loop=1,4
                !load matrix from file
                write(file_name_C ,"(A19,I1)") "matrix_1000_1000_00",2*nb_loop-1
                open(unit=1, file=trim(file_name_C))
                do i=1,N
                        read(1,*) C(i,:)
                end do

                !load matrix from file
                write(file_name_B ,"(A19,I1)") "matrix_1000_1000_00",2*nb_loop
                open(unit=1, file=trim(file_name_B))
                do i=1,N
                        read(1,*) B(i,:)
                end do

                !load matrix from file
                write(file_name_E ,"(A19,I1)") "matrix_1000_1_00",nb_loop
                open(unit=1, file=trim(file_name_E))
                do i=1,N
                        read(1,*) E(i)
                end do


                total=0.d0
                
                !$acc kernels loop reduction(+:total)
                do r=1,N
                        do s=1,N
                                do q=1,N
                                        total=total+C(r,s)*B(s,q)*(cos(E(q)-E(r))-cos(E(s)-E(q)))/(10+E(s)-E(q)/2-E(r)/2)
                                enddo
                        enddo
                enddo
                !$acc end kernels
                
                total_all=total_all+total
        end do
        !end log time
        call system_clock(t2)

        print *,'result',total_all
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main

