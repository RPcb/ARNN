# ARNN

Run ARNN algorithm:

Resource code file folder: Main codes

***********************************************************************************************************
Test the ARNN Robustness:

File folder: Robustness test

***********************************************************************************************************
Prediction results show:

Lorenz model results,

Movie1: typhoon prediction.mp4, 

Movie2: traffic prediction.mp4

***********************************************************************************************************
Data resources:

Folder: Data, which includes gene expression, HK hospital admission, Ozone(tempreture and SLP), Solar, wind speed, stock, traffic, typhoon dataset.

***********************************************************************************************************
Note: 
1. For Lorenz model simulation, 

   noise-free & time-invariant cases:  use "Main codes/mylorenz.m" to generate high-dimensional data, to set ""noisestrength = 0" in "Main codes/sample_code_ARNN.m";
   
   noisy & time-invariantcases: use "Main codes/mylorenz.m" to generate high-dimensional data, set "noisestrength" to be 0.5, 2, 4 in "Main codes/sample_code_ARNN.m", respectively;
   
   time-varying cases: use "Main codes/mylorenz_dynamic.m" to generate high-dimensional data, set "noisestrength = 0" in "Main codes/sample_code_ARNN.m".

2. For windspeed dataset, unzip the compressed files first, then  

   cat scale_windspeed_PARTa* > scale_windspeed_a.txt   

   M = dlmread('scale_windspeed_a.txt'); 

   save('scale_windspeed_a.mat', M);
