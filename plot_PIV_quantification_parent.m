%% %%
uiwait(msgbox('Load parent folder'));
parent_d = uigetdir('');

matlab_folder = cd;
cd(parent_d)
listing = dir('**/*_cell_speed_average.mat');
cd(matlab_folder)

%% %%
ctrl = load(fullfile(listing(4).folder, listing(4).name));
ctrl = ctrl.data;
x_ctrl = ones(size(ctrl,1),1);

cofilin = load(fullfile(listing(2).folder, listing(2).name));
cofilin = cofilin.data;
x_cofilin = repmat(2,size(cofilin,1),1);

myosin = load(fullfile(listing(8).folder, listing(8).name));
myosin = myosin.data;
x_myosin = repmat(3,size(myosin,1),1);

cofhet = load(fullfile(listing(3).folder, listing(3).name));
cofhet = cofhet.data;
x_cofhet = repmat(4,size(cofhet,1),1);

myohet = load(fullfile(listing(10).folder, listing(10).name));
myohet = myohet.data;
x_myohet = repmat(5,size(myohet,1),1);

myocof = load(fullfile(listing(9).folder, listing(9).name));
myocof = myocof.data;
x_myocof = repmat(6,size(myocof,1),1);

MLCK = load(fullfile(listing(1).folder, listing(1).name));
MLCK = MLCK.data;
x_MLCK = repmat(7,size(MLCK,1),1);

ena_ctrl = load(fullfile(listing(5).folder, listing(5).name));
ena_ctrl = ena_ctrl.data;
x_ena_ctrl = repmat(8,size(ena_ctrl,1),1);

ena_mut = load(fullfile(listing(6).folder, listing(6).name));
ena_mut = ena_mut.data;
x_ena_mut = repmat(9,size(ena_mut,1),1);

ena_over = load(fullfile(listing(7).folder, listing(7).name));
ena_over = ena_over.data;
x_ena_over = repmat(10,size(ena_over,1),1);

sn28 = load(fullfile(listing(11).folder, listing(11).name));
sn28 = sn28.data;
x_sn28 = repmat(11,size(sn28,1),1);

ssh_mut = load(fullfile(listing(12).folder, listing(12).name));
ssh_mut = ssh_mut.data;
x_ssh_mut = repmat(12,size(ssh_mut,1),1);

ssh_over = load(fullfile(listing(13).folder, listing(13).name));
ssh_over = ssh_over.data;
x_ssh_over = repmat(13,size(ssh_over,1),1);

wound = load(fullfile(listing(14).folder, listing(14).name));
wound = wound.data;
x_wound = repmat(14,size(wound,1),1);

