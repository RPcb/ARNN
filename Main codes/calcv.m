function CorrVariables = calcv(target, X, flag, cutoff, win_size)
% Inputs:
%    target variable: target, size: <1,m>
%    high dimensional short term data: X, size: <n, m>
%    flag: PCC, MI
% Outputs:
%    The most correlated variables of X with the target variable: CorrVariables

if nargin==3
    cutoff=0.5;
    win_size=10;
elseif nargin==4
    win_size=10;
end

clear CorrVariables;
cvi=0;
for v=1:size(X,1)
    if strcmp(flag,'PCC')      % Linear correlation: Pearson coefficient correlation
        tmp_corr=corr(X(v,:)',target')
    elseif strcmp(flag,'MI')    % Nonlinear correlation: Mutual information
        x(:,1)=target';
        x(:,2)=X(v,:)';
        [xrow, xcol] = size(x);
        bin = zeros(xrow,xcol);
        n=win_size;
        pmf = zeros(n,2);
        for i = 1:2
            minx = min(x(:,i));
            maxx = max(x(:,i));
            binwidth = (maxx - minx) / win_size;
            edges = minx + binwidth*(0:n);
            histcEdges = [-Inf edges(2:end-1) Inf];
            [occur,bin(:,i)] = histc(x(:,i),histcEdges,1);
            pmf(:,i) = occur(1:n)./xrow;
        end
        jointOccur = accumarray(bin,1,[n,n]);
        jointPmf = jointOccur./xrow;
        Hx = -(pmf(:,1))'*log2(pmf(:,1)+eps);
        Hy = -(pmf(:,2))'*log2(pmf(:,2)+eps);
        Hxy = -(jointPmf(:))'*log2(jointPmf(:)+eps);
        MI = Hx+Hy-Hxy;
        zMI = MI/sqrt(Hx*Hy);
        tmp_corr=zMI;
    end
    if tmp_corr>cutoff
        cvi=cvi+1;
        CorrVariables(cvi,:)=X(v,:);
    end
end
