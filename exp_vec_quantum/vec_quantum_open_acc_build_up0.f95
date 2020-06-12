program main
        integer :: N=1000
        double precision, dimension(4,1000,1000) ::C_x
        double precision, dimension(4000,4000) ::C
        double precision, dimension(4,1000,1000) ::B_x
        double precision, dimension(4000,4000) ::B
        double precision, dimension(4,1000) ::E_x
        double precision, dimension(1000) ::E1,E2,E3,E4
        double precision, dimension(4000) ::E
        character(len=1024)::file_name_C,file_name_B,file_name_E
        double precision :: total
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q


        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)
        
        !load matrix from file in order to build C
        open(unit=1, file="matrix_1000_1000_001")
        do i=1,N
                read(1,*) C_x(1,i,:)
        end do

        open(unit=1, file="matrix_1000_1000_003")
        do i=1,N
                read(1,*) C_x(2,i,:)
        end do
        
        open(unit=1, file="matrix_1000_1000_005")
        do i=1,N
                read(1,*) C_x(3,i,:)
        end do

        open(unit=1, file="matrix_1000_1000_007")
        do i=1,N
                read(1,*) C_x(4,i,:)
        end do
        !load matrix from file in order to build B
        open(unit=1, file="matrix_1000_1000_002")
        do i=1,N
                read(1,*) B_x(1,i,:)
        end do

        open(unit=1, file="matrix_1000_1000_004")
        do i=1,N
                read(1,*) B_x(2,i,:)
        end do
        
        open(unit=1, file="matrix_1000_1000_006")
        do i=1,N
                read(1,*) B_x(3,i,:)
        end do

        open(unit=1, file="matrix_1000_1000_008")
        do i=1,N
                read(1,*) B_x(4,i,:)
        end do
       !load matrix from file in order to build E
        !open(unit=1, file="matrix_1000_1_001")
        !do i=1,N
        !        read(1,*) E_x(1,i)
        !end do

        !open(unit=1, file="matrix_1000_1_002")
        !do i=1,N
        !        read(1,*) E_x(2,i)
        !end do
        !
        !open(unit=1, file="matrix_1000_1_003")
        !do i=1,N
        !        read(1,*) E_x(3,i)
        !end do

        !open(unit=1, file="matrix_1000_1_004")
        !do i=1,N
        !        read(1,*) E_x(4,i)
        !end do
       !load matrix from file in order to build E
        open(unit=1, file="matrix_1000_1_001")
        do i=1,N
                read(1,*) E1(i)
        end do

        open(unit=1, file="matrix_1000_1_002")
        do i=1,N
                read(1,*) E2(i)
        end do
        
        open(unit=1, file="matrix_1000_1_003")
        do i=1,N
                read(1,*) E3(i)
        end do

        open(unit=1, file="matrix_1000_1_004")
        do i=1,N
                read(1,*) E4(i)
        end do
        


        total=0.d0
        !$acc data copyin(C_x(:,:,:),B_x(:,:,:),E1(:),E2(:),E3(:),E4(:)) create(B(4*N,4*N),C(4*N,4*N),E(4*N))
        

        !build up matrix B
        !$acc kernels loop 
        do i=1,4*N
                do j=1,4*N
                        B(i,j)=0
                        C(i,j)=0

                        if(i .le. N .and. j .le. N) then
                                B(i,j)=B_x(1,i,j)
                                C(i,j)=C_x(1,i,j)
                        end if

                        if(i .gt. N .and. i .le. 2*N .and. j .gt. N .and. j .le. 2*N) then
                                B(i,j)=B_x(2,i-N,j-N)
                                C(i,j)=C_x(2,i-N,j-N)
                        end if

                        if(i .gt. 2*N .and. i .le. 3*N .and. j .gt. 2*N .and. j .le. 3*N) then
                                B(i,j)=B_x(3,i-2*N,j-2*N)
                                C(i,j)=C_x(3,i-2*N,j-2*N)
                        end if

                        if(i .gt. 3*N .and. i .le. 4*N .and. j .gt. 3*N .and. j .le. 4*N) then
                                B(i,j)=B_x(4,i-3*N,j-3*N)
                                C(i,j)=C_x(4,i-3*N,j-3*N)
                        end if
                end do
        end do

        !$acc end kernels

        !build up matrix E
        !$acc kernels loop 
        do i=1,4*N
                        E(i)=0

                        if(i .le. N) then
                                !E(i)=E_x(1,i)
                                E(i)=E1(i)
                        end if

                        if(i .gt. N .and. i .le. 2*N) then
                                !E(i)=E_x(2,i-N)
                                E(i)=E2(i-N)
                        end if

                        if(i .gt. 2*N .and. i .le. 3*N) then
                                !E(i)=E_x(3,i-2*N)
                                E(i)=E3(i-2*N)
                        end if

                        if(i .gt. 3*N .and. i .le. 4*N) then
                                !E(i)=E_x(4,i-3*N)
                                E(i)=E4(i-3*N)
                        end if
        end do

        !$acc end kernels
        !$acc end data
        print *, C(100,100);
        print *, B(100,100);
        print *, E(100);

        !$acc data present(B,C,E) create(B(:,:),C(:,:),E(:))
        !$acc kernels loop 

        do r=1,4*N
                do s=1,4*N
                        do q=1,4*N
                                total=total+C(r,s)*B(s,q)*(cos(E(q)-E(r))-cos(E(s)-E(q)))/(10+E(s)-E(q)/2-E(r)/2)
                        enddo
                enddo
        enddo
        !$acc end kernels
        !$acc end data
        
        !end log time
        call system_clock(t2)

        print *,'result',total
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main
