% clc
clear
close all

rng('shuffle')

%% ----Path settings----
addpath(genpath('utils\'))
addpath(genpath('algs\'));

data_path = 'data\tc_data\';


%% ----Algs settings----
flag_tensor_weighted_sp = 1;
sr = 0.2; % Sample rate
data_name = {
    'mri.mat',
    'video_road.mat',
    'video_suzie.mat',
    'salesman.mat',
};
test_list = 2:4;

%% ----Running----
for t = test_list
    % Loading data
    fprintf('Dataset: %s...\n', data_name{t}) 
    load(fullfile(data_path, data_name{t}));
    
    % Sampling
    [n1, n2, n3] = size(T);
    normalize = max(T(:));
    X = T/normalize;
    chosen = find(rand(n1*n2*n3, 1)<sr);
    Xn = zeros(n1, n2, n3);
    Xn(chosen) = X(chosen);

    % record 
    psnr_list = [];
    ssim_list = [];
    alg_name = {};
    alg_result = {};
    alg_cnt = 1;
    
    % --- Sample ---
    X_psnr_sample = psnr(Xn, X);
    X_ssim_sample = ssim(Xn, X);
    psnr_list(alg_cnt) = X_psnr_sample;
    ssim_list(alg_cnt) = X_ssim_sample;
    alg_name{alg_cnt} = 'Sample';
    alg_result{alg_cnt} = Xn;
    alg_cnt = alg_cnt + 1;
    
    % --- tensor weighted sp ---
    if flag_tensor_weighted_sp
        sp_list = 0.7:0.1:0.9; % p value in Schatten-p
        for kk = 1:length(sp_list)
                sp = sp_list(kk);
                opts = [];
                opts.sp = sp;
                opts.mu =1e-4;
                opts.tol = 1e-8;
                opts.rho = 2.1 - sp;
                opts.DEBUG = 1;
                opts.Xtrue = X;
                opts.max_iter = 500;
                sp_name = sprintf('sp_%02d', round(sp*10));
                alg_name{alg_cnt} = strcat('tensor_weighted_',sp_name);
                fprintf('Processing method: %12s\n', alg_name{alg_cnt});
                [X_t_sp, Out_t_sp] = lrtc_weighted_sp(Xn, chosen, opts);
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











