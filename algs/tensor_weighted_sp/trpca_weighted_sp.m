function [L,S,err,iter, ojbV_list] = trpca_weighted_sp(X,lambda,opts)


tol = 1e-8; 
max_iter = 500;
rho = 1.1;
mu = 1e-4;
max_mu = 1e10;
DEBUG = 0;
sp = 0.7;

if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'mu');          mu = opts.mu;                end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end
if isfield(opts, 'DEBUG');       DEBUG = opts.DEBUG;          end
if isfield(opts, 'sp');          sp = opts.sp;                end
if isfield(opts, 'type');        type = opts.type;            end

dim = size(X);
L = zeros(dim);
S = L;
Y = L;

ojbV_list = [];
sp_opts = [];
sp_opts.iter_begin_flag = 1;
sp_opts.L = L;
sp_opts.sp = sp;
sp_opts.type = type;


for iter = 1 : max_iter
    Lk = L;
    Sk = S;
    % update L
    [L, objV] = prox_sp_norm_weighted(-S+X-Y/mu, 1/mu, sp_opts);
    sp_opts.iter_begin_flag = 0;
    sp_opts.L = L;
    % update S
    S = prox_l1(-L+X-Y/mu,lambda/mu);
    dY = L+S-X;
    chgL = max(abs(Lk(:)-L(:)));
    chgS = max(abs(Sk(:)-S(:)));
    chg = max([ chgL chgS max(abs(dY(:))) ]);
    ojbV_list = [ojbV_list objV + norm(S(:))*lambda];
    if DEBUG
        if iter == 1 || mod(iter, 10) == 0
            err = norm(dY(:));
            disp(['iter ' num2str(iter) ', mu=' num2str(mu) ...
                    ', err=' num2str(chg)]); 
        end
    end
    
    if chg < tol
        break;
    end 
    Y = Y + mu*dY;
    mu = min(rho*mu,max_mu);    
end
err = norm(dY(:));