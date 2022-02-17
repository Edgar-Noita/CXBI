
function [y,code_shift,energy]=synthetic_data(trans,sigma2,n)


load('\...\Path_to_GThuman.mat') %load the human groundtruth generated with GATE (name.. GT)


code=my_codes_trans(trans/100,n,(n*n/2)+n); %generate trasnmittanc

for i=1:(n^2)/2
    code_shift{i}=code(:,i:n+i-1);
    y(i)=sum(sum(code_shift{i}.*GT));
end
energy=GT;

my_noise=randn(length(y),1)*sqrt(sigma2); %add noise
y=y+my_noise';




