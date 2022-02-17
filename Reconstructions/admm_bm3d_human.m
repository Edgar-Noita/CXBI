%ADMM using BM3D for each stage 

clear
lon=512; %Number of data points used in the reconstruction
%perc=[5,10,15,25];
perc=0.1; %code transmittance..(10%=>0.1)
dbs=10000; %standard deviation of artifical noise
rho=[1:10:110]; %vector defining the values of rho
sigma=[1:10:110]; %vectors defining the values of sigma
n=64; %size of the image, in this case, 64 x 64  
[y,code_shift,energy]=synthetic_data(perc(perc_i),dbs(dbs_i),n); %generation of the syntethic data
             
addpath('Path_to_BM3D\bm3d')
iter=100; %number of iterations
A=[];
step=((n^2)/2)/lon(longi);
indexes=1:step:(n^2)/2;
y=y(indexes);
for i=1:step:(n^2)/2 %ensemble A matrix
     A(floor(i/step)+1,:)=code_shift{i}(:);
end
               

for rho_x=1:length(rho)
     fprintf(strcat('ro= ',num2str((rho_x))))
     term1=A'*A+rho(rho_x)*eye(n^2);
     for sigma_x=1:length(sigma)
         x{1}=zeros(n^2,1); %initilization of variables
         z{1}=zeros(n^2,1);
         u{1}=zeros(n^2,1);
         my_ssim_vec=zeros(1,100);
         for i=2:iter
             %ADMM algorithm
             term2=A'*y'+rho(rho_x)*(z{i-1}-u{i-1});
             x{i}=cgs(term1,term2);
             x{i}(x{i}<0)=0;
   
             z{i}=BM3D(reshape(x{i}+u{i-1},[n,n]),sigma(sigma_x));
  
             z{i}(z{i}<0)=0;
        
             z{i}=z{i}(:);
             u{i}=u{i-1}+x{i}-z{i};
             u{i}(u{i}<0)=0;
             my_ssim_vec(i)=ssim(reshape(x{i},[n,n]),energy);
             if (i>=10)
                 if (my_ssim_vec(i)-my_ssim_vec(i-1)<(1e-3))
                     break
                  end
              end
           end
           my_ssim(rho_x,sigma_x)=ssim(reshape(x{i},[n,n]),energy);
      end
end
[a,b]=find(my_ssim==max(my_ssim(:))); %find the optimal SSIM, sigma and rho
clear x
clear u
clear z
rho_x=rho(a(1));
sigma_x=sigma(b(1));
% A final iteration using optimal values of sigma, rho
term1=A'*A+(rho_x)*eye(n^2);
x{1}=zeros(n^2,1);
z{1}=zeros(n^2,1);
u{1}=zeros(n^2,1);
my_ssim_vec=zeros(1,100);
for i=2:iter
           
     term2=A'*y'+(rho_x)*(z{i-1}-u{i-1});
     x{i}=cgs(term1,term2);
    
      x{i}(x{i}<0)=0;
   
    
      z{i}=BM3D(reshape(x{i}+u{i-1},[n,n]),(sigma_x));
   
      z{i}(z{i}<0)=0;
      z{i}=z{i};
   
      z{i}=z{i}(:);
      u{i}=u{i-1}+x{i}-z{i};
      u{i}(u{i}<0)=0;
      my_ssim_vec(i)=ssim(reshape(x{i},[n,n]),energy);
      if (i>=10)
          if (my_ssim_vec(i)-my_ssim_vec(i-1)<(1e-3))
              break
           end
          end
end

my_ssim_final=ssim(reshape(x{i},[n,n]),energy);
 
     