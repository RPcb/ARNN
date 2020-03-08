function Y=mylorenz_dynamic(N,t)

time =100;
stepsize=0.02;
l=round(time/stepsize);
%N=12;
x=zeros(3*N,l);
% x(:,1)=rand(1,3*N);
x(:,1)=0.1*ones(1,3*N);
% Lorenz system
C=0.1;
alpha=10;
beta=28;
gamma=-8/3;

for i=1:l-1
    if i>=t
        sigma=alpha+0.1*floor((i-t)/10);
    else
        sigma=alpha;
    end
    x(1,i+1)=x(1,i)+stepsize*(sigma*(x(2,i)-x(1,i))+C*x(1+(N-1)*3,i));
    x(2,i+1)=x(2,i)+stepsize*(beta*x(1,i)-x(2,i)-x(1,i)*x(3,i));
    x(3,i+1)=x(3,i)+stepsize*(gamma*x(3,i)+x(1,i)*x(2,i));
    for j=1:N-1
        x(1+3*j,i+1)=x(1+3*j,i)+stepsize*(alpha*(x(2+3*j,i)-x(1+3*j,i))+C*x(1+3*(j-1),i));
        x(2+3*j,i+1)=x(2+3*j,i)+stepsize*(beta*x(1+3*j,i)-x(2+3*j,i)-x(1+3*j,i)*x(3+3*j,i));
        x(3+3*j,i+1)=x(3+3*j,i)+stepsize*(gamma*x(3+3*j,i)+x(1+3*j,i)*x(2+3*j,i));
    end
end

Y=x';