
clear
load('Path_to_mask_hand\mask_hand.mat');
load('Path_to_dose\dose.mat'); %calculated using dose_estimation.mat
load('Path_to_code_aperture\code_it1.mat')
on=0;
lon=256;
step=512/lon;
for j=1:step:512
        on=on+sum(sum(code_shift{j}.*BW));
end
dose_tot=on*dose;

