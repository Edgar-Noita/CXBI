%ADMM using BM3D for each stage 

clear
lon=256; %number of data points used in the reconstruction
load('Path_to_measurements_vector\y.mat')
load('Path_to_air_scattering\air.mat')



load('Path_to_coded_apertures\code_it1.mat')
load('Path_to_ground_truth\mat');%name of variable: energy
addpath('Path_to_bm3d_denoiser\bm3d')


n=32;%size of images
iter=100; %number of iterations

rho=[1,10:10:100]; %vector that contains the values of rho
sigma=[1,10:10:100];%vector that contains the values of sigma(for the denoising part)

A=[];
step=512/lon(longi); %indexing of the measurements according to the amount of data used in the reconstructions: 512 is the length of y
indexes=1:step:512;

y=y(indexes)- air(indexes);

for i=1:step:512
   A(i,:)=code_shift{i}(:);
  
end
    

for rho_x=1:length(rho)
    fprintf(strcat('ro= ',num2str(rho(rho_x))))
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
   
            x{i}(x{i}<0)=0; %force negative data to be zero
   
            z{i}=BM3D(reshape(x{i}+u{i-1},[n,n]),sigma(sigma_x));
  
            z{i}(z{i}<0)=0; %force negative data to be zero
    
            z{i}=z{i}(:);
            u{i}=u{i-1}+x{i}-z{i};
            u{i}(u{i}<0)=0;
            my_ssim_vec(i)=ssim(reshape(x{i},[n,n]),energy);
            if (i>=10) %break loop if SSIM does not change by 1e-3
                if (my_ssim_vec(i)-my_ssim_vec(i-1)<(1e-3))
                    break
                end
            end
                
           
        end
        my_ssim(rho_x,sigma_x)=ssim(reshape(x{i},[n,n]),energy); %saving ssim values for all combination rho,sigma
    end
end
%find the maximum SSIM, and its rho,sigma
[a,b]=find(my_ssim==max(my_ssim(:)));
rho_x=rho(a(1));
sigma_x=sigma(b(1));
term1=A'*A+(rho_x)*eye(n^2);

%run ADMM one last time with optimal rho,sigma
clear x
clear z
clear u
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
  
  