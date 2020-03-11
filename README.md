# ARNN

Run ARNN algorithm:

File folder: Main codes


Test the ARNN Robustness:

File folder: Robustness test


Prediction results show:

Movie1: typhoon prediction.mp4, 

Movie2: traffic prediction.mp4


Data resources:

Folder: Data, which includes gene expression, HK hospital admission, Ozone(tempreture and SLP), Solar, wind speed, stock, traffic, typhoon dataset.


Note: 

For windspeed dataset, unzip the compressed files first, then  

cat scale_windspeed_PARTa* > scale_windspeed_a.txt   

M = dlmread('scale_windspeed_a.txt'); 

save('scale_windspeed_a.mat', M);
