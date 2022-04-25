# CXBI
This repository contains all the GATE/Matlab/Python routines needed to replicate the results of the paper Low-dose X-ray Compton Backscattering Imaging via Structured Light. Original paper can be found in http://opg.optica.org/oe/abstract.cfm?URI=oe-30-9-15211}; supplementary material can be found in https://opticapublishing.figshare.com/articles/software/Compressive_X-rays_Compton_Backscattering_Imaging_Software/19229052

# Abstract

Compton Back-scattering imaging (CBI) is a technique that uses ionizing radiation to determine the presence of low atomic number materials on a given target. Unlike transmission X-ray imaging, the source and sensor are located on the same side, such that the photons of interest are scattered back after the radiation impinges on the body. Rather than scanning the target pixel by pixel with a pencil beam, this paper proposes the use of cone beam coded illumination to create a Compressive X-rays Compton  Back-scattering Imager (CXBI). The concept  was developed and tested using Montecarlo Simulations through the Geant4 Application for Tomography Emissions (GATE), with conditions close to the ones encountered on experiments, and posteriorly, a test-bed implementation was mounted in the laboratory. The CXBI was evaluated under several conditions and with different materials as target. 
Reconstructions  were run using denoising-prior based inverse problem algorithms. Finally, a preliminary dose analysis is done to evaluate the viability of CXBI for human scanning.

# Proposed CXBI vs Pencil-beam


![main_fig_3](https://user-images.githubusercontent.com/85708477/154503590-11a044bf-79ab-48fb-9b04-2d767e9d2efe.png)

# Data organization-GATE

The files in this repository are organized as follows: 
## GATE implementation (Figs. 5 and 6 of the paper)

In this folder you will find two different folders. The first one called CXBI runs the data acquistion with the conditions given in the paper. The following files will be found in this folder

### main.mac: 
It contains all the conditions of the experiment.
### spec_120.txt:
It contains the energy distribution for the implemented x-rays source.This data can be generated using SPEKTR https://istar.jhu.edu/downloads/
### Target_box.mac: 
It creates the 4 boxes target
### Target_hand.mac: 
It creates hand target
### GateMaterials.db
This file contains all the materials used in Gate simulations
### steles
This folder contains the stls files implemented in the simulations, including the coded apertures, the UD target, and the hand. The Hand stl was found in https://www.cgtrader.com/items/3001341/download-page. The boxes were defined using the basic shapes in GATE
### dumpTreeToTxt.C
This file extracts the the data from the root files in txt format. Please refer to https://root-forum.cern.ch/t/conversion-of-root-file/25813/22?page=2 for the original file
### data
Folder that contains the measurements vector extracted from GATE for 1% transmittance, 10% transmittance and 50% transmittance, and their respective coded apertures
## Ground-truth generation
In this folder, you will find all the needed files to generate the groundtruth images
### main.mac: 
It contains all the conditions of the experiment.
### spec_120.txt:
It contains the energy distribution for the implemented x-rays source.This data can be generated using SPEKTR https://istar.jhu.edu/downloads/
### movement_32.placements
It describes the movement of the pencil-beam over a 32x32 grid.
### steles
This folder contains the stls files implemented in the simulations, including the UD target, and the hand. The Hand stl was found in https://www.cgtrader.com/items/3001341/download-page. The boxes were defined using the basic shapes in GATE
### data
Folder that contains the ground-truths for UD, boxes and Hand
## Human Target
In this folfer, you will find all the needed files to generate the human target implemented in the paper.
### main.mac: 
It contains all the conditions of the experiment.
### spec_120.txt:
It contains the energy distribution for the implemented x-rays source.This data can be generated using SPEKTR https://istar.jhu.edu/downloads/
### movement_64.placements
It describes the movement of the pencil-beam over a 64x64 grid.
### steles
This folder contains the stls files implemented in the simulations, including the human shape and the firearm. The Human shape stl was found in https://www.cgtrader.com/items/655802/download-page. The firearm was found in https://cults3d.com/en/3d-model/tool/the-phantom-s-guns-holsters.
### data
Folder that contains the human target captured with GATE
### my_code_trans.mat
It generates a coded aperture with given dimensions and transmittance
### synthetic_data.m
It generates the CXBI data synthetically, using a random mask generated with matlab

# Data organization-Reconstructions
This folder contains the files to run the reconstruction algorithms.
### admm_bm3d.m
Matlab file that implementy the ADMM algorihtm, with BM3D as denoiser. The BM3D was dowloaded from https://webpages.tuni.fi/foi/GCF-BM3D/

### admm_bm3d_human.m
Matlab file that implementy the ADMM algorihtm, with BM3D as denoiser, for the human target, using synthetic generation of measurements and noise. The BM3D was dowloaded from https://webpages.tuni.fi/foi/GCF-BM3D/

### cxbi_ffdnet.py
Python script that implements the ADDM algorithm, with FFDNET as denoiser. The FFDNET files and trained networks were downloaded from https://github.com/cszn/KAIR

# Data organization-Dose Analysis
This folder contains the files to calculate the dose for the hand.
### 2_mm.mat
This file contains the energies of the photons arriving to a pixel of the target in one shots
### mask_hand.mat
This file contains a binary mask where the "ones" are the pixels on the hand that are affected by the radiation
### mus_skel.mat 
This file contains the Mas-attenuation coefficients to calculate the radiation. Please see the following link https://physics.nist.gov/PhysRefData/XrayMassCoef/ComTab/muscle.html
### dose_estimation.mat
This files estimates the dose per pixel; notice that given that not all energy points are defined mus_skel.mat, an interpolation is done to fill the missing data
### dose_hand.mat
This file calculates the final dose for the hand, based on the results of dose_estimation.mat, the binary mask, and the coded aperture. 

# Data organization-experiments

This folder contains the captured data during the conducted experiments.


### codes_bin

This file contains the binarized versions of the patterns

### y_empty

This files contains a vector representing the captured data with no target


### y_target

This files contains a vector representing the captured data with target

The original captured coded apertures can be found in https://drive.google.com/drive/folders/1QvCcSPVx9AgOAdgjCwD_8QW5u-PCDFja?usp=sharing

# Citation

If used, please cite the following paper:

@article{Salazar:22,
author = {Edgar Salazar and Xiaokang Liu and Gonzalo Arce},
journal = {Opt. Express},
keywords = {Attenuation coefficient; Computed tomography; Hyperspectral imaging; Structured light; Visible light; X ray optics},
number = {9},
pages = {15211--15226},
publisher = {OSA},
title = {X-ray Compton backscattering imaging via structured light},
volume = {30},
month = {Apr},
year = {2022},
url = {http://opg.optica.org/oe/abstract.cfm?URI=oe-30-9-15211},
doi = {10.1364/OE.456610},
}


 
