m = 120;
n = 10;
total_iterations = 1e5; 
starting_value = sqrt(2) - 0.2;
step_size = 0.1;
n_t_values = [10, 20, 30, 40, 50];

for n_t = n_t_values
    fprintf('Testing for n_t = %d\n', n_t);
    fprintf('sqrt(n_t) = %.4f\n', sqrt(n_t));

    scaling_factors = starting_value:step_size:sqrt(n_t);
    best_scaling_factor = 1.0; 
    highest_percentage = 0;
    best_avg_slack = inf;

    for sf = scaling_factors
        count_scaled = 0;
        total_slack = 0;
        ratios = [];
        slacks = [];

        for iter = 1:total_iterations
            W = randn(m, n);
            x1 = randn(n, 1);
            x2 = randn(n, 1);
            t_values = linspace(0, 1, n_t);

            % Initialize a_i
            a = zeros(m, n_t - 1);

            % Create vectors between x1 and x2
            for k = 1:(n_t - 1)
                t1 = t_values(k);
                t2 = t_values(k + 1);
                xt1 = (1 - t1) * x1 + t1 * x2;
                xt2 = (1 - t2) * x1 + t2 * x2;
                a(:, k) = max(0, W * xt1) - max(0, W * xt2);
            end

            lhs = sum(vecnorm(a, 2, 1)); % sum of ||a_i||_2
            rhs_scaled = sf * vecnorm(sum(a, 2), 2); % scaled ||sum(a_i)||_2

            slack = rhs_scaled - lhs;
            total_slack = total_slack + slack;
            slacks = [slacks, slack];

            if lhs <= rhs_scaled
                count_scaled = count_scaled + 1;
            end

            ratio = rhs_scaled / lhs;
            ratios = [ratios, ratio];
        end

        percentage_scaled = (count_scaled / total_iterations) * 100;
        avg_slack = total_slack / total_iterations;
        avg_ratio = mean(ratios);

        if percentage_scaled > highest_percentage 
            highest_percentage = percentage_scaled;
            best_scaling_factor = sf;
            best_avg_slack = avg_slack;
        end

        fprintf('Scaling factor: %.4f, Percentage: %.4f%%, Average slack: %.4f, Average ratio: %.4f\n', sf, percentage_scaled, avg_slack, avg_ratio);

        if percentage_scaled == 100
            break; % Move to the next n_t value if the percentage is 100%
        end
    end

    fprintf('Optimal scaling factor for n_t = %d: %.4f, Highest Percentage: %.4f%%, Best Average Slack: %.4f\n', n_t, best_scaling_factor, highest_percentage, best_avg_slack);
    fprintf('-------------------------------\n');
end