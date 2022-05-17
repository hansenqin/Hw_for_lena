load data.mat
% Data desription:
% - states_list contains the time series of the states
% - inputs_list contains the time series of the inputs
% - F_xfw_list contains the time series of the front tire
%   longitudinal force
% - F_xr_list contains the time series of the rear tire
%   longitudinal force
x = states_list(1,1:end-1); % x position
y = states_list(2,1:end-1); % y_position
h = states_list(3,1:end-1); % h_position
u = states_list(4,1:end-1);
v = states_list(5,1:end-1);
r = states_list(6,1:end-1);
w = states_list(7,1:end-1); %not used
m=1400;
Izz=2667;
lf=1.4;
lr=1.4;
rw=0.5;
J = 100;
g = 9.81;
dt = 0.01;
delta = inputs_list(2,:);
T = inputs_list(1,:);    %not used
%TODO: Write a script that plots the lateral tire characteristic curve. We
%      can ignore the longitudianl tire chracteristic curve in this case, since
%      the longitudinal forces are already given
% ignore last element. Part 2: use classes
vdot = [];
for k=1:1:1099
    newvdot = (v(k+1)-v(k))/dt;
    vdot = [vdot newvdot];
end
rdot = [];
for k=1:1:1099
    newrdot = (r(k+1)-r(k))/dt;
    rdot = [rdot newrdot];
end
% Adjust size of other vectors
F_xr = F_xr_list(1:end-1);
F_xfw = F_xfw_list(1:end-1);
x = x(1:end-1);
y = y(1:end-1);
h = h(1:end-1);
u = u(1:end-1);
v = v(1:end-1);
r = r(1:end-1);
delta=delta(1:end-1);
% Find vf and vr
v_f = v+lf.*r;
v_r = v-lr.*r;
% Rotate
u_wf = u.*cos(-delta)-v_f.*sin(-delta);
v_wf = u.*sin(-delta)+v_f.*cos(-delta);
u_wr = u;
v_wr = v_r;
% Find slip angles
alphaf = atan(v_wf./sqrt((u_wf).^2 +0.05));
alphar = atan(v_wr./sqrt((u_wr).^2 +0.05));
% Find lateral forces
F_ywf=(lr.*m.*(vdot+u.*r)+rdot*Izz-(lf+lr)*sin(delta).*F_xfw)./((lf+lr).*cos(delta));
F_yr=(m*(vdot+u.*r)-rdot*Izz/lf)./(1+lr/lf);
% Plot the data
figure(1);
hold on;
scatter(alphaf, F_ywf);
title('Front');
xlabel('Slip Angle');
ylabel('F_y');
figure(2);
hold on;
scatter(alphar, F_yr);
title('Rear')
xlabel('Slip Angle');
ylabel('F_y');
% Sort the data
[alphafSorted, If] = sort(alphaf);
F_ywfSorted = F_ywf(If);
[alpharSorted, Ir] = sort(alphar);
F_yrSorted = F_yr(Ir);
% Only take half of the data for analysis
alphaf1 = alphafSorted(1:2:end);
alphaf2 = alphafSorted(2:2:end);
F_ywf1 = F_ywfSorted(1:2:end);
F_ywf2 = F_ywfSorted(2:2:end);
alphar1 = alpharSorted(1:2:end);
alphar2 = alpharSorted(2:2:end);
F_yr1 = F_yrSorted(1:2:end);
F_yr2 = F_yrSorted(2:2:end);
% Select and fit a curve to the data in the linear region for the front 
alphafSelected = alphaf1(abs(alphaf1)<0.1);
F_ywfSelected = F_ywf1(abs(alphaf1)<0.1);
fLinearCoef = polyfit(alphafSelected, F_ywfSelected, 1);
fLinear = @(t) fLinearCoef(1)*t+fLinearCoef(2);
figure(1);
t = -0.5:0.01:0.5;
plot(t, fLinear(t));
xlim([-2,2]);
ylim([-6000, 6000]);
% Select and fit a curve to the data in the linear region for the rear
alpharSelected = alphar1(abs(alphar1)<0.1);
F_yrSelected = F_yr1(abs(alphar1)<0.1);
rLinearCoef = polyfit(alpharSelected, F_yrSelected, 1);
rLinear = @(t) rLinearCoef(1)*t+rLinearCoef(2);
figure(2);
t = -0.5:0.01:0.5;
plot(t, rLinear(t));
xlim([-2,2]);
ylim([-6000, 6000]);
% Nonlinear curve for the front
% F = C1tanh(C2*alpha)
% x = [C1 C2 alpha]
Nonlinear = @(x,xdata)x(1)*tanh(x(2)*xdata);
x0 = [1 1];
[fNonlinearCoef,resnorm,~,exitflag,output]=lsqcurvefit(Nonlinear, x0, alphaf1, F_ywf1);
fNonLinearCurve = @(x) fNonlinearCoef(1)*tanh(fNonlinearCoef(2)*x);
figure(1);
t=-2:0.01:2;
plot(t, fNonLinearCurve(t));
legend('Data', 'Linear','Nonlinear');
% Nonlinear curve for the rear
[rNonlinearCoef,resnorm,~,exitflag,output]=lsqcurvefit(Nonlinear, x0, alphar1, F_yr1);
rNonLinearCurve = @(x) rNonlinearCoef(1)*tanh(rNonlinearCoef(2)*x);
figure(2);
t=-2:0.01:2;
plot(t, rNonLinearCurve(t));
legend('Data','Linear','Nonlinear');
