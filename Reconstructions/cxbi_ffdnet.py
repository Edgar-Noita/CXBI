

#This code is an adaptation of the FFDNET code that can be found in  #github: https://github.com/cszn/KAI https://github.com/cszn/FFDNet



import os.path
import logging

import numpy as np
from scipy.io import savemat
from collections import OrderedDict

import torch

from utils import utils_logger #This data was downloaded from the authors of FFDNET
from utils import utils_image as util
from scipy.io import loadmat



def main(noised_image,noise_level_img):
   #PLEASE IMPLEMENT THE FFDNET CODE AVAILABLE IN https://github.com/cszn/KAIR
   #The main function of the FFDNET was modified accordingly to the CXBI needs
   #If need more details, please contact the authors
    
    return img_E
     
#############################################################
##ADMM for CXBI
###########################################################
if __name__ == '__main__':
    
    itera=100
    n=32
    lon=[256]
    dbs=[10000]
   
    perc=[10,20,50]
   
   
 
    for rep in range(1,2,1):
    
        for perc_i in perc:
 
            for longi in lon:
                
                data=loadmat('Path_to_y_data/y_data.mat')
                y=np.double(data['y'])
                data_air=loadmat('Path_to_y_data/y_air.mat')
                air=np.double(data['air'])
                data_GT=loadmat('Path_to_ground_truth/GT.mat')#assume the variable is called energy
                GT=np.double(data_GT['energy'])
                data_code=loadmat('Path_to_code/code_it1.mat')
                code_shift=np.double(data_code['code_shift'])
                step=(512)/longi
                    
                indexes=np.arange(0,512,step)
                    
                y=np.matrix.transpose(y[0,indexes.astype(int)]-air[0,indexes.astype(int)])
                
                y=np.expand_dims(y,-1) 
           
                A=np.zeros((longi,n**2))
                cont=0
                for j in indexes:
      
                    code_aux=np.double(code_shift[0,np.int(j)])
                    code_aux=np.matrix.flatten(code_aux)
                    A[cont,:]=code_aux
                    cont=cont+1 
  
                rho=[0.01,0.1,1,10]
                sigma=np.arange(1,121,20)
     
                my_ssim=np.zeros((len(rho),len(sigma)))
                my_ssim_vec=np.zeros((1,100))
                acum_rho=0
                for rho_x in range(len(rho)):
                    print(rho[rho_x])
                    term1=np.dot(np.matrix.transpose(A),A)+rho[rho_x]*np.identity(n**2)
                    acum_sigma=0
                    for sigma_x in range(len(sigma)):
                        print(sigma[sigma_x])
                        x=np.zeros((n**2,1))
                        z=np.zeros((n**2,1))
                        u=np.zeros((n**2,1))
                        my_ssim_vec=np.zeros((1,100))
                        for k in range(itera):
                            
                            term2=np.dot(np.matrix.transpose(A),y)+rho[rho_x]*(z-u)
                            x=np.linalg.lstsq(term1,term2,rcond=None)
                            x=x[0]
         
                            x[x<0]=0
                            aux_xu=x+u
               
                            aux_xu=np.reshape(aux_xu,(n,n))
                
                    
                            z=main(aux_xu,sigma[sigma_x])
              
                            z[z<0]=0
               
                            z=np.expand_dims(np.matrix.flatten(z),-1)
                            u=u+x-z
                            u[u<0]=0
                            x_aux=np.reshape(x,(n,n))
                            my_ssim_vec[0,k]=util.calculate_ssim(x_aux,GT,0)
                            if (k>10):
                                if (my_ssim_vec[0,k]-my_ssim_vec[0,k-1]<1e-3):
                                    break
                                
             
                        x=np.reshape(x,(n,n))
                        ssim=util.calculate_ssim(x, GT,0)
                            #my_ssim=ssim
                        my_ssim[acum_rho,acum_sigma]=ssim
                            #my_ssim=ssim
                        acum_sigma=acum_sigma+1
                        
                    acum_rho=acum_rho+1    
                
       
                max_xy = np.where(my_ssim == my_ssim.max())
                indx_rho=np.int(max_xy[0])
                indx_sigma=np.int(max_xy[1])
                rho=rho[indx_rho]
                sigma=sigma[indx_sigma]
                x=np.zeros((n**2,1))
                z=np.zeros((n**2,1))
                u=np.zeros((n**2,1))
                term1=np.dot(np.matrix.transpose(A),A)+rho*np.identity(n**2)
                my_ssim_vec=np.zeros((1,100))
                print('Starting final stage')
                for k in range(itera):
             
                    term2=np.dot(np.matrix.transpose(A),y)+rho*(z-u)
                    x=np.linalg.lstsq(term1,term2,rcond=None)
                    x=x[0]
                        
                    x[x<0]=0
                    aux_xu=x+u
       
                    aux_xu=np.reshape(aux_xu,(n,n))
                
                    z=main(aux_xu,sigma)
       
                    z[z<0]=0
                
                    z=np.expand_dims(np.matrix.flatten(z),-1)
                    u=u+x-z
                    u[u<0]=0
                    x_aux=np.reshape(x,(n,n))
                    my_ssim_vec[0,k]=util.calculate_ssim(x_aux,GT,0)
                    if (k>10):
                        if (my_ssim_vec[0,k]-my_ssim_vec[0,k-1]<1e-3):
                            break
                x=np.reshape(x,(n,n))
                my_ssim_final=util.calculate_ssim(x, GT,0)
       
   
            