%% %%
divergence = [ctrl; cofilin; myosin; ...
    cofhet; myohet; myocof; MLCK; ...
    ena_ctrl; ena_mut; ena_over; ...
    sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(divergence, g, 'colors', 'k')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:14,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Divergence [A.U.]')

hold on
plot(g, divergence, 'ko')

%% %%
area = [ctrl; cofilin; myosin; ...
    cofhet; myohet; myocof; MLCK; ...
    ena_ctrl; ena_mut; ena_over; ...
    sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(area, g, 'colors', 'k')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:14,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Area [um2]')

hold on
plot(g, area, 'ko')


%% %%
flow = [ctrl; cofilin; myosin; ...
    cofhet; myohet; myocof; MLCK; ...
    ena_ctrl; ena_mut; ena_over; ...
    sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(flow, g, 'colors', 'k')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:14,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Flow speed [um/min]')

hold on
plot(g, flow, 'ko')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)

%% %%
turnover = [ctrl; cofilin; myosin; ...
    cofhet; myohet; myocof; MLCK; ...
    ena_ctrl; ena_mut; ena_over; ...
    sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(turnover, g, 'colors', 'k')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:14,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Actin turnover [A.U.]')

hold on
plot(g, turnover, 'ko')
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
%% %%
sinkI = [ctrl(:,1); cofilin(:,1); myosin(:,1); ...
    cofhet(:,1); myohet(:,1); myocof(:,1); MLCK(:,1);...
    ena_ctrl(:,1); ena_mut(:,1); ena_over(:,1); sn28(:,1); ssh_mut(:,1); ssh_over(:,1); wound(:,1)];
sinkII = [ctrl(:,2); cofilin(:,2); myosin(:,2); ...
    cofhet(:,2); myohet(:,2); myocof(:,2); MLCK(:,2);...
    ena_ctrl(:,2); ena_mut(:,2); ena_over(:,2); sn28(:,2); ssh_mut(:,2); ssh_over(:,2); wound(:,2)];
sinkIII = [ctrl(:,3); cofilin(:,3); myosin(:,3); ...
    cofhet(:,3); myohet(:,3); myocof(:,3); MLCK(:,3);...
    ena_ctrl(:,3); ena_mut(:,3); ena_over(:,3); sn28(:,3); ssh_mut(:,3); ssh_over(:,3); wound(:,3)];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

pI = 1:3:42;  
pII = 1.2:3:42.2;  
pIII = 1.4:3:42.4;  

figure('units','normalized','outerposition',[0 1 0.7 0.7])
boxI = boxplot(sinkI, g, 'colors', 'b', 'positions', pI, 'width', 0.4);
hold on

boxII = boxplot(sinkII, g, 'colors', 'r', 'positions', pII, 'width', 0.4);
hold on

boxIII = boxplot(sinkIII, g, 'colors', 'g', 'positions', pIII, 'width', 0.4);
hold off

ylim([0 100])
legend([boxI(1) boxII(1) boxIII(1)],'Primary sink','Secondary sink', 'Tertiary sink')

set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'xtick',pII,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Streamlines at sinks [%]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 

%% %%
sinkI = [ctrl(:,1); cofilin(:,1); myosin(:,1); ...
    cofhet(:,1); myohet(:,1); myocof(:,1); MLCK(:,1);...
    ena_ctrl(:,1); ena_mut(:,1); ena_over(:,1); sn28(:,1); ssh_mut(:,1); ssh_over(:,1); wound(:,1)];
sinkII = [ctrl(:,2); cofilin(:,2); myosin(:,2); ...
    cofhet(:,2); myohet(:,2); myocof(:,2); MLCK(:,2);...
    ena_ctrl(:,2); ena_mut(:,2); ena_over(:,2); sn28(:,2); ssh_mut(:,2); ssh_over(:,2); wound(:,2)];
sinkIII = [ctrl(:,3); cofilin(:,3); myosin(:,3); ...
    cofhet(:,3); myohet(:,3); myocof(:,3); MLCK(:,3);...
    ena_ctrl(:,3); ena_mut(:,3); ena_over(:,3); sn28(:,3); ssh_mut(:,3); ssh_over(:,3); wound(:,3)];
g = [x_ctrl; x_cofilin; x_myosin; ...
    x_cofhet; x_myohet; x_myocof; x_MLCK; ...
    x_ena_ctrl; x_ena_mut; x_ena_over; ...
    x_sn28; x_ssh_mut; x_ssh_over; x_wound];

pI = 1:3:42;  
pII = 1.2:3:42.2;  
pIII = 1.4:3:42.4;  

figure('units','normalized','outerposition',[0 1 0.7 0.7])
boxI = boxplot(sinkI, g, 'colors', 'b', 'positions', pI, 'width', 0.3);
hold on

boxII = boxplot(sinkII, g, 'colors', 'r', 'positions', pII, 'width', 0.3);
hold on

boxIII = boxplot(sinkIII, g, 'colors', 'g', 'positions', pIII, 'width', 0.3);
hold off

legend([boxI(1) boxII(1) boxIII(1)],'Primary sink','Secondary sink', 'Tertiary sink')

set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'xtick',pII,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', ...
    'cofhet', 'myohet', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Divergence at sinks [A.U.]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 