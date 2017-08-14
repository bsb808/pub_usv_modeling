clear all
close all
clc
     
%% Open rosbag
filePath = fullfile('2017-03-10-12-32-18.bag');

bag = rosbag(filePath);

%% Evaluate Available Topics
bag.AvailableTopics;

% Extract message data
bagIMU = select(bag,'Topic','/imu/data'); %IMU data

%% IMU Time Series Data

tsIMU = timeseries(bagIMU, 'AngularVelocity.Z');  

ang_vel = tsIMU.Data;
time = tsIMU.Time;

%% Evaluate Selected Time and Velocity Data

time_sel = time(43674:45301);
angvel_sel = ang_vel(43674:45301);
plot_time = time_sel-time_sel(1);

%% Plot of Angular Velocity
figure(1);
clf();
plot(time, ang_vel)

legend('Angular Velocity', 'Location', 'northeast');
xlabel('Time [s]');
ylabel('Angular Velocity [rad/s]')
grid on

hold off

