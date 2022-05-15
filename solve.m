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
dt = 0.01;
delta = inputs_list(2,:);
T = inputs_list(1,:);    %not used



%TODO: Write a script that plots the lateral tire characteristic curve. We
%      can ignore the longitudianl tire chracteristic curve in this case, since
%      the longitudinal forces are already given





