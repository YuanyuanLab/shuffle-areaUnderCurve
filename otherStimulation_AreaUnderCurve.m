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





%  Prompt the user to specify the file name and folder
WTfolder = uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select fluorescent dynamic folder');
if   ischar(WTfolder)
    WTfilePattern = fullfile(WTfolder, '*.mat'); % Change the extension to match your files
    WTfiles = dir(WTfilePattern);
else
    disp('File slecting canceled.');
end


%  Prompt the user to specify the file name and folder
WTlabelfolder= uigetdir('C:\Users\wangc25\Desktop\Dr.Liu\data','Select fluorescent dynamic folder');
if ischar(WTlabelfolder)
    WTlabelfilePattern= fullfile(WTlabelfolder, '*.mat');
    WTlabelfiles=dir(WTlabelfilePattern);
else
    disp('File slecting canceled.');
end



fs = 40; % Sample rate in Hz (adjust as needed)
timeAreaUnderCurve = 10* fs;
%timeAreaUnderCurve = 450* fs; for hot plate


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


    WTbaseFileName = WTfiles(k).name;
    WTfullFileName = fullfile(WTfiles(k).folder, WTbaseFileName);

    WTlabelFileName = WTlabelfiles(k).name;
    WTlabelFullFileName = fullfile(WTlabelfiles(k).folder, WTlabelFileName);

    % Read the data from the file
    WTdata=load(WTfullFileName);
    WTlabel=load( WTlabelFullFileName);


    time=data.times;
    dataValues=data.data;
    WTtime=WTdata.times;
    WTdataValues=WTdata.data;
        stiTime=label.label_data(:,2);
    WTstiTime=WTlabel.label_data(:,2);



    if k==3 && ~isempty(strfind(folder, 'WT-mouse\Pinch'))
        WTstiTime=WTstiTime(1:3910,1);
    end



    %% for pinch
     dataValuesArea=trapz(dataValues(stiTime>0));
    WTdataValuesArea=trapz(WTdataValues(WTstiTime>0));

    %% for other stimulation
    % dataValuesArea=trapz(dataValues(find(stiTime,1):find(stiTime,1)+timeAreaUnderCurve-1));
    % WTdataValuesArea=trapz(WTdataValues(find(WTstiTime,1):find(WTstiTime,1)+timeAreaUnderCurve-1));





    areaResult(k,:)=[dataValuesArea WTdataValuesArea];



end

[p1,h,stats] = ranksum(areaResult(:,1),areaResult(:,2));



figure()
boxplot(areaResult(:,:),'Labels',{'CRH','WT'});
ylabel('Average area under curve');
set(gca,'TickDir','out');
hold on

text(1.5, 1.8, 'p < 0.05', 'HorizontalAlignment', 'center')
% Coordinates for the brackets
x1 = [1, 1, 2, 2];
y1 = [1.85, 1.9, 1.9, 1.85];
% Plot the brackets
plot(x1, y1, 'k')
set(gca,'YLim',[-0.2 2])


% text(2.5, 6, 'p < 0.05', 'HorizontalAlignment', 'center')
% % Coordinates for the brackets
% x1 = [2, 2, 3, 3];
% y1 = [5.8, 6, 6, 5.8];
% % Plot the brackets
% plot(x1, y1, 'k')

for i = 1:2
    scatter(repmat(i, length(areaResult), 1), areaResult(:, i), 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'none',   'jitter', 'on', 'jitterAmount', 0.15);
end

hold off
%set(gca,'YLim',[-0.3 5.8])
%exportgraphics(gca,'C:\Users\wangc25\Desktop\Dr.Liu\result\WT-Hot plate-area under curve.tif','Resolution',600)




figure()
boxplot(areaResult(:,:),'Labels',{'CRH','WT'},'Widths',0.7,'Symbol',''); %make the outlier invisible
ylabel('area under curve');
set(gca,'TickDir','out');
set(findobj(gca,'type','line'),'linew',2,'color','black')
% Change the median line color to red
h = findobj(gca, 'Tag', 'Median');
for j = 1:length(h)
    h(j).LineWidth = 2;
    h(j).Color = 'red';
end

pbaspect([1 1.8 3]);
hold on
% text(1.5, 6, 'p < 0.05', 'HorizontalAlignment', 'center')
% % Coordinates for the brackets
% x1 = [1, 1, 2, 2];
% y1 = [5.8, 6, 6, 5.8];
% % Plot the brackets
% plot(x1, y1, 'k')
% text(2.5, 6, 'p < 0.05', 'HorizontalAlignment', 'center')
% % Coordinates for the brackets
% x1 = [2, 2, 3, 3];
% y1 = [5.8, 6, 6, 5.8];
% % Plot the brackets
% plot(x1, y1, 'k')

% Plot scatter points with colors
for i = 1:2
    scatter(repmat(i, length(areaResult), 1), areaResult(:, i),80, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'none',   'jitter', 'off', 'jitterAmount', 0.15,'LineWidth',2);
end
hold off
%set(gca,'YLim',[-100 800])
set(gca,'XLim',[0.3 2.7])
set(gca,'linewidth',2)
exportgraphics(gca,'C:\Users\wangc25\Desktop\Dr.Liu\result\2-5-1.WT-Hot plate-area under curve.tif','Resolution',600)





