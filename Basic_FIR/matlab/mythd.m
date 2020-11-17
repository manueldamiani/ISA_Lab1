Y_matlab = importdata("gr13_results.txt");
Y_C_FIR = importdata("gr13_cfilterout.txt");
THD_matlab = thd(Y_matlab)
THD_C_FIR = thd(Y_C_FIR)