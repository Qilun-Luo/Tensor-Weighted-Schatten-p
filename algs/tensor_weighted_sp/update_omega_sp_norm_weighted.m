function omega = update_omega_sp_norm_weighted(omega, tau, p, Ntp)

    if omega <= Ntp
        omega = 0;
    else
        % fixed point method
        iter_max = 100;
        tol = 1e-12;
        x0 = omega;
        iter = 0;
        while iter < iter_max
            x = omega - tau*p*x0^(p-1);
            rel_err = abs(x - x0);
            if rel_err < tol
                break;
            end
            x0 = x;
            iter = iter + 1;
        end
        omega = x;
        
        if iter==iter_max
            fprintf('Fixed point iteration not converge!\n')
        end
        
        
        
    end

end



