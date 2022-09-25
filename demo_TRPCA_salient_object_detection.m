clear
close all

%% ----Path settings----
addpath('utils')
addpath(genpath('algs\'));

cate_list = {
    'baseline',
    'baseline',
    'badWeather',
    'shadow',
};
file_list = {
    'highway',
    'PETS2006',
    'skating',
    'busStation',
};
range_list = {
    [900, 1000],
    [900, 1000],
    [900, 1000],
    [900, 1000],
};
data_path = fullfile('data', 'dataset2014', 'dataset');
output_path = fullfile('data', 'dataset2014', 'results');

test_list = 1:4;

%% Algs
flag_tensor_weighted_sp = 1;
sp_list = .1:0.2:.5;

%% Running
for t = test_list
    % Load data
    category = cate_list{t};
    idxFrom = range_list{t}(1);
    idxTo = range_list{t}(2);

    file_name = file_list{t};
    dataset_name = fullfile(category, file_name, 'input');
    output_folder = fullfile(category, file_name);
    tmp_save_path = fullfile('data', 'dataset2014', 'tmp');
    if ~exist(tmp_save_path, 'dir')
        mkdir(tmp_save_path);
    end
    mat_file = fullfile(tmp_save_path, strcat(file_name, '_', ...
        num2str(idxFrom), '_', num2str(idxTo), '.mat'));
    ext_name = 'jpg';
    show_flag = 1;
    if ~exist(mat_file, 'file')
        [X, height, width, imageNames] = load_video(data_path, ...
            dataset_name, ext_name, show_flag, idxFrom, idxTo);
        save(mat_file, 'X', 'height', 'width', 'imageNames');
    else
        load(mat_file);
    end
    [height_width, dims, nframes] = size(X);


    % -- tensor weighted sp --
    if flag_tensor_weighted_sp
        for sp = sp_list
            x = permute(X, [1,3,2]);
            [n1,n2,n3] = size(x);
            c0 = 40/7;
            b0 = 60/7;
            lambda = 10^(c0*sp-b0);

            opts = [];
            opts.sp = sp;
            opts.mu = 1e-10;
            opts.tol = 1e-8;
            opts.rho = 1.1;
            opts.DEBUG = 1;
            opts.max_iter = 500;
            opts.type = 2;
            [L, S, err, iter] = trpca_weighted_sp(x, lambda, opts);
            L = permute(L, [1,3,2]);
            S = permute(S, [1,3,2]);
            L_trpca_sp = reshape(L, [height_width, dims, nframes]);
            S_trpca_sp = reshape(S, [height_width, dims, nframes]);
            figure
            for i = 1:nframes
                subplot(1,3,1)
                imshow(uint8(reshape(L_trpca_sp(:, :, i), [height, width, dims])))
                subplot(1,3,2)
                S_trpca_sp_frame = reshape(S_trpca_sp(:, :, i), [height, width, dims]);
                imshow(uint8(S_trpca_sp_frame));
                subplot(1,3,3)
                Tmask_trpca_sp = medfilt2(double(hard_threshold(mean(S_trpca_sp_frame,3))),[5 5]);
                imshow(Tmask_trpca_sp)
                sp_name = sprintf('sp_%02.0f', sp*10);
                save_path = fullfile(output_path, output_folder, sp_name);
                if ~exist(save_path, 'dir')
                    mkdir(save_path);
                end
                imwrite(Tmask_trpca_sp, fullfile(save_path, strcat('b', imageNames{i})));
                pause(0.05)
            end
        end
    end      
    
    % Compute quantitative measures
    extension = '.jpg';
    range = [idxFrom, idxTo];
    alg_name = [];
    if flag_tensor_weighted_sp
        for sp = sp_list
            sp_name = sprintf('sp_%02.0f', sp*10);
            alg_name = [alg_name, {sp_name}];
        end
    end

    videoPath = fullfile(data_path, category, file_name);
    binaryFolder = fullfile(output_path, category, file_name);
    fprintf('===================================================\n')
    fprintf('Category: %s\tDateset: %s\n', category, file_name)
    fprintf('Alg_name\tRecall\tPrecision\tFMeasure\n')
    for i = 1:length(alg_name)
        [confusionMatrix, stats] = compute_measures(videoPath, fullfile( ...
            binaryFolder, alg_name{i}), range, extension);
        fprintf('%s\t\t%.4f\t%.4f\t%.4f\n', alg_name{i}, stats(1), stats(6), stats(7))
    end
        
end

