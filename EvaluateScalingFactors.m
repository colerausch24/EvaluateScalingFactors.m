m = 120;
n = 10;
total_experiments = 1e5; 
n_t_values = [10, 20, 30, 40, 50];

for n_t = n_t_values
    fprintf('Testing for n_t = %d\n', n_t);
    fprintf('sqrt(n_t) = %.4f\n', sqrt(n_t));

    scaling_factors = [];

    for exp = 1:total_experiments
        W = randn(m, n);
        x0 = randn(n, 1);
        x1 = randn(n, 1);
        t_values = linspace(0, 1, n_t);

        a = zeros(m, n_t - 1);

        for k = 1:(n_t - 1)
            t0 = t_values(k);
            t1 = t_values(k + 1);
            xt0 = (1 - t0) * x0 + t0 * x1;
            xt1 = (1 - t1) * x0 + t1 * x1;
            a(:, k) = max(0, W * xt0) - max(0, W * xt1);
        end

        lhs = sum(vecnorm(a, 2, 1));
        rhs = vecnorm(sum(a, 2), 2);

        scaling_factor = lhs / rhs;
        scaling_factors = [scaling_factors, scaling_factor];
    end

    avg_scaling_factor = mean(scaling_factors);
    max_scaling_factor = max(scaling_factors);

    fprintf('Average scaling factor for n_t = %d: %.4f\n', n_t, avg_scaling_factor);
    fprintf('Max scaling factor for n_t = %d: %.4f\n', n_t, max_scaling_factor);
    fprintf('-------------------------------\n');
end