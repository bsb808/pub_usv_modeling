%% Kingfisher Thrust Calibration Using Load Cell Calibration Data

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

%% Extracts the ch1 load and ch2 ext voltage data and calculates thrust

thrust_N = [];  % store thrust as an array

tare = data{20}.A; % selects V tare data
ch1_tare = mean(tare(:,1)); % mean ch1 V tare data
K = -2.2176e-05; % slope from load cell cal plot (vratio_force_plot.m). Units (Vload)/(Vext*N)


tht = [];
cnt = 1;
meanF = [];
stdF = [];

for ii = 1:length(data)
    A = data{ii}.A;
    force = fnames{ii}; % force in lbs
    ch1 = (A(:,1)); % V load
    ch2 = mean(A(:,2)); % mean V ext
    thrust_N = (ch1-ch1_tare)/(K*ch2); % thrust of kingfisher in newtons (N)
    
    % plot of thrust data 
    figure(ii);
    clf();
    
    mu = mean(thrust_N);
    stdev= std(thrust_N);
         
    plot(thrust_N)
    
    % plot mean thrust
    muline = refline([0 mu]);
    muline.Color = 'r';
    
    % plot standard deviation
    stplus = refline([0 (mu+stdev)]);
    stplus.Color = 'r';
    stplus.LineStyle = '--';
    
    stneg = refline([0 (mu-stdev)]);
    stneg.Color = 'r';
    stneg.LineStyle = '--';
    
    
    ylabel('Force [N]')
    xlabel('Sample []')
    legend('thrust [N]', sprintf('Mean: %.2f [N]', mu), sprintf('Stdev: %.3f [N]',stdev)); 
    grid on
    
    % Get thrust command value from -1 to 1 in increments of 0.1
    if ~isempty(strfind(fnames{ii},'F.'))
        th = sscanf(fnames{ii},'kingfisher_%dF.MAT');
        stdF(cnt) = std(thrust_N);
        meanF(cnt) = mean(thrust_N);
        tht(cnt)=th*0.01;
        cnt = cnt+1;
    elseif ~isempty(strfind(fnames{ii},'A.'))
        th = sscanf(fnames{ii},'kingfisher_%dA.MAT');
        th = -1*th;
        tht(cnt)=th*0.01;
        meanF(cnt) = -1*mean(thrust_N);
        stdF(cnt) = std(thrust_N);
        cnt = cnt+1;
    end
    
    tht(20) = 0;
    tht(21) = -0.1;
    meanF(20) = 0;
    meanF(21) = 0;
    stdF(20) = 0;
    stdF(21) = 0;
end

%% Plot mean thrust and thrust command value
figure()
clf()

err = errorbar(tht, meanF, stdF, 'bo');
err.MarkerSize = 2;

xlabel('Thrust Command [-1 to 1]')
ylabel('Thrust from Two Thrusters [N]')

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis([-1.05 1.05 -20 50])

hold on

[p, S]=polyfit(tht,meanF,9); % polyfit of line

% line of best fit from -1 to 1
x1=linspace(-1,1);
f1=polyval(p,x1);

plot(x1,f1,'r-') % plot line of best fit
legend('thrust data with error bars','line of best fit', 'Location', 'southeast')
grid on

hold off