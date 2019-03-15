%% input %%
% get the parent directory

uiwait(msgbox('Load parent folder'));
d = uigetdir('');
matlab_folder = cd;

cd(d)

listing = dir('**/*divergence_sinks_average.mat');

cd(matlab_folder) 

%% load files and save data %%
n_files = length(listing);
data = [];

for k = 1:n_files
    
    file = listing(k).name;
    directory = listing(k).folder;
    
    data_temp = load (fullfile ([directory, '/', file]));
    
    data{k,1} = data_temp;
end

%% divergence at sinks boxplot %%

g = [repmat(1,length(data{3,1}.data),1);...
    repmat(2,length(data{2,1}.data),1);...
    repmat(3,length(data{7,1}.data),1);...
    repmat(4,length(data{8,1}.data),1);...
    repmat(5,length(data{1,1}.data),1);...
    repmat(6,length(data{4,1}.data),1);...
    repmat(7,length(data{5,1}.data),1);...
    repmat(8,length(data{6,1}.data),1);...
    repmat(9,length(data{9,1}.data),1);...
    repmat(10,length(data{10,1}.data),1);...
    repmat(11,length(data{11,1}.data),1)];

sinksI = [data{3,1}.data(:,1);...
    data{2,1}.data(:,1);...
    data{7,1}.data(:,1);...
    data{8,1}.data(:,1);...
    data{1,1}.data(:,1);...
    data{4,1}.data(:,1);...
    data{5,1}.data(:,1);...
    data{6,1}.data(:,1);...
    data{9,1}.data(:,1);...
    data{10,1}.data(:,1);...
    data{11,1}.data(:,1)];

sinksII = [data{3,1}.data(:,2);...
    data{2,1}.data(:,2);...
    data{7,1}.data(:,2);...
    data{8,1}.data(:,2);...
    data{1,1}.data(:,2);...
    data{4,1}.data(:,2);...
    data{5,1}.data(:,2);...
    data{6,1}.data(:,2);...
    data{9,1}.data(:,2);...
    data{10,1}.data(:,2);...
    data{11,1}.data(:,2)];

sinksIII = [data{3,1}.data(:,3);...
    data{2,1}.data(:,3);...
    data{7,1}.data(:,3);...
    data{8,1}.data(:,3);...
    data{1,1}.data(:,3);...
    data{4,1}.data(:,3);...
    data{5,1}.data(:,3);...
    data{6,1}.data(:,3);...
    data{9,1}.data(:,3);...
    data{10,1}.data(:,3);...
    data{11,1}.data(:,3)];


pI = 1:3:33;  
pII = 1.2:3:33.2;  
pIII = 1.4:3:33.4;   

figure('units','normalized','outerposition',[0 1 0.7 0.7])
boxI = boxplot(sinksI, g, 'colors', 'b', 'positions', pI, 'width', 0.3);
hold on

boxII = boxplot(sinksII, g, 'colors', 'r', 'positions', pII, 'width', 0.3);
hold on

boxIII = boxplot(sinksIII, g, 'colors', 'g', 'positions', pIII, 'width', 0.3);
hold off

legend([boxI(1) boxII(1) boxIII(1)],'Primary sink','Secondary sink', 'Tertiary sink')

set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'xtick',pII,...
    'xticklabel',{'ctrl' ...
    'cofilin' ...
    'myosin' ...
    'myosin-cofilin' ...
    'MLCK constitutively active' ...
    'ena control' 'ena mutant' 'ena overexpressed' ...
    'sn28' ...
    'ssh mutant' 'ssh overexpressed'},...
    'xticklabelrotation',45)
ylabel('Divergence at sinks [A.U.]')


set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 