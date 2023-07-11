clear all
close all
clc
% Load data
[FileName, PathName, FilterIndex] = uigetfile('*.asc; *.dat; *.txt; *.hdf5');
filename = [PathName, FileName];
format long;
% Load text files
dat = readtable(strcat(filename));

xval = reshape(dat.Var1, 80, 160);
yval = reshape(dat.Var2, 80, 160);
data1 = reshape(dat.Var3, 80, 160);
data2 = reshape(dat.Var4, 80, 160);

% Create complex signal data
data = data1 + data2*j;

% Decompose and reconstruct from level-1 through 4
for i = 1:4
    [A1, H1, V1, D1] = swt2(data1, i, 'coif3');
    [A2, H2, V2, D2] = swt2(data2, i, 'coif3');

    for j = 0:3
        A1_m = zeros(size(A1));
        H1_m = zeros(size(H1));
        V1_m = zeros(size(V1));
        D1_m = zeros(size(D1));
    
        A2_m = zeros(size(A2));
        H2_m = zeros(size(H2));
        V2_m = zeros(size(V2));
        D2_m = zeros(size(D2));

        if j == 0
            A1_m(:, :, i) = A1(:, :, i);
            A2_m(:, :, i) = A2(:, :, i);
            tag = "A";
        elseif j == 1
            H1_m(:, :, i) = H1(:, :, i);
            H2_m(:, :, i) = H2(:, :, i);
            tag = "H";
        elseif j == 2
            V1_m(:, :, i) = V1(:, :, i);
            V2_m(:, :, i) = V2(:, :, i);
            tag = "V";
        else
            D1_m(:, :, i) = D1(:, :, i);
            D2_m(:, :, i) = D2(:, :, i);
            tag = "D";
        end

        % Reconstruct
        scp_inv1 = iswt2(A1_m, H1_m, V1_m, D1_m, 'coif3');
        scp_inv2 = iswt2(A2_m, H2_m, V2_m, D2_m, 'coif3');
    
        % Save the reconstructed data
        fwname = strjoin(["data2B_rec_", tag, int2str(i),".txt"],'');
        writematrix([scp_inv1(:)';scp_inv2(:)']', fwname)
    
    end
end