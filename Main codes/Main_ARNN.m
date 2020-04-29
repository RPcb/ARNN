clc;
clear;
close all;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%    data preparation   %%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%    Input any time-series data   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%    Dataset folder: Data, including gene expression, HK hospital admission,  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    tempressure, SLP, Solar, stock, traffic, typhoon, wind speed    %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%    example:  Lorenz  system    %%%%%%%%%%%%%%%%%%%

Y=mylorenz(30);% coupled lorenz system
%load Y;
noisestrength=0;
X=Y+noisestrength*rand(size(Y));% noise could be added

Accurate_predictions=0;
ii=0;
while ii<3000                    % run each case sequentially with different initials
    ii = ii+2;      
    disp(['Case number: ', num2str(ii/2)]);       %init
    trainlength=11;         %  length of training data (observed data), m
    xx=X(2000+ii:size(X,1),:)';       % after transient dynamics
    noisestrength=0;   % strength of noise
    xx_noise=xx+noisestrength*rand(size(xx));
    
    traindata=xx_noise(:,1:trainlength);
    
    k=60;  % embedding dimension, which could be determined using FNN or set empirically
    
    predict_len=5;     % L
    
    jd=1; % the index of target variable
    
    D=size(xx_noise,1);     % number of variables in the system.
    real_y=xx(jd,:);
    real_y_noise=real_y+noisestrength*rand(size(real_y));
    traindata_y=real_y_noise(1:trainlength);
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%    ARNN start     %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Given a set of fixed weights for F for each time points: A*F(X^t)=Y^t, F(X^t)=B*(Y^t) 
    traindata_x_NN=NN_F2(traindata);
    
    %%% Randomly given a set of weights for F each time points: A*F(X)=Y, F(X)=B*Y
    % clear NN_traindata;
    % for i=1:trainlength
    %    traindata_x_NN(:,i)=NN_F(traindata(:,i));
    % end
    
    w_flag=zeros(size(traindata_x_NN,1));
    A=zeros(predict_len,size(traindata_x_NN,1));   % matrix A
    B=zeros(size(traindata_x_NN,1),predict_len);   % matrix B
    for iter=1:1000         % cal coeffcient B
        random_idx=sort([jd,randsample(setdiff(1:size(traindata_x_NN,1),jd),k-1)]);
        traindata_x=traindata_x_NN(random_idx,1:trainlength);        % random chose k variables from F(D)
        
        clear super_bb super_AA;
        for i=1:size(traindata_x,1)
            %  Ax=b,  1: x=pinv(A)*b,    2: x=A\b,    3: x=lsqnonneg(A,b)
            b=traindata_x(i,1:trainlength-predict_len+1)';     % 1*(m-L+1)
            clear B_w;
            for j=1:trainlength-predict_len+1
                B_w(j,:)=traindata_y(j:j+predict_len-1);
            end
            B_para=(B_w\b)';
            B(random_idx(i),:)=(B(random_idx(i),:)+B_para+B_para*(1-w_flag(random_idx(i))))/2;
            w_flag(random_idx(i))=1;
        end
       
    end
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%  side prediction based on B  %%%%%%%%%%%%%%%%%%%%%%%%%
    clear super_bb super_AA;
    for i=1:size(traindata_x_NN,1)
        kt=0;
        clear bb;
        AA=zeros(predict_len-1,predict_len-1);
        for j=(trainlength-(predict_len-1))+1:trainlength
            kt=kt+1;
            bb(kt)=traindata_x_NN(i,j);
            %col_unknown_y_num=j-(trainlength-(predict_len-1));
            col_known_y_num=trainlength-j+1;
            for r=1:col_known_y_num
                bb(kt)=bb(kt)-B(i,r)*traindata_y(trainlength-col_known_y_num+r);
            end
            AA(kt,1:predict_len-col_known_y_num)=B(i,col_known_y_num+1:predict_len);
        end
        
        super_bb((predict_len-1)*(i-1)+1:(predict_len-1)*(i-1)+predict_len-1)=bb;
        super_AA((predict_len-1)*(i-1)+1:(predict_len-1)*(i-1)+predict_len-1,:)=AA;
    end

    pred_y_tmp=(super_AA\super_bb')';
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%  Final prediction  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tmp_y=[real_y(1:trainlength), pred_y_tmp];
    for j=1:predict_len
        Ym(j,:)=tmp_y(j:j+trainlength-1);
    end
    BX=[B,traindata_x_NN];
    IY=[eye(predict_len),Ym];
    A=IY*pinv(BX);
    clear  union_predict_y_NN;
    for j1=1:predict_len-1
        tmp_y=zeros(predict_len-j1,1);
        kt=0;
        for j2=j1:predict_len-1
            kt=kt+1;
            row=j2+1;
            col=trainlength-j2+j1;
            tmp_y(kt)=A(row,:)*traindata_x_NN(:,col);
        end     
        union_predict_y_ARNN(j1)=mean(tmp_y);
    end
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%      result display    %%%%%%%%%%%%%%%%%%%%%%
    
    myreal=real_y(trainlength+1:trainlength+predict_len-1);
    RMSE = sqrt(immse(union_predict_y_ARNN, myreal));
    RMSE = RMSE /(std(myreal) + 0.001);      % normalized RMSE
    if RMSE < 0.5
        Accurate_predictions = Accurate_predictions + 1;
    end
    Accurate_prediction_rate = Accurate_predictions/(ii/2);
    disp(['Accurate_prediction_rate: ', num2str(Accurate_prediction_rate)]);
    disp('');
    
    refx=X(2000+ii-100:size(X,1),:)';          %  Lorenz reference
    
    figure(1);
    subplot(2,1,1);
    plot(refx(jd,1:150),'c-*','LineWidth',2,'MarkerSize',4);
    hold on;
    plot([101:100+trainlength],real_y(1:trainlength),'-*','LineWidth',2,'MarkerSize',4);
    title(['\fontsize{18}original attractor. Init: ', num2str(ii),', Noise strength: ',num2str(noisestrength)]);
    set(gca,'FontSize',10);
    hold off;
    
    subplot(2,1,2);
    plot([1:trainlength],real_y_noise(1:trainlength),'-*','LineWidth',2,'MarkerSize',4);
    hold on;
    plot([trainlength+1:trainlength+predict_len-1],real_y_noise(trainlength+1:trainlength+predict_len-1),'c-p','MarkerSize',4,'LineWidth',2);
    hold on;
    plot([trainlength+1:trainlength+predict_len-1],union_predict_y_ARNN,'ro','MarkerSize',5,'LineWidth',2);
    title(['\fontsize{18}ARNN Union Pred:  m=',num2str(trainlength),', L=',num2str(predict_len),', RMSE=',num2str(RMSE)]);
    set(gca,'FontSize',10);
    hold off;
    
    pause(1);
end


