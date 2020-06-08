program main
        double precision, dimension(1000,1000) :: A,B
        double precision :: total
        integer :: N=1000
        integer:: t1,t2, count_rate, count_max


        !load matrix from file
        open(unit=1, file='matrix_1000_1000_001.txt')
        do i=1,N
                read(1,*) A(i,:)
        end do

        !load matrix from file
        open(unit=1, file='matrix_1000_1000_002.txt')
        do i=1,N
                read(1,*) B(i,:)
        end do

        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)

        total=0
        
        !$acc kernels loop reduction(+:total)
        do i=1,N
                do j=1,N
                        total=total + A(i,j)*B(i,j)
                end do
        end do
        !$acc end kernels

        total= total / (N*N)

        !end log time
        call system_clock(t2)

        print *,'result',total
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main

