%Radar Lab 1
%% Loading the data
load("./dataset-20/dataset-20/HH_20170206140314_5.mat");
%load("./dataset-20/dataset-20/NoiseFile.mat");

%% Plot the original data
%Save the image here
img = "original"; 

%Title of the image
title_str='Range Slow-time response(Noise)';

%Time scale
time_ind=0e4:0.5e4:3e4;

%Figure Spec
hfig=figure;
imagesc(time_ind,range,db(abs(Data_out')))
colorbar;
set(gca,'ydir','norm')
xlabel('Slow time, ms')
ylabel('Range, m')
title(['{',title_str,'}']);
print(hfig,'-dpng',img);

%% Doppler Processing
%Doppler samples
N_Doppler=512;
J=1;

%start time
start_time=1+N_Doppler*(J-1);
title_str='Range Doppler Plot';
%x=Data_out(start_time:start_time+N_Doppler-1,:);
%PRI
PRI=1;
x=Data_out(start_time:PRI:start_time+PRI*N_Doppler-1,:);
RD=fftshift(fft(x, N_Doppler),1);
frequency=-500:1000/(N_Doppler*PRI+1):500;
% how this has to be changed for diff PRF?
hfig=figure;
imagesc(frequency,range,db(abs(RD')))
colorbar
set(gca,'ydir','norm')
%set(gca,'clim',[10,70])
% If you do not see the range-Doppler plane similar to slide 10, % comment (or edit) the codeline set(gca,'clim',[10,70])
xlabel('Doppler frequency, ms')
ylabel('Range, m')
title(['{',title_str,' ',num2str(PRI), 'ms, burst ',num2str(J),'}'])

%% Making video of the data
imgDir_video1='N:\MASTERS\Quarter 3\Microwave and radar systems and sensing\Matlab\Radar Lab 1\';
%imgDir_video1='dataset-02';
name='N_doppler32';
%video_file=VideoReader('HH_20170206135256_fr30_2.mp4');
video_file=[imgDir_video1,name,'.avi'];
writerObj = VideoWriter(video_file);
open(writerObj);
% PRI=2e-3;
for k=1:59
    PRI=1;
    N_Doppler=64;
    start_time=1+N_Doppler*(k-1);
    x=Data_out(start_time:PRI:start_time+PRI*N_Doppler-1,:);
    % PRI=2;
    %x=Data_out(start_time:PRI:start_time+PRI*N_Doppler-1,:);
    RD=fftshift(fft(x, N_Doppler),1);
    frequency=-500:1000/(N_Doppler*PRI+1):500;
    % % how this has to be changed for diff PRF?
    hfig=figure;
    imagesc(frequency,range,db(abs(RD')))
    colorbar
    set(gca,'ydir','norm')
    % %set(gca,'clim',[10,70])
    % % If you do not see the range-Doppler plane similar to slide 10, % comment (or edit) the codeline set(gca,'clim',[10,70])
    xlabel('Doppler frequency, ms')
    ylabel('Range, m')
    title(['{',title_str,' ',num2str(PRI), 'ms, burst ',num2str(J),'}']);
    % % how this has to be changed for diff PRF?
    %imagesc(frequency,range,db(abs(RD')))
    frame = getframe(hfig);
    writeVideo(writerObj,frame);
    %close all
end
close(writerObj);

%% MTI 

N_Doppler=512;
J=1;
start_time=1+N_Doppler*(J-1);
PRI=2;
time_req = 1:PRI:start_time+PRI*N_Doppler-1;
x=Data_out(1:PRI:start_time+PRI*N_Doppler-1,:);
%x=Data_out(1:PRI:end,:);

%Plotting MTI

%hfig=figure;
figure();
imagesc(time_req,range,db(abs(x')))
colorbar;
set(gca,'ydir','norm')
xlabel('Slow time, ms')
ylabel('Range, m')
title(['{',title_str,' ',num2str(PRI), 'ms, burst ',num2str(J),'}'])
%print(hfig,'-dpng',img);
%frequency=-500:100:500;
%Converting the data in frequency domain

% [B, A] = butter(2, 0.5, 'high');
% filtered = transpose(filtfilt(B, A, transpose(x)));

nFFT = N_Doppler;
% %FFT_Data = fftshift(fft(x, N),1);
%FFT_Data = fft(filtered, N_Doppler);
FFT_Data = fft(x, N_Doppler);

[B, A] = butter(2, 0.5, 'high');
filtered = transpose(filtfilt(B, A, transpose(FFT_Data)));

%RD=fftshift(FFT_Data,1);
% FFT_Data(:, 1) = 0;
% %Removing the first column of the data
%RD(size(FFT_Data, 1)/2-20:1:size(FFT_Data, 1)/2+20,:) = [];
% 
% %Converting back to time domain
TimeDomain = ifft(filtered);

figure();
imagesc(frequency,range,db(abs(filtered')))
colorbar;
set(gca,'ydir','norm')
xlabel('Slow Time, ms')
ylabel('Range, m')
title(['{',title_str,' ',num2str(PRI), 'ms, burst ',num2str(J),'}'])