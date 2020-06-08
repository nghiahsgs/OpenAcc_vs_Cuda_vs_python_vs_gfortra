program main
        double precision, dimension(1000,1000) ::C,B
        double precision, dimension(1000) ::E
        double precision :: total
        integer :: N=1000
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q

        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)

        !load matrix from file
        open(unit=1, file='matrix_1000_1000_001.txt')
        do i=1,N
                read(1,*) C(i,:)
        end do

        !load matrix from file
        open(unit=1, file='matrix_1000_1000_002.txt')
        do i=1,N
                read(1,*) B(i,:)
        end do

        !load matrix from file
        open(unit=1, file='matrix_1000_1_001.txt')
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

        !end log time
        call system_clock(t2)

        print *,'result',total
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main

