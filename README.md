# ARNN
1. System requirements

a. The codes can be run within MATLAB environment on any operating system.

b. We implemented the codes with MATLAB R2019b on Windows10/mac/unbuntu.

c. No non-standard hardware is required.

***********************************************************************************************************

2. Installation guide

a. The codes can be run directly without installation.

b. No install time is needed.

***********************************************************************************************************


3. Demo:

The code "Main codes/LongerPredictionSamples_ARNN.m" in repository can generates the results in Figure 2d,2e,2f of
the main text.

Expected running time for this demo is less than 1 minute on a "normal" desktop computer.


***********************************************************************************************************

4. Instructions for use


Run ARNN algorithm:

Resource code file folder: Main codes

Use "Main codes/Main_ARNN.m" for both Lorenz model and real-world datasets.


1. For Lorenz model simulation, there are the following three cases:

   noise-free & time-invariant case:  use "Main codes/mylorenz.m" to generate high-dimensional data, set ""noisestrength = 0" in "Main codes/Main_ARNN.m";
   
   noisy & time-invariant case: use "Main codes/mylorenz.m" to generate high-dimensional data, set "noisestrength" to be 0.1-1.0 in "Main codes/Main_ARNN.m", respectively;
   
   time-varying case: use "Main codes/mylorenz_dynamic.m" to generate high-dimensional data, set "noisestrength = 0" in "Main codes/Main_ARNN.m".


2. For windspeed dataset, unzip the compressed files first, then  

   cat scale_windspeed_PARTa* > scale_windspeed_a.txt   

   M = dlmread('scale_windspeed_a.txt'); 

   save('scale_windspeed_a.mat', M);
   
   load wind speed data:  "load scaled_windspeed_a" in Matlab;


3. For high-dimensional datasets, use "Main codes/calcv.m" for variable selection by mutual information or PCC.

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


