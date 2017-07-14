%% Load Cell Calibration Data

clear all
close all
clc

%% Looking at a bunch of .MAT files for load cell calibration

dd = dir('.');
fnames = {};  % store names as cell array
data={};  % store each dataset in a cell array
fcnt = 1;  % counter for .mat files
for ii = 1:length(dd)
    % is it a .MAT file?
    if strfind(dd(ii).name,'.MAT')
        % load the file
        fnames{fcnt}=dd(ii).name;
        data{fcnt}=load(fnames{fcnt});
        fcnt = fcnt+1;
        
    end
    
end

%% Plot
for ii = 1:length(data)
    A = data{ii}.A;
    figure(ii);
    clf();
    subplot(211)
    plot(A(:,1))
    grid on
    xlabel('Counts []')
    ylabel('Ch 1 Voltage Load [V]')
    subplot(212)
    plot(A(:,2))
    xlabel('Counts []')
    ylabel('Ch 2 External Voltage [V]')
    grid on
end

%% Extracts the ch1 and ch2 data

Vratio = [];  % store ratio as an array

tare = data{10}.A; % selects V tare data
mean_tare = mean(tare(:,1)); % mean V tare


for ii = 1:length(data)
    A = data{ii}.A;
    force = fnames{ii}; % force in lbs
    ch1 = mean(A(:,1)); % V load
    ch2 = mean(A(:,2)); % V ext
    Vratio(ii) = (ch1 - mean_tare)/ch2; % mean(Vload)-mean(Vtare)/mean(Vext)
   
end

%% Plot Force vs Vratio data

X_lbs=[0 2.5 5 7.5 10 12.5 15 17.5 20 22.5]; % force in lbs
X=X_lbs*4.44822162825; % convert lbs force to newtons

Y=[Vratio(10) Vratio(7) Vratio(8) Vratio(9) Vratio(1) Vratio(2) Vratio(3)...
    Vratio(4) Vratio(5) Vratio(6)]; % V_load/V_ext 

% Plot
figure(1);
clf();
plot(X,Y,'ro')
xlabel('Force [N]')
ylabel('\DeltaV/V [V load/V ext]')

% Polyfit

[p, S]=polyfit(X,Y,1); % polyfit of line
slope = p(1); % slope of equation
intercept = p(2); % intercept of equation

x1=linspace(0,120);
f1=polyval(p,x1); % line of best fit 

hold on

plot(x1,f1,'b-') % plot line of best fit
legend('load cell data','line of best fit')
text(60,-0.001, sprintf('y = %f * x %f', slope, intercept)); % plot equation of line
grid on
hold off









