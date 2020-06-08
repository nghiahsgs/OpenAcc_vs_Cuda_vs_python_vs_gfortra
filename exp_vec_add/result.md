+ using python (may pc tren phenika):
	+ command: 
		+ python vec_add.py
	+ result 1.0008401174751378
	+ total time 0.20384645462036133 (seconds)

+  using gfortran (may pc tren phenikaa):
	+ command: 
		+ gfortran vec_add.f95
	+ result  1.0008401174751167
	+ total time  8.00000038E-03     seconds

+ using python (server):
	+ command: 
		+ python vec_add.py
	+ result  1.00084011748     
	+ total time   0.231669902802 (seconds)

+ using gfortran (server):
	+ command: 
		+ gfortran vec_add.f95
	+ result    1.0008401174751167    
 	+ total time      4.00000019E-03  seconds

+ using open acc:
	+ Multiple core:
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=multicore -Minfo vec_add_open_acc.f95 
			+ export ACC_NUM_CORES=64 
			+ ./a.out
		+ result    1.000840117475123     
		+ total time   9.0852998E-02 seconds
		
	+ GPU
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=tesla:cc75,host -Minfo vec_add_open_acc.f95
			+ ./a.out
		+ result    1.000840117475123
 		+ total time   0.8277830 seconds
+ using cuda
	+ command: 
		+ /usr/local/cuda-10.2/bin/nvcc vec_add.cu -arch=sm_75
	+ result : 1.000840
	+ total time: 0.000000 seconds

