function [Z, objV] = prox_sp_norm_weighted(Y, tau, opts)

if isfield(opts, 'sp');                    sp = opts.sp;                            end
if isfield(opts, 'type');                  type = opts.type;                        end
% tyep: 0 - tc, 1 - image recovery, 2 - background substraction. 

[n1, n2, n3] = size(Y);
m = min(n1, n2);
Y = fft(Y, [], 3);
objV = 0;
for i = 1:n3
    [U, S, V] = svd(Y(:, :, i),'econ');

    switch type
        case 0
            w = diag(S);
            w = w./max(w)*length(w);
            w = w(end:-1:1);
            w = 1./(0.8 + exp(-w));
        case 1
            w = diag(S);
            w = w(end:-1:1);
            w = 1./(0.8+exp(-w));
        case 2
            w = diag(S);
            w = w./max(w)*length(w);
            w = w(end:-1:1);
            w = 1./(0.8 + exp(-w));
    end

    for j = 1:m
        weight = w(j)*tau;
        Ntp = (2*weight*(1-sp))^(1/(2-sp)) + weight*sp*(2*weight*(1-sp))^((sp-1)/(2-sp));
        S(j, j) =  update_omega_sp_norm_weighted(S(j, j), weight, sp, Ntp);
        objV = objV + S(j, j)^sp/n3*weight;
    end
    Y(:, :, i) = U*S*V';
end
Z = ifft(Y, [], 3);
    
    
end