clear all
close all
clc
% Load data
[FileName, PathName, FilterIndex] = uigetfile('*.asc; *.dat; *.txt; *.hdf5');
filename = [PathName, FileName];
format long;
% Load text files
dat = importdata(strcat(filename));

% data shape for 2D ELDOR  
[dim1, dim2] = size(dat);

% Decompose and reconstruct from level-1 through 4
for i = 1:4
    [A1, H1, V1, D1] = swt2(dat, i, 'coif3');

    for j = 0:3
        A1_m = zeros(size(A1));
        H1_m = zeros(size(H1));
        V1_m = zeros(size(V1));
        D1_m = zeros(size(D1));
    

        if j == 0
            A1_m(:, :, i) = A1(:, :, i);
            tag = "A";
        elseif j == 1
            H1_m(:, :, i) = H1(:, :, i);
            tag = "H";
        elseif j == 2
            V1_m(:, :, i) = V1(:, :, i);
            tag = "V";
        else
            D1_m(:, :, i) = D1(:, :, i);
            tag = "D";
        end

        % Reconstruct
        scp_inv1 = iswt2(A1_m, H1_m, V1_m, D1_m, 'coif3');
    
        % Save the reconstructed data
        fwname = strjoin(["eldor_rec_", tag, int2str(i),".txt"],'');
        writematrix(reshape(scp_inv1(:),dim1,dim2), fwname)
    
    end
end