%% r - estimates
funs = plotFuns();
load('../data/Ballistic_r_ux_uy_30_1500.mat');

itr = max_iter_em/2-1;
times_em = times_em(1:itr,:);
% start from zero
times_em = times_em-repmat(times_em(1,:),itr,1);
lh_em = lh_em(1:itr,:);
est_em = est_em(:,1:itr,:);

times_bfgs = times_bfgs(2:itr+1,:);
zers = times_bfgs <= 0;
times_bfgs = times_bfgs-repmat(times_bfgs(1,:),itr,1);
lh_bfgs = lh_bfgs(2:itr+1,:);
est_bfgs = est_bfgs(:,2:itr+1,:);


nonnan = 1:(max_iter_em/2-1);
avg_time_em = mean(mean(diff(times_em(nonnan,:),1,1)));
df=diff(times_bfgs,1,1);
avg_time_bfgs = mean(df(df>1.1&df<1.2)); % choose a good interval

[lh_bfgs_n,est_bfgs_n] = funs.normalizeBFGS(times_bfgs,lh_bfgs,est_bfgs,avg_time_bfgs);

% LH
figure(1); clf;
% normalized
subplot(3,1,1);
plot((0:itr-1)*avg_time_em,lh_em,'-b',(0:itr-1)*avg_time_bfgs,lh_bfgs_n,'-r');
xlim([0 50]); ylim([-1e5 8000]);

% original
subplot(3,1,2);
times_bfgs(zers) = nan; lh_bfgs(zers) = nan;
plot(times_em,lh_em,'-b',times_bfgs,lh_bfgs,'-r');
xlim([0 50]); ylim([-1e5 8000]);

% mean over runs
subplot(3,1,3);
plot((0:itr-1)*avg_time_em,mean(lh_em,2),'-b',(0:itr-1)*avg_time_bfgs,mean(lh_bfgs_n,2),'-r');
xlim([0 50]); ylim([-1e5 8000]);

% EST
figure(2); clf;
% original
subplot(2,1,1);
est1 = squeeze(est_em(1,:,:));
est2 = squeeze(est_bfgs(1,:,:));
est2n = squeeze(est_bfgs_n(1,:,:));
%est1 = exp(est1);est2 = exp(est2);

times_bfgs(zers) = nan; est2(zers) = nan;
plot(times_em,est1,'-b',times_bfgs,est2,'-r');
xlim([0 50]);

% mean over runs
subplot(2,1,2);
plot((0:itr-1)*avg_time_em,mean(est1,2),'-b',(0:itr-1)*avg_time_bfgs,mean(est2n,2),'-r');
xlim([0 50]);







%%

load('../data/Ballistic_ux_uy_30_1500.mat');

itr = max_iter_em/2-1;
times_em = times_em(1:itr,:);
% start from zero
times_em = times_em-repmat(times_em(1,:),itr,1);
lh_em = lh_em(1:itr,:);


times_bfgs = times_bfgs(2:itr+1,:);
zers = times_bfgs <= 0;
times_bfgs = times_bfgs-repmat(times_bfgs(1,:),itr,1);
lh_bfgs = lh_bfgs(2:itr+1,:);

nonnan = 1:(max_iter_em/2-1);
avg_time_em = mean(mean(diff(times_em(nonnan,:),1,1)));
df=diff(times_bfgs,1,1);
avg_time_bfgs = mean(df(df>0.8&df<0.9)); % choose a good interval

lh_bfgs_n = funs.normalizeBFGS(times_bfgs,lh_bfgs,avg_time_bfgs);

% normalized
figure(1); clf;
plot((0:itr-1)*avg_time_em,lh_em,'-b',(0:itr-1)*avg_time_bfgs,lh_bfgs_n,'-r');
xlim([0 8]); ylim([-1e4 8000]);

% original
figure(2); clf;
times_bfgs(zers) = nan; lh_bfgs(zers) = nan;
plot(times_em,lh_em,'-b',times_bfgs,lh_bfgs,'-r');
xlim([0 8]); ylim([-1e4 8000]);

% mean over runs
figure(3); clf;
plot((0:itr-1)*avg_time_em,mean(lh_em,2),'-b',(0:itr-1)*avg_time_bfgs,mean(lh_bfgs_n,2),'-r');
xlim([0 8]); ylim([-1e4 8000]);


%%
% Separate
figure(1); clf;
est_em1 =   exp(reshape(est_em,[max_iter_em NN  1]));
est_bfgs1 = exp(reshape(est_bfgs,[max_iter_bfgs NN 1]));
true = exp(true);

subplot(2,1,1);
plot(1:max_iter_em,-1*(true-est_em1)./true,'-b');
%plot(1:max_iter_em,est_em1,'-b');
ylim([-0.5,0.5]);xlim([1,max_iter_em]);

subplot(2,1,2);
plot(1:max_iter_bfgs,(-1*(true-est_bfgs1)./true),'-b');
%plot(1:max_iter_bfgs,est_bfgs1,'-b');
ylim([-0.5,0.5]);xlim([1,max_iter_bfgs]);

% RMSE over datasets
figure(2); clf;
plot(1:max_iter_em,sqrt(mean((true-est_em1').^2))./true,'-b',...
     1:max_iter_em,sqrt(mean((true-est_bfgs1(1:max_iter_em,:)').^2))./true,'-r');
%ylim([-0.02 0.35]);





%% Export

textwidth = 426.79134/72.27; % latex textwidth in inches
% plot the true locations and the measurements


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% r - convergence %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../data/Ballistic_r_100_1000.mat');
plt = struct();kw=struct();
x = 1:max_iter_em;
y = exp(reshape(est_em,[max_iter_em NN  1]));
kw.alpha = 0.2; kw.linewidth = 0.5;
plt.data = {{x y '-b' kw},{''}};
plt.xlabel = '$\mathrm{iteration}$';
plt.ylabel = '$\mathrm{r}$';
plt.w = textwidth*0.5;
plt.alpha = 0.0;
%pyplot('../img/testplot.mat',plt);
pyplot('../img/ballistic_r_convergence.pdf',plt);







%%


plt = struct();kw=struct();
kw.alpha = 0.9;
plt.data = {{xs(1,:) xs(4,:) '' kw},...
			{ms(1,:) ms(4,:) '' kw},...
			{mF(1,:) mF(4,:) '' kw},...
			{ys(1,yI) ys(2,yI) 'x'},...
			};
plt.xlabel = '$\mathrm{[m]}$';
plt.ylabel = '$\mathrm{[m]}$';
plt.legend = {'true' 'filter' 'smoother' 'measurement'};
plt.legendkw = struct('loc','lower center');
plt.w = textwidth*0.5;
%plotstruct(ax,plt);
pyplot('../img/ex1_pos_meas.pdf',plt);

plt = struct();
fmean = xs(2,:)-ms(2,:);
smean = xs(2,:)-mF(2,:);
ferr = 2*sqrt(squeeze(Ps(2,2,:)));
serr = 2*sqrt(squeeze(PF(2,2,:)));
plt.ylabel = '$\dot{x}_{\mathrm{true}}-\dot{x}_{\mathrm{mean}}\,\mathrm{[m]}$';
plt.xlabel = '$t\,\mathrm{[s]}$';
plt.legend = {'$\mathrm{Err}_f$' '$\mathrm{Err}_s$'};
plt.legendkw = struct('loc','upper right');
plt.data = {{K fmean '' struct('yerr',ferr)},{K smean '' struct('yerr',serr)}};
plt.w = textwidth*0.5;
plotstruct(plt);
pyplot('../img/ex1_err.pdf',plt)

%plt.data = {{K xs(5,:)},{}};
%plt.ylabel = '$\dot{y}$';
%pyplot('../img/ex1_x5.pdf',plt);
%plt.data = {{K xs(6,:)},{}};
%plt.ylabel = '$\ddot{y}$';
%pyplot('../img/ex1_x6.pdf',plt);

break

plt = struct();
plt.x = [ms(1,:)' mF(1,:)'];
plt.y = [ms(4,:)' mF(4,:)'];
plt.xlabel = '$x$';
plt.ylabel = '$y$';
plt.legend = {'filtered' 'smoothed'};
plt.w = 4;

pyplot('../img/test.pdf',plt);
error('stop');

figure;
plot(xs(1,:),xs(4,:),ys(1,yI),ys(2,yI),'xk');
figure;
boundedline(ms(1,:),ms(4,:),[1.97*sqrt(squeeze(Ps(1,1,:))) 1.97*sqrt(squeeze(Ps(4,4,:)))])
figure;
boundedline(mF(1,:),mF(4,:),[1.97*sqrt(squeeze(PF(1,1,:))) 1.97*sqrt(squeeze(PF(4,4,:)))])







