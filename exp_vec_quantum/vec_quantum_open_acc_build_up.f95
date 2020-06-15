!load small matrix from cpu to gpu and build up big matrix in gpu
program main
        integer :: N=1000
        double precision, dimension(4,1000,1000) ::C_x, B_x
        double precision, dimension(4000,4000) ::C,B

        double precision, dimension(4,1000) ::E_x
        double precision, dimension(1000) ::E1,E2,E3,E4
        double precision, dimension(4000) ::E

        character(len=1024)::file_name_C,file_name_B,file_name_E

        double precision :: total
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q,x,i,j


        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)

         !load matrix from file in order to build C,B,E
         do x=1,4
                 write(file_name_C ,"(A19,I1)") "matrix_1000_1000_00",2*x-1
                 open(unit=1, file=trim(file_name_C))
                 do i=1,N
                         read(1,*) C_x(x,i,:)
                 end do
                 close(1)

                 write(file_name_B ,"(A19,I1)") "matrix_1000_1000_00",2*x
                 open(unit=1, file=trim(file_name_B))
                 do i=1,N
                         read(1,*) B_x(x,i,:)
                 end do
                 close(1)

                 write(file_name_E ,"(A19,I1)") "matrix_1000_1_00",x
                 open(unit=1, file=trim(file_name_E))
                 do i=1,N
                         read(1,*) E_x(x,i)
                 end do
                 close(1)
         end do
        !load matrix from file in order to build E
        open(unit=1, file="matrix_1000_1_001")
        do i=1,N
                read(1,*) E1(i)
        end do
        close(1)

        open(unit=1, file="matrix_1000_1_002")
        do i=1,N
                read(1,*) E2(i)
        end do
        close(1)

        open(unit=1, file="matrix_1000_1_003")
        do i=1,N
                read(1,*) E3(i)
        end do
        close(1)

        open(unit=1, file="matrix_1000_1_004")
        do i=1,N
                read(1,*) E4(i)
        end do
        close(1)



        total=0.d0
        !!$acc data copyin(C_x(:,:,:),B_x(:,:,:),E1(:),E2(:),E3(:),E4(:)) create(B(4000,4000),C(4000,4000)) copy(E(4000))
        !$acc data copyin(C_x(4,1000,1000),B_x(4,1000,1000),E_x(4,1000)) create(B(4000,4000),C(4000,4000),E(4000))

                !$acc kernels loop
                        do x=1,4
                                do i=(x-1)*N+1,x*N
                                        E(i)=E_x(x,i-(x-1)*N)
                                        do j=(x-1)*N+1,x*N
                                                C(i,j)=C_x(x,i-(x-1)*N,j-(x-1)*N)
                                                B(i,j)=B_x(x,i-(x-1)*N,j-(x-1)*N)
                                        end do
                                end do
                        end do
                !$acc end kernels
                
                !!$acc kernels loop 
                !        do i=1,4*N

                !                        E(i)=0
                !                        if(i .le. N) then
                !                                !E(i)=E1(i)
                !                                E(i)=E_x(1,i)
                !                        end if

                !                        if(i .gt. N .and. i .le. 2*N) then
                !                                !E(i)=E2(i-N)
                !                                E(i)=E_x(2,i-N)
                !                        end if

                !                        if(i .gt. 2*N .and. i .le. 3*N) then
                !                                !E(i)=E3(i-2*N)
                !                                E(i)=E_x(3,i-2*N)
                !                        end if

                !                        if(i .gt. 3*N .and. i .le. 4*N) then
                !                                !E(i)=E4(i-3*N)
                !                                E(i)=E_x(4,i-3*N)
                !                        end if
                !        end do
                !!$acc end kernels

                !!$acc kernels loop
                !        do x=1,4
                !                do i=(x-1)*N+1,x*N
                !                end do
                !        end do
                !!$acc end kernels

        !$acc end data
        
        !$acc data present(B,C,E) create(B(4000,4000),C(4000,4000)) create(E(4000))
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
        print *,E(3110)
        print *,E4(110)
        print *,E_x(4,110)

        !end log time
        call system_clock(t2)

        print *,'result',total
        print *,'total time', real(t2-t1)/real(count_rate),'seconds'
end program main


