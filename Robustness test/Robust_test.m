clc;
clear;
close all;

%%%%%%%%%%%%%%%%%%     example:  wind speed   %%%%%%%%%%%%
load scaled_windspeed_a;

mypred_len=[51,31,21,11];          %  length of steps
ii=1;   % init time point

for plen=1:length(mypred_len)
    disp(['   Step length: ', num2str(mypred_len(plen))]);
    noisestrength=0;
    X=scaled_windspeed_a+noisestrength*rand(size(scaled_windspeed_a));% noise could be added
    xx=X(:,ii:end);% after transient dynamics;
    
    trainlength=120;      % length of training data (observed data), m
    D=155;       %size(traindata,1);   % number of variables in the system.
    k=60;         % embedding dimension, which could be determined using FNN or set empirically
    
    predict_len=mypred_len(plen);     % L
    jd=1;         % the index of target variable
    real_y=xx(jd,:);
    cycles=floor(size(xx,2)/(predict_len-1));
    final_predict_ARNN=zeros(cycles*(predict_len-1),1);
    traindata=xx(:,1:trainlength);
    traindata_y=real_y(1:trainlength);
    
    h=waitbar(0,'please wait');
    
    for miter=1:cycles
        for i=1:trainlength
            traindata_x_NN(:,i)=NN_F(traindata(:,i));
        end
        w_flag=zeros(size(traindata_x_NN,1));
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
        
        
        final_predict_ARNN((miter-1)*(predict_len-1)+1:miter*(predict_len-1))=max(union_predict_y_ARNN,0);
        traindata=xx(:,miter*(predict_len-1)-trainlength+1+trainlength:miter*(predict_len-1)+trainlength);
        traindata_y=real_y(miter*(predict_len-1)-trainlength+1+trainlength:miter*(predict_len-1)+trainlength);
        
        myreal=real_y(trainlength+1:trainlength+miter*(predict_len-1));
        
        str=['running... ',num2str(miter/cycles*100),'%'];
        waitbar(miter/cycles, h,str);

    end
    delete(h);
    
    PCC=corr(final_predict_ARNN(1:miter*(predict_len-1)),myreal');
    
    for u=1:miter*(predict_len-1)
        error(u)=(final_predict_ARNN(u)-myreal(u))^2;
    end
    RMSE=sqrt(sum(error))/(miter*(predict_len-1));
    PCC
    RMSE
    
    close all;
    figure(plen);
    plot([ii+trainlength+1:ii+trainlength+cycles*(predict_len-1)],myreal,'c-p','MarkerSize',4,'LineWidth',1.5);
    hold on;
    plot([ii+trainlength+1:ii+trainlength+cycles*(predict_len-1)],final_predict_ARNN(1:cycles*(predict_len-1)),'-rp','MarkerSize',4,'LineWidth',1.5);
    title(['\fontsize{18}Robust test figs, len of steps=', num2str(predict_len-1), ', PCC=',num2str(PCC),', RMSE=',num2str(RMSE)]);
    hold off;
    
    saveas(gcf,['robust test figs, len of steps= ', num2str(predict_len-1),'.fig']);
    
end
