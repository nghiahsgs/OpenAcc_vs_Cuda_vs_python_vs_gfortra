program main
        integer :: N=1000
        double precision, dimension(1000,1000) ::C1,C2,C3,C4
        double precision, dimension(4000,4000) ::C
        double precision, dimension(1000,1000) ::B1,B2,B3,B4
        double precision, dimension(4000,4000) ::B
        double precision, dimension(1000) ::E1,E2,E3,E4
        double precision, dimension(4000) ::E

        double precision :: total
        integer:: t1,t2, count_rate, count_max
        integer:: r,s,q


        
        !start log time
        call system_clock(count_max=count_max, count_rate=count_rate)
        call system_clock(t1)

        !load matrix from file in order to build C
        open(unit=1, file="matrix_1000_1000_001")
        do i=1,N
                read(1,*) C1(i,:)
        end do

        open(unit=1, file="matrix_1000_1000_003")
        do i=1,N
                read(1,*) C2(i,:)
        end do
        
        open(unit=1, file="matrix_1000_1000_005")
        do i=1,N
                read(1,*) C3(i,:)
        end do

        open(unit=1, file="matrix_1000_1000_007")
        do i=1,N
                read(1,*) C4(i,:)
        end do

        !load matrix from file in order to build B
        open(unit=1, file="matrix_1000_1000_002")
        do i=1,N
                read(1,*) B1(i,:)
        end do

        open(unit=1, file="matrix_1000_1000_004")
        do i=1,N
                read(1,*) B2(i,:)
        end do
        
        open(unit=1, file="matrix_1000_1000_006")
        do i=1,N
                read(1,*) B3(i,:)
        end do

        open(unit=1, file="matrix_1000_1000_008")
        do i=1,N
                read(1,*) B4(i,:)
        end do

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
        

        

        !build up matrix B
	do i=1,4*N
		do j=1,4*N
                        B(i,j)=0

                        if(i .le. N .and. j .le. N) then
                                B(i,j)=B1(i,j)
                        end if

                        if(i .gt. N .and. i .le. 2*N .and. j .gt. N .and. j .le. 2*N) then
                                B(i,j)=B2(i-N,j-N)
                        end if

                        if(i .gt. 2*N .and. i .le. 3*N .and. j .gt. 2*N .and. j .le. 3*N) then
                                B(i,j)=B3(i-2*N,j-2*N)
                        end if

                        if(i .gt. 3*N .and. i .le. 4*N .and. j .gt. 3*N .and. j .le. 4*N) then
                                B(i,j)=B4(i-3*N,j-3*N)
                        end if
		end do
	end do


        !build up matrix C
	do i=1,4*N
		do j=1,4*N
                        C(i,j)=0

                        if(i .le. N .and. j .le. N) then
                                C(i,j)=C1(i,j)
                        end if

                        if(i .gt. N .and. i .le. 2*N .and. j .gt. N .and. j .le. 2*N) then
                                C(i,j)=C2(i-N,j-N)
                        end if

                        if(i .gt. 2*N .and. i .le. 3*N .and. j .gt. 2*N .and. j .le. 3*N) then
                                C(i,j)=C3(i-2*N,j-2*N)
                        end if

                        if(i .gt. 3*N .and. i .le. 4*N .and. j .gt. 3*N .and. j .le. 4*N) then
                                C(i,j)=C4(i-3*N,j-3*N)
                        end if
		end do
	end do
        

        !build up matrix E
	do i=1,4*N
                        E(i)=0

                        if(i .le. N) then
                                E(i)=E1(i)
                        end if

                        if(i .gt. N .and. i .le. 2*N) then
                                E(i)=E2(i-N)
                        end if

                        if(i .gt. 2*N .and. i .le. 3*N) then
                                E(i)=E3(i-2*N)
                        end if

                        if(i .gt. 3*N .and. i .le. 4*N) then
                                E(i)=E4(i-3*N)
                        end if
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

