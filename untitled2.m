tic
I = imread('pout.tif');
J = stdfilt(I);
R = corr2(I,J)
toc
