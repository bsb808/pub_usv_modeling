%% Load mat data
load('dynamic_yaw_test_data.mat')

%% Look at all data
figure(1)
clf()
plot(time,ang_vel)
hold on
plot(ts_cmd.Time-ts_odomv.Time(1),ts_cmd.Data,'o')
legend([cols_odomv;cols_cmd])

%% combine x/y velocities
vv = sqrt(ts_odomv.Data(:,1).^2+ts_odomv.Data(:,2).^2);
tt = ts_odomv.Time()-ts_odomv.Time(1);

figure(2)
clf()
plot(tt,vv,'.')
hold on
plot(ts_cmd.Time-ts_odomv.Time(1),ts_cmd.Data,'o')
legend([{'vel'};cols_cmd])


%% Select a single experiment using time
t0 = 272.5;  % start time 
tf = 299.0;  % end time

% Array of start times
T0 = [178.9, 272.5, 403.0, 514.5];
    
TF = [215.0, 299.0, 425.0, 530.0];

for ii = 1:length(T0)
    t0 = T0(ii);
    tf = TF(ii);
    I = find(tt>=t0,1,'first')
    J = find(tt<=tf,1,'last')

    ttt = tt(I:J)-tt(I);
    vvv = vv(I:J);
    figure(3)
    clf()
    plot(ttt,vvv,'.')
    xlabel('Time [s]');
    ylabel('Velocity [m/s]')

    %% Fit
    % Spacify value for drag
    k = 16.91; % quadratic drag term for surge from Nick

    % ft = fittype( @(m,vss,k,x) vss*tanh(vss*k/m*x),...
    %     'problem',{'vss','k'},...
    %     'independent',{'x'})
    % [f0,gof,output] = fit(ttt,vvv,ft,'problem',{vss,k})
    %fo = fitoptions('Method','NonlinearLeastSquares',...
    %    'StartPoint',[10,1]);
    ft = fittype( @(m,vss,k,x) vss*tanh(vss*k/m*x),...
        'problem',{'k'},...
        'independent',{'x'})
    [f0,gof,output] = fit(ttt,vvv,ft,'problem',{k})
    c = confint(f0);

    vhat = feval(f0,ttt);
    figure(3)
    hold on
    plot(ttt,vhat,'r-')
    legend('Data',sprintf('Fit: k=%.2f N/(m/s)^2',k),'location','southeast')
    title(sprintf('V_{ss} = %.2f [%.2f,%.2f] m/s; m = %.2f [%.2f, %.2f] kg',...
        f0.vss,c(1,2),c(2,2),f0.m,c(1,1),c(2,1)))

    % Print figure to file
    exfig(150,sprintf('fit_%d.png',ii));
    pause
end



