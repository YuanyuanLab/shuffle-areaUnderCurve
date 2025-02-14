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

%% check the original data
% figure()
% hold on
% for k=1:length(files)
%         baseFileName = files(k).name;
%     fullFileName = fullfile(files(k).folder, baseFileName);
%     data=load(fullFileName);
%         labelFileName = labelfiles(k).name;
%     labelFullFileName = fullfile(labelfiles(k).folder, labelFileName);
%      label=load( labelFullFileName);
%
% plot(data.times,data.data)
% end
% plot(data.times,label.label_data(:,2))
% hold off


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

    time=data.times;
    dataValues=data.data;
    stiTime=label.label_data(:,2);
    stiTimeOver45=(stiTime>=45)&(time'<=time(stiTime==55));
    stiTimeUnder45=(stiTime<45)&(stiTime>25)&(time'<=time(stiTime==55));
    stiTimeEqual25=(stiTime==25)&(time'<=time(stiTime==55));
    % stiTimeOver45=(stiTime>=45);
    % stiTimeUnder45=(25<stiTime<45);
    % stiTimeEqual25=(stiTime==25);




    % if k==3 && ~isempty(strfind(folder, 'WT-mouse\Pinch'))
    %     stiTime=stiTime(1:3910,1);
    % end


    % dataValuesOver45=sum(dataValues(stiTimeOver45))/sum(stiTimeOver45);
    % dataValuesUnder45=sum(dataValues(stiTimeUnder45))/sum(stiTimeUnder45);
    % dataValuesEqual25=sum(dataValues(stiTimeEqual25))/sum(stiTimeEqual25);

    dataValuesOver45=trapz(dataValues(stiTimeOver45))/sum(stiTimeOver45);
    dataValuesUnder45=trapz(dataValues(stiTimeUnder45))/sum(stiTimeUnder45);
    dataValuesEqual25=trapz(dataValues(stiTimeEqual25))/sum(stiTimeEqual25);





    areaResult(k,:)=[dataValuesEqual25 dataValuesUnder45 dataValuesOver45  ];




end

[p1,h,stats] = ranksum(areaResult(:,1),areaResult(:,2));
[p2,h,stats] = ranksum(areaResult(:,2),areaResult(:,3));

figure()
boxplot(areaResult(:,:),'Labels',{'T = 25','25 < T <  45','45 <= T <= 55'});
ylabel('Average area under curve');
set(gca,'TickDir','out');
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
for i = 1:3
    scatter(repmat(i, length(areaResult), 1), areaResult(:, i), 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'none',   'jitter', 'off', 'jitterAmount', 0.15);
    % if i>1
    %     plot([repmat(i,  1,length(areaResult))-1;repmat(i, 1, length(areaResult))], [areaResult(:, i-1)';areaResult(:, i)'], 'k-')
    % end

end
hold off
set(gca,'YLim',[-0.3 5.8])
exportgraphics(gca,'C:\Users\wangc25\Desktop\Dr.Liu\result\2-5.WT-Hot plate-area under curve.tif','Resolution',600)


figure()
boxplot(areaResult(:,2:3),'Labels',{'25 < T <  45','45 <= T <= 55'},'Widths',0.7);
ylabel('Average area under curve');
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
for i = 2:3
    scatter(repmat(i-1, length(areaResult), 1), areaResult(:, i),80, 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'none',   'jitter', 'off', 'jitterAmount', 0.15,'LineWidth',2);
    if i==3
        plot([repmat(i-2,  1,length(areaResult));repmat(i-1, 1, length(areaResult))], [areaResult(:, i-1)';areaResult(:, i)'], 'k-','LineWidth',2 )
    end

end
hold off
set(gca,'YLim',[-0.5 5.8])
set(gca,'XLim',[0.3 2.7])
set(gca,'linewidth',2)
exportgraphics(gca,'C:\Users\wangc25\Desktop\Dr.Liu\result\2-5-1.WT-Hot plate-area under curve.tif','Resolution',600)


% filename = 'areaUnderCurve.xlsx';
% writematrix(areaResult,filename)