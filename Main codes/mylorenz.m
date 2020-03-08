function Y=mylorenz(N)

time =100;
stepsize=0.02;
l=round(time/stepsize);
%N=12;
x=zeros(3*N,l);
% x(:,1)=rand(1,3*N);
x(:,1)=0.1*ones(1,3*N);
% Lorenz system
C=0.1;

for i=1:l-1
    
    x(1,i+1)=x(1,i)+stepsize*(10*(x(2,i)-x(1,i))+C*x(1+(N-1)*3,i));
    x(2,i+1)=x(2,i)+stepsize*(28*x(1,i)-x(2,i)-x(1,i)*x(3,i));
    x(3,i+1)=x(3,i)+stepsize*(-8/3*x(3,i)+x(1,i)*x(2,i));
    for j=1:N-1
        x(1+3*j,i+1)=x(1+3*j,i)+stepsize*(10*(x(2+3*j,i)-x(1+3*j,i))+C*x(1+3*(j-1),i));
        x(2+3*j,i+1)=x(2+3*j,i)+stepsize*(28*x(1+3*j,i)-x(2+3*j,i)-x(1+3*j,i)*x(3+3*j,i));
        x(3+3*j,i+1)=x(3+3*j,i)+stepsize*(-8/3*x(3+3*j,i)+x(1+3*j,i)*x(2+3*j,i));
    end
end

Y=x';