% Main script which compares the performance of the copula vs the
% conditional gaussian model for hybrid distributions

%% 2-D simulation
clear;
clc;

n = 1000;
[X_real, U_real] = gen_hybriddata_2D( n );
x1_domain = unique(X_real(:,1));
h = histogram(X_real(:,1),length(x1_domain));
x1_values = h.Values/n;
[f2,x2] = ksdensity(X_real(:,2));

% fit X_real to a conditional gaussian model
[x1_domain, x1_multinomial_est, x2_mle_params] = fit_clg_2D( X_real );
% generate samples from the derived generative model
X_clg_gen = gen_samples_clg_2D(x1_domain, x1_multinomial_est, x2_mle_params, n);

% fit X_real w/ empirical copula and empirical marginals
% first continue the random variable
X1_continued = X_real(:,1) + (rand(n,1)-1);
X_transformed = [X1_continued X_real(:,2)];
K = n;
D = size(X_real,2);
[ U_gen, ~, U_emp ] = emp_copularnd( X_transformed, n, K );

Z_sorted = zeros(n,D);
for d=1:D
    [Z_sorted(:,d), ~] = sort(X_real(:,d));
end
Z_sorted = Z_sorted';

% apply inverse transform to generate samples from this joint distribution
X_gen = zeros(n,D);
for d=1:D
    for j=1:n
        un = U_gen(j,d)*n;
        i = ceil(un);
        X_gen(j,d) = Z_sorted(d,i);
    end
end

%%%%%%%%%%%%%% VISUALIZATION %%%%%%%%%%%%%%

% visualize the simulation data
subplot(2,2,1)
stem(x1_domain, x1_values)
xlabel('X_1')
ylabel('"Real" f(x_1)')
grid on

subplot(2,2,2)
plot(x2,f2/sum(f2))
xlabel('X_2')
ylabel('"Real" f(x_2)')
grid on

subplot(2,2,3)
scatter(U_real(:,1),U_real(:,2))
xlabel('U_1')
ylabel('U_2')
grid on
title('"Real" Dependency Structure')

subplot(2,2,4)
scatter(X_real(:,1),X_real(:,2))
xlabel('X_1')
ylabel('Y_1')
grid on
title('"Real" Joint Distribution')

figure;
subplot(1,3,1);
scatter(X_real(:,1),X_real(:,2));
grid on
xlabel('X_1')
ylabel('X_2')
title('Empirical Data')

subplot(1,3,2);
scatter(X_gen(:,1),X_gen(:,2));
grid on
xlabel('X_1')
ylabel('X_2')
title('Copula Generative Model')

subplot(1,3,3);
scatter(X_clg_gen(:,1),X_clg_gen(:,2));
grid on
xlabel('X_1')
ylabel('X_2')
title('CLG Generative Model')

fprintf('Copulas WIN\n')

%% 3-D simulation
clear;
clc;
setupPath;

n = 1000;
D = 3;
[X_real, U_real] = gen_hybriddata_3D( n );

[ x1_domain, x1_multinomial_est, mle_params ] = fit_clg_3D( X_real );
[X1X2_clg_gen, X1X3_clg_gen, X2X3_clg_gen] = ...
    gen_samples_clg_3D(x1_domain, x1_multinomial_est, mle_params, n);

X1_continued = X_real(:,1) + (rand(n,1)-1);
X_transformed = [X1_continued X_real(:,2) X_real(:,3)];
K = n;
D = size(X_real,2);
[ U_gen, ~, U_emp ] = emp_copularnd( X_transformed, n, K );

Z_sorted = zeros(n,D);
for d=1:D
    [Z_sorted(:,d), ~] = sort(X_real(:,d));
end
Z_sorted = Z_sorted';

% apply inverse transform to generate samples from this joint distribution
X_gen = zeros(n,D);
for d=1:D
    for j=1:n
        un = U_gen(j,d)*n;
        i = ceil(un);
        X_gen(j,d) = Z_sorted(d,i);
    end
end


% do an R-style "pairs" plot of the empirical data
subplot(3,3,1)
axis([0 1 0 1])
text(0.5,0.5,'X_1')

subplot(3,3,2)
scatter(X_real(:,1),X_real(:,2))
grid on
title('Empirical Data')

subplot(3,3,3)
scatter(X_real(:,1),X_real(:,3))
grid on

subplot(3,3,4)
scatter(X_real(:,2),X_real(:,1))
grid on

subplot(3,3,5)
axis([0 1 0 1])
text(0.5,0.5,'X_2')

subplot(3,3,6)
scatter(X_real(:,2),X_real(:,3))
grid on

subplot(3,3,7)
scatter(X_real(:,3),X_real(:,1))
grid on

subplot(3,3,8)
scatter(X_real(:,3),X_real(:,2))
grid on

subplot(3,3,9)
axis([0 1 0 1])
text(0.5,0.5,'X_3')

% do an R-style "pairs" plot of the CLG Generated data
figure;
subplot(3,3,1)
axis([0 1 0 1])
text(0.5,0.5,'X_1')

subplot(3,3,2)
scatter(X1X2_clg_gen(:,1),X1X2_clg_gen(:,2))
grid on
title('CLG Generative Model')

subplot(3,3,3)
scatter(X1X3_clg_gen(:,1),X1X3_clg_gen(:,2))
grid on

subplot(3,3,4)
scatter(X1X2_clg_gen(:,2),X1X2_clg_gen(:,1))
grid on

subplot(3,3,5)
axis([0 1 0 1])
text(0.5,0.5,'X_2')

subplot(3,3,6)
scatter(X2X3_clg_gen(:,1),X2X3_clg_gen(:,2))
grid on

subplot(3,3,7)
scatter(X1X3_clg_gen(:,2),X1X3_clg_gen(:,1))
grid on

subplot(3,3,8)
scatter(X2X3_clg_gen(:,2),X2X3_clg_gen(:,1))
grid on

subplot(3,3,9)
axis([0 1 0 1])
text(0.5,0.5,'X_3')

% do an R-style "pairs" plot of the Copula Generated data
figure;
subplot(3,3,1)
axis([0 1 0 1])
text(0.5,0.5,'X_1')

subplot(3,3,2)
scatter(X_gen(:,1),X_gen(:,2))
grid on
title('Copula Generative Data')

subplot(3,3,3)
scatter(X_gen(:,1),X_gen(:,3))
grid on

subplot(3,3,4)
scatter(X_gen(:,2),X_gen(:,1))
grid on

subplot(3,3,5)
axis([0 1 0 1])
text(0.5,0.5,'X_2')

subplot(3,3,6)
scatter(X_gen(:,2),X_gen(:,3))
grid on

subplot(3,3,7)
scatter(X_gen(:,3),X_gen(:,1))
grid on

subplot(3,3,8)
scatter(X_gen(:,3),X_gen(:,2))
grid on

subplot(3,3,9)
axis([0 1 0 1])
text(0.5,0.5,'X_3')

fprintf('Copulas WIN Again -- what did you expect?\n')