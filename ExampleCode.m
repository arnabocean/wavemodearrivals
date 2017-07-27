load('ExampleData.mat');

%%
%   wld contains wavelet decomposition data.
extTestWave = wld(8,:);     %   For extensional mode, we use only the 8th wavelet component.
flexTestWave= wld(3,:).*wld(4,:).*wld(5,:).*wld(6,:).*wld(7,:); %   For flexural mode, we combine several wavelet components.

ArrTimes(1,1) = getExtensionArrival(extTestWave);
ArrTimes(1,2) = getFlexureArrival(flexTestWave);

%%  Plot Signal

figure;
plot(rwd); hold on; grid on;    %   rwd is the raw signal data
ylms = get(gca,'YLim');

plot([ArrTimes(1,1),ArrTimes(1,1)],ylms,'r--','LineWidth',2);
plot([ArrTimes(1,2),ArrTimes(1,2)],ylms,'b:','LineWidth',2);

title('Arrival of extensional and flexural wave modes.');
xlabel('Time index');
ylabel('Signal amplitude (V)');

legend('Signal','Extensional','Flexural');

%%  Plot Flexural Test Waveform

figure;
plot(flexTestWave); hold on; grid on;
ylms = get(gca,'YLim');

plot([ArrTimes(1,1),ArrTimes(1,1)],ylms,'r--','LineWidth',2);
plot([ArrTimes(1,2),ArrTimes(1,2)],ylms,'b:','LineWidth',2);

title('Flexural Test Wave (flexTestWave) and calculated wave mode arrivals');
xlabel('Time index');
ylabel('Signal amplitude (V)');

legend('flexTestWave','Extensional','Flexural');

%%  Plot Extensional Wave Form

figure;
plot(extTestWave); hold on; grid on;
ylms = get(gca,'YLim');

plot([ArrTimes(1,1),ArrTimes(1,1)],ylms,'r--','LineWidth',2);
plot([ArrTimes(1,2),ArrTimes(1,2)],ylms,'b:','LineWidth',2);

title('Extensional Test Wave (extTestWave) and calculated wave mode arrivals');
xlabel('Time index');
ylabel('Signal amplitude (V)');

legend('flexTestWave','Extensional','Flexural');

