clc,clear,close all


%% read file in same folder
% Define the folder containing the files
% folder = 'C:\Users\wangc25\Desktop\Dr.Liu\data\20240606_longer data\CRH-mouse\Pinprick'; % Change this to your folder path
% labelfolder='C:\Users\wangc25\Desktop\Dr.Liu\data\20240606_longer data\CRH-label\Pinprick';

%  Prompt the user to specify the file name and folder
folder = uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select fluorescent dynamic folder');
if   ischar(folder)
    filePattern = fullfile(folder, '*.mat'); % Change the extension to match your files
    files = dir(filePattern);
else
    disp('File slecting canceled.');
end


%  Prompt the user to specify the file name and folder
labelfolder= uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select label folder');
if ischar(labelfolder)
    labelfilePattern= fullfile(labelfolder, '*.mat');
    labelfiles=dir(labelfilePattern);
else
    disp('File slecting canceled.');
end



% Get a list of all files in the folder with the desired file name pattern

% Number of shuffles
num_shuffles = 100;
%%
fs = 40; % Sample rate in Hz (adjust as needed)
windowSize = 40* fs; % 20 second running window
windowTime=[-windowSize/2+1:windowSize/2]/fs;

% Loop over all files
for k = 1:length(files)
    % Get the full file name
    baseFileName = files(k).name;
    fullFileName = fullfile(files(k).folder, baseFileName);

    labelFileName = labelfiles(k).name;
    labelFullFileName = fullfile(labelfiles(k).folder, labelFileName);

    % Read the data from the file
    data=load(fullFileName);
    label=load(labelFullFileName);

    time=data.times;
    dataValues=data.data;
    stiStartIndex=find(label.label_data(:,2),1);
    %stiStartIndex=max(find(label.pulse_data(:,2)));

    unshuffled_result(k,:)=dataValues(stiStartIndex-windowSize/2+1:stiStartIndex+windowSize/2)';

    %% shuffle
    % Pre-allocate shuffled data array
    shuffled_data_all = zeros(num_shuffles, windowSize);
    for i = 1:num_shuffles
        % randIndex=randi([1+windowSize/2,length(dataValues)-windowSize/2]);
        % shuffled_data(i, :) = dataValues(randIndex-windowSize/2+1:randIndex+windowSize/2)';
        randIndex=randi([1,length(dataValues)]);
        shuffled_dataValues = circshift(dataValues,stiStartIndex-randIndex);
        shuffled_data_all(i, :) = shuffled_dataValues(stiStartIndex-windowSize/2+1:stiStartIndex+windowSize/2)';
    end
    shuffled_result(k,:) = mean(shuffled_data_all);


end




% Calculate mean and standard deviation
unshuffled_mean = mean(unshuffled_result);
unshuffled_std = std(unshuffled_result)/sqrt(length(files));

shuffled_mean = mean(shuffled_result);
shuffled_std = std(shuffled_result)/sqrt(length(files));

% Create vectors for the shaded area
unshuffled_upper_bound = unshuffled_mean + unshuffled_std ;
unshuffled_lower_bound = unshuffled_mean  - unshuffled_std ;

shuffled_upper_bound = shuffled_mean + shuffled_std ;
shuffled_lower_bound = shuffled_mean  - shuffled_std ;


figure;
hold on
% Plot the shaded area (standard deviation)
fill([windowTime, fliplr(windowTime)], ...
    [unshuffled_upper_bound, fliplr(unshuffled_lower_bound)], ...
    'black', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(windowTime, unshuffled_mean, 'black', 'LineWidth', 2);
% Plot the shaded area (standard deviation)
fill([windowTime, fliplr(windowTime)], ...
    [shuffled_upper_bound, fliplr(shuffled_lower_bound)], ...
    'blue', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(windowTime, shuffled_mean, 'blue', 'LineWidth', 2);
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','data' ,'','shuffled');
axe1=gca;
axe1.YLim=[-1,3];
set(axe1,'TickDir','out');
exportgraphics(axe1,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-pinprick.tif','Resolution',600)
grid off
hold off;

figure;
hold on
% Plot the shaded area (standard deviation)
fill([windowTime, fliplr(windowTime)], ...
    [shuffled_upper_bound, fliplr(shuffled_lower_bound)], ...
    'blue', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(windowTime, shuffled_mean, 'blue', 'LineWidth', 2);
plot(windowTime,shuffled_result');
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','shuffled');
axe2=gca;
axe2.YLim=[-1,3];
set(axe2,'TickDir','out');
exportgraphics(axe2,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-pinprick-shuffled only.tif','Resolution',600)
grid off
hold off;

figure;
hold on
% Plot the shaded area (standard deviation)
fill([windowTime, fliplr(windowTime)], ...
    [unshuffled_upper_bound, fliplr(unshuffled_lower_bound)], ...
    'black', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(windowTime, unshuffled_mean, 'black', 'LineWidth', 2);
plot(windowTime,unshuffled_result')
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','data' );
axe3=gca;
axe3.YLim=[-1,3];
set(axe3,'TickDir','out');
exportgraphics(axe3,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-pinprick-data only.tif','Resolution',600)
grid off
hold off;

%% statistic check

[p,h,stats] = ranksum(unshuffled_mean,shuffled_mean);



