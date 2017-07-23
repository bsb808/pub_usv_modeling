clear all
close all
clc
     
%% Open rosbag
filePath = fullfile('2017-03-10-13-03-49.bag');
bag = rosbag(filePath);

%% Evaluate Available Topics
bag.AvailableTopics

% Extract message data
bagOdom = select(bag,'Topic','/nav_odom'); %Odom data
bagCmd = select(bag,'Topic','/cmd_drive');

%% Convert to Timeseries
[ts_odomv,cols_odomv]=timeseries(bagOdom,'Twist.Twist.Linear.X','Twist.Twist.Linear.Y');
[ts_cmd,cols_cmd]=timeseries(bagCmd,'Left','Right');

%% Plot to verify
figure(1)
clf()
plot(ts_odomv.Time,ts_odomv.Data,'.')
legend(cols_odomv)

figure(2)
clf()
ploft = fittype( @(m,vss,k,x) vss*tanh(vss*k/m*x),...
    'problem',{'vss','k'},...
    'independent',{'x'})
[f0,gof,output] = fit(ttt,vvv,ft,'problem',{vss,k})t(ts_cmd.Time,ts_cmd.Data,'.')
legend(cols_cmd)


%% Save timeseries as .mat file so we don't have to reprocess each time
matfile = [filePath '.mat'];
save(matfile,'ts_odomv','cols_odomv','ts_cmd','cols_cmd')

