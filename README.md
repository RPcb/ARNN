# ARNN

Run ARNN algorithm:
file folder: Main codes

Test the ARNN Robustness:
file folder: Robustness test

prediction results show:
Movie1: typhoon prediction.mp4, 
Movie2: traffic prediction.mp4


Note: 
For windspeed dataset, unzip the compressed files first, then  
cat scale_windspeed_PARTa* > scale_windspeed_a.txt   
M = dlmread('scale_windspeed_a.txt'); %Use a better name that M
save('scale_windspeed_a.mat', M);
