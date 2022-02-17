%dose calculation

clear
load('Path_to_attenuation_data/mus_skel.mat')
load('Path_to_2mm/2mm.mat')
data_en=data;
energy_points=muscle_skel(:,1); 
u_points=muscle_skel(:,3)*1000; %From g to kg
dose=0;
acum=1;

for i=1:size(data_en,1)
    en=data_en(i);
    if (en>=(1e-3))
    pos_min=energy_points(energy_points<=en); %linear interpolation
    pos_max=energy_points(energy_points>=en);
    if (size(pos_min,1)==0)
        u_est(acum)=u_points(1);
    else
        if (size(pos_max,1)==0)
            u_est(acum)=u_points(end);
        else
            
            en_min=pos_min(end);
            en_max=pos_max(1);
            f_emin=find(energy_points==en_min);
            f_emax=find(energy_points==en_max);
            u_min=u_points(f_emin(end));
            u_max=u_points(f_emax(1));
            m=(u_max-u_min)/(en_max-en_min);
            b=u_max-(m)*en_max;
            u_est(acum)=en*m+b; %Estimation of the attenuation factor with the linear interpolator
                  
        end
    end
    dose=u_est(acum)*en+dose;
    acum=acum+1;
    end
    
end

dose=dose*(1e6)*(1.60e-19); %energy in joules*(cm^2/kg).. (1e6.. pass from M to eV)... (1.6e-19).. pass from eV to J

len1=0.867; %calculation of area
area=(len1^2);

dose=dose/area; %divide by the area to cancle out cm^2)

%save('dose_source.mat','dose','area');


   

