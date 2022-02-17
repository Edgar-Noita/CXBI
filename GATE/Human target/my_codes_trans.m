
%inputs:
%trans: Transmittance of codes (50%=>0.5)
%n x m: size if the mask



function code=my_codes_trans(trans,n,m)

number=round((n*m)*trans);


indexes=randperm(n*m,number);

index_x=mod((indexes-1),n)+1;
index_y=floor((indexes-1)/n)+1;

code=zeros(n,m);
for i=1:number
code(index_x(i),index_y(i))=1;
end

