+ using python (may pc tren phenika):
	+ command: 
		+ python vec_quantum.py
	+ result 2828.488236225371
	+ total time 821.9536001682281 (seconds)

+  using gfortran (may pc tren phenikaa):
	+ command: 
		+ gfortran vec_quantum.f95
	+ result   2828.4882362253711     
	+ total time   36.1590004     seconds

+ using python (server):
	+ command: 
		+ python vec_quantum.py
	+ result 2828.48823623
	+ total time 1085.01003003 (seconds)

+ using gfortran (server):
	+ command: 
		+ gfortran vec_quantum.f95
	+ result   2828.4882362253711     
 	+ total time   27.2220001     seconds

+ using open acc:
	+ Multiple core:
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=multicore -Minfo vec_quantum_open_acc.f95 
			+ export ACC_NUM_CORES=64 
			+ ./a.out
		+ result    2828.488236228744     
 		+ total time   0.5115370     seconds
		
	+ GPU
		+ command: 
			+ /opt/pgi/linux86-64/19.10/bin/pgfortran -ta=tesla:cc75,host -Minfo vec_quantum_open_acc.f95
			+ ./a.out
		+ result    2828.488236225344     
 		+ total time    1.153926     seconds
+ using cuda
	+ command: 
		+ /usr/local/cuda-10.2/bin/nvcc vec_quantum.cu -arch=sm_75
	+ result :2828.488236
	+ total time:1.730000 seconds
	
