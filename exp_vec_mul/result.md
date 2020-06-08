+ using python (may pc tren phenika):
	+ command: 
		+ python vec_mul.py
	+ result 0.2503873862973699
	+ total time 0.20991182327270508 (seconds)

+  using gfortran (may pc tren phenikaa):
	+ command: 
		+ gfortran vec_mul.f95
	+ result  0.25038738629736990     
	+ total time  8.00000038E-03     seconds

+ using python (server):
	+ command: 
		+ python vec_mul.py
	+ result  0.250387386297
	+ total time   0.233169078827 (seconds)

+ using gfortran (server):
	+ command: 
		+ gfortran vec_mul.f95
	+ result    0.25038738629736990    
 	+ total time      7.00000022E-03  seconds

+ using open acc:
	+ Multiple core:
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=multicore -Minfo vec_mul_open_acc.f95 
			+ export ACC_NUM_CORES=64 
			+ ./a.out
		+ result   0.2503873862973607     
 		+ total time   9.4286002E-02 seconds

		
	+ GPU
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=tesla:cc75,host -Minfo vec_mul_open_acc.f95
			+ ./a.out
		+ result   0.2503873862973608     
		+ total time   0.8944120     seconds

+ using cuda
	+ command: 
		+ /usr/local/cuda-10.2/bin/nvcc vec_mul.cu -arch=sm_75
		+ ./a.out
	+ result : 0.250387
	+ total time: 0.000000 seconds

