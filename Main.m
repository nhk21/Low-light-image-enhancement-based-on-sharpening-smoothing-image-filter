%An implementation of the "Low-light image enhancement based on 
%sharpening-smoothing image filter"
%
% If you use this code, please cite the following paper:
%   @article{demir2023low,
%   title={Low-light image enhancement based on sharpening-smoothing image filter},
%   author={Demir, Y and Kaplan, NH},
%   journal={Digital Signal Processing},
%   pages={104054},
%   year={2023},
%   publisher={Elsevier}
% }
clc
clear all
close all

%input image
img=imread("images\inputs\8.jpg");

%Apply HSV transform to the input image
[h s v] = rgb2hsv(img);

%Set SSIF parameter to optimum values(These values are the default values)
radius = 19;
epsilon = 0.001;
kappa = 2;
scale = 0.1;


%Apply multiscale SSIF to V component
level1 = SSIF(v, v, radius, epsilon, kappa, scale);
level2 = SSIF(level1, level1, radius, epsilon, kappa, scale);

%Calculate the detail images
detail1 = v - level1;
detail2 = level1 - level2;

%Apply CLAHE to residual image(Set CLAHE parameters)
enhanced_residual = adapthisteq(level2,"NumTiles",[2 2],"ClipLimit",0.01);

%Final  V component
v_final = (detail1 + detail2) + enhanced_residual;

%final output
final_enhanced_result = cat(3, h, s, v_final);
%Apply inverse-HSV transform  to the final output
final_enhanced_result = hsv2rgb(final_enhanced_result);

imshow(final_enhanced_result)
