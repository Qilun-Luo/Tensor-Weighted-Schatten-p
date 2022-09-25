% clc
clear
close all

rng('shuffle')

%% ----Path settings----
addpath('utils')
addpath(genpath('algs\'));
data_path = 'data\';
file_name = 'BSD';
ext_name = 'jpg';

imageNames = dir(fullfile(data_path, file_name, strcat('*.',ext_name)));
imageNames = {imageNames.name}';

%% Algs
flag_tensor_weighted_sp = 1;
sp_list = 0.5:0.1:0.9;

%% Running
for i = 1:length(imageNames)
% for i = 1:1
    % -- Load data
    im_name = fullfile(data_path,file_name,imageNames{i});
    fprintf('Runing the image %d: %s\n', i, im_name);
    X = double(imread(im_name))/255;
    maxP = max(abs(X(:)));
    [n1,n2,n3] = size(X);
    Xn = X;
    
    rhos = 0.1;
    ind = find(rand(n1*n2,1)<rhos);
    for j = 1:n3
        tmp = X(:,:,j);
        tmp(ind) = rand(length(ind),1);
        Xn(:,:,j) = tmp;
    end
      
    psnr_list = [];
    ssim_list = [];
    alg_name = {};
    alg_result = {};
    alg_cnt = 1;

    % -- Sample
    X_psnr_sample = psnr(Xn, X);
    X_ssim_sample = ssim(Xn, X);
    psnr_list(alg_cnt) = X_psnr_sample;
    ssim_list(alg_cnt) = X_ssim_sample;
    alg_name{alg_cnt} = 'Corrupted';
    alg_result{alg_cnt} = Xn;
    alg_cnt = alg_cnt + 1;
    
    % -- tensor weighted sp --
    if flag_tensor_weighted_sp
        lambda_0 = 1/(sqrt(max(n1,n2)*n3));
        slope_k = (lambda_0-0.005)/(1-0.1);
        for kk = 1:length(sp_list)
            sp = sp_list(kk);
            lambda = slope_k*(sp-1)+lambda_0;
            opts = [];
            opts.sp = sp;
            opts.mu =1e-2;
            opts.tol = 1e-8;
            opts.rho = 1.2;
            opts.DEBUG = 0;
            opts.max_iter = 500;
            opts.type = 1;
            sp_name = sprintf('sp_%02d', round(sp*10));
            alg_name{alg_cnt} = strcat('tensor_weighted_',sp_name);
            fprintf('Processing method: %12s\n', alg_name{alg_cnt});
            [X_t_sp, S_t_sp, err, iter] = trpca_weighted_sp(Xn, lambda, opts);
            X_dif_t_sp = X_t_sp - X;
            res_t_sp = norm(X_dif_t_sp(:))/norm(X(:));
            X_psnr_t_sp = psnr(X_t_sp, X);
            X_ssim_t_sp = ssim(X_t_sp, X);
            psnr_list(alg_cnt) = X_psnr_t_sp;
            ssim_list(alg_cnt) = X_ssim_t_sp;
            alg_result{alg_cnt} = X_t_sp;
            alg_cnt = alg_cnt + 1;
        end
    end
    
    % --- Result table ----
    fprintf('%24s\t%4s\t%4s\n', 'Algs', 'PSNR', 'SSIM');
    for j = 1:alg_cnt-1
        fprintf('%24s\t%.4f\t%.4f\n', alg_name{j},  psnr_list(j), ssim_list(j));
    end  
end