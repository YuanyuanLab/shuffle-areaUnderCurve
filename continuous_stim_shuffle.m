clc,clear,close all

%% read file in same folder
% Define the folder containing the files
% folder = 'C:\Users\wangc25\Desktop\Dr.Liu\data\20240606_longer data\CRH-mouse\Pinprick'; % Change this to your folder path
% labelfolder='C:\Users\wangc25\Desktop\Dr.Liu\data\20240606_longer data\CRH-label\Pinprick'

%  Prompt the user to specify the file name and folder
folder = uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select fluorescent dynamic folder');
if   ischar(folder)
    filePattern = fullfile(folder, '*.mat'); % Change the extension to match your files
    files = dir(filePattern);
else
    disp('File slecting canceled.');
end


%  Prompt the user to specify the file name and folder
labelfolder= uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select fluorescent dynamic folder');
if ischar(labelfolder)
    labelfilePattern= fullfile(labelfolder, '*.mat');
    labelfiles=dir(labelfilePattern);
else
    disp('File slecting canceled.');
end



% Get a list of all files in the folder with the desired file name pattern


% Number of shuffles
num_shuffles = 100;
% unshuffled_result=zeros(length(files),length(datavalues));
% shuffled_result=zeros(length(files),length(datavalues));
% Loop over all files

for k = 1:length(files)
    % Get the full file name
    baseFileName = files(k).name;
    fullFileName = fullfile(files(k).folder, baseFileName);

    labelFileName = labelfiles(k).name;
    labelFullFileName = fullfile(labelfiles(k).folder, labelFileName);

    % Read the data from the file
    data=load(fullFileName);
    label=load( labelFullFileName);

   
    dataValues=data.data;
    stiTime=label.label_data(:,2);
    %time=data.times;
   % time=(label.label_data(:,1)-label.label_data(find(label.label_data(:,2)-25,1),1))';%for hotplate
    time=(label.label_data(:,1)-label.label_data(find(label.label_data(:,2),1),1))';
    


    if k==3 && ~isempty(strfind(folder, 'WT-mouse\Pinch'))
        stiTime=stiTime(1:3910,1);
    end

    %stiTime=(stiTime-25)/30; %normalization
   
    unshuffled_result(k,1:length(dataValues))=dataValues;

    % calculate the cross-correlation
    [r lags]=xcorr(dataValues,stiTime,'normalized');
    % figure,
    % plot(lags,r)
    unshuffled_r=r(lags==0);


    %% shuffle
    shuffled_r=zeros(1);
    shuffled_dataValues_all=zeros(length(dataValues),num_shuffles);
    % circling shuffle
    for j = 1:num_shuffles
        shuffled_dataValues = circshift(dataValues,randi([1 length(stiTime)]));
        shuffled_dataValues_all(:,j)=shuffled_dataValues;

        [r lags]=xcorr(shuffled_dataValues,stiTime,'normalized');
  
        shuffled_r=r(lags==0)+shuffled_r;

    end
    shuffled_r=shuffled_r/num_shuffles;

    shuffled_dataValues_mean=mean(shuffled_dataValues_all,2);
    [r lags]=xcorr(shuffled_dataValues_mean,stiTime,'normalized');
    % figure,
    % plot(lags,r)
    shuffled_r_meanFirst=r(lags==0);

    shuffled_result(k,1:length(shuffled_dataValues_mean))=shuffled_dataValues_mean;


    result(k,:)=[unshuffled_r shuffled_r shuffled_r_meanFirst];

end


figure()
plot(time,dataValues)
hold on
plot(time,stiTime,'r')
%plot(time,shuffled_stiTime,'g')
plot(time,shuffled_dataValues_mean,'g')
hold off



figure()
boxplot(result(:,1:2),'Labels',{'data','shuffled'});
ylabel('correlation coefficient');
set(gca,'TickDir','out');
hold on
% Plot scatter points with colors
for i = 1:2
    scatter(repmat(i, length(result(:,1:2)), 1), result(:, i), 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'none',   'jitter', 'on', 'jitterAmount', 0.15);
end

% text(1.5, 0.95, 'p < 0.05', 'HorizontalAlignment', 'center')
% % Coordinates for the brackets
% x1 = [1, 1, 2, 2];
% y1 = [0.95, 0.97, 0.97, 0.95];
% % Plot the brackets
% plot(x1, y1, 'k')


axe=gca;
axe.YLim=[-0.4,1]; %for hot plate [-0.1,1] 
hold off
exportgraphics(gca,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-Pinch-correlation.tif','Resolution',600)


% Calculate mean and standard deviation
unshuffled_mean = mean(unshuffled_result);
unshuffled_std = std(unshuffled_result)/sqrt(5);

shuffled_mean = mean(shuffled_result);
shuffled_std = std(shuffled_result)/sqrt(5);

% Create vectors for the shaded area
unshuffled_upper_bound = unshuffled_mean + unshuffled_std ;
unshuffled_lower_bound = unshuffled_mean  - unshuffled_std ;

shuffled_upper_bound = shuffled_mean + shuffled_std ;
shuffled_lower_bound = shuffled_mean  - shuffled_std ;


figure;
hold on
% Plot the shaded area (standard deviation)
fill([time, fliplr(time)], ...
    [unshuffled_upper_bound, fliplr(unshuffled_lower_bound)], ...
    'black', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(time, unshuffled_mean, 'black', 'LineWidth', 2);
% Plot the shaded area (standard deviation)
fill([time, fliplr(time)], ...
    [shuffled_upper_bound, fliplr(shuffled_lower_bound)], ...
    'blue', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(time, shuffled_mean, 'blue', 'LineWidth', 2);
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','data' ,'','shuffled');
axe1=gca;
axe1.YLim=[-2,3];
set(axe1,'TickDir','out');
exportgraphics(axe1,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-Pinch.tif','Resolution',600)
grid off
hold off;

figure;
hold on
% Plot the shaded area (standard deviation)
fill([time, fliplr(time)], ...
    [shuffled_upper_bound, fliplr(shuffled_lower_bound)], ...
    'blue', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(time, shuffled_mean, 'blue', 'LineWidth', 2);
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','shuffled');
axe2=gca;
axe2.YLim=[-2,3];
set(axe2,'TickDir','out');
exportgraphics(axe2,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-Pinch-shuffled only.tif','Resolution',600)
grid off
hold off;

figure;
hold on
% Plot the shaded area (standard deviation)
fill([time, fliplr(time)], ...
    [unshuffled_upper_bound, fliplr(unshuffled_lower_bound)], ...
    'black', 'EdgeColor', 'none','FaceAlpha',0.5);
% Plot the mean value as a solid line
plot(time, unshuffled_mean, 'black', 'LineWidth', 2);
%title('Mean and Standard Deviation of Time Series Data');
xlabel('Time from stimulation (s)');
ylabel('\DeltaF/F (%)');
legend('','data' );
axe3=gca;
axe3.YLim=[-2,3];
set(axe3,'TickDir','out');
exportgraphics(axe3,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-Pinch-data only.tif','Resolution',600)
grid off
hold off;




% Add legend and labels
%legend show;

[p,h,stats] = ranksum(result(:,1),result(:,2));

%[p,h,stats] = ranksum(shuffled_mean,unshuffled_mean);
