# ARNN
Environment: MATLAB 2019

Run ARNN algorithm:

Resource code file folder: Main codes

Use "Main codes/Main_ARNN.m" for both Lorenz model and real-world datasets.

***********************************************************************************************************
Test the ARNN Robustness:

File folder: Robustness test

***********************************************************************************************************
Prediction results:

"Lorenz results",

Movie1: typhoon prediction.mp4, 

Movie2: traffic prediction.mp4

***********************************************************************************************************
Data resources:

Folder: Data, which includes gene expression, HK hospital admission, Ozone(tempreture and SLP), Solar, wind speed, stock, traffic, typhoon dataset.

***********************************************************************************************************
Note: 

1. For Lorenz model simulation, there are the following three cases:

   noise-free & time-invariant case:  use "Main codes/mylorenz.m" to generate high-dimensional data, set ""noisestrength = 0" in "Main codes/Main_ARNN.m";
   
   noisy & time-invariant case: use "Main codes/mylorenz.m" to generate high-dimensional data, set "noisestrength" to be 0.5, 2, 4 in "Main codes/Main_ARNN.m", respectively;
   
   time-varying case: use "Main codes/mylorenz_dynamic.m" to generate high-dimensional data, set "noisestrength = 0" in "Main codes/Main_ARNN.m".


2. For windspeed dataset, unzip the compressed files first, then  

   cat scale_windspeed_PARTa* > scale_windspeed_a.txt   

   M = dlmread('scale_windspeed_a.txt'); 

   save('scale_windspeed_a.mat', M);
   
   load wind speed data:  "load scaled_windspeed_a" in Matlab;


3. For high-dimensional datasets, use "Main codes/calcv.m" for variable selection by mutual information or PCC.
