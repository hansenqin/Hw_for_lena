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
F_ywf=(lr.*m.*(vdot+u.*r)+rdot*Izz-(lf+lr)*sin(delta).*F_xfw)./((lf+lr).*cos(delta));
F_yr=(m*(vdot+u.*r)-rdot*Izz/lf)./(1+lr/lf);
figure(1);
hold on;
scatter(alphaf, F_ywf);
title('Front');
xlabel('Slip Angle');
ylabel('F_y');
hold off;
hold on;
figure(2);
scatter(alphar, F_yr);
title('Rear')
xlabel('Slip Angle');
ylabel('F_y');
hold off;