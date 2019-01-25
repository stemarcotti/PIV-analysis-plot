%% %%
uiwait(msgbox('Load parent folder'));
parent_d = uigetdir('');

matlab_folder = cd;
cd(parent_d)
listing = dir('**/*_divergence_sinks_average.mat');
cd(matlab_folder)

%% %%
ctrl = load(fullfile(listing(3).folder, listing(3).name));
ctrl = ctrl.data;
x_ctrl = ones(size(ctrl,1),1);

cofilin = load(fullfile(listing(2).folder, listing(2).name));
cofilin = cofilin.data;
x_cofilin = repmat(2,size(cofilin,1),1);

myosin = load(fullfile(listing(7).folder, listing(7).name));
myosin = myosin.data;
x_myosin = repmat(3,size(myosin,1),1);

myocof = load(fullfile(listing(8).folder, listing(8).name));
myocof = myocof.data;
x_myocof = repmat(4,size(myocof,1),1);

MLCK = load(fullfile(listing(1).folder, listing(1).name));
MLCK = MLCK.data;
x_MLCK = repmat(5,size(MLCK,1),1);

ena_ctrl = load(fullfile(listing(4).folder, listing(4).name));
ena_ctrl = ena_ctrl.data;
x_ena_ctrl = repmat(6,size(ena_ctrl,1),1);

ena_mut = load(fullfile(listing(5).folder, listing(5).name));
ena_mut = ena_mut.data;
x_ena_mut = repmat(7,size(ena_mut,1),1);

ena_over = load(fullfile(listing(6).folder, listing(6).name));
ena_over = ena_over.data;
x_ena_over = repmat(8,size(ena_over,1),1);

sn28 = load(fullfile(listing(9).folder, listing(9).name));
sn28 = sn28.data;
x_sn28 = repmat(9,size(sn28,1),1);

ssh_mut = load(fullfile(listing(10).folder, listing(10).name));
ssh_mut = ssh_mut.data;
x_ssh_mut = repmat(10,size(ssh_mut,1),1);

ssh_over = load(fullfile(listing(11).folder, listing(11).name));
ssh_over = ssh_over.data;
x_ssh_over = repmat(11,size(ssh_over,1),1);

wound = load(fullfile(listing(12).folder, listing(12).name));
wound = wound.data;
x_wound = repmat(12,size(wound,1),1);

%% %%
divergence = [ctrl; cofilin; myosin; myocof; MLCK; ena_ctrl; ena_mut; ena_over; sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; x_myocof; x_MLCK; x_ena_ctrl; x_ena_mut; x_ena_over; x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(divergence, g)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:12,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Divergence [A.U.]')

hold on
plot(g, divergence, 'ko', 'linewidth', 2)

%% %%
flow = [ctrl; cofilin; myosin; myocof; MLCK; ena_ctrl; ena_mut; ena_over; sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; x_myocof; x_MLCK; x_ena_ctrl; x_ena_mut; x_ena_over; x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(flow, g)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)
set(gca,'xtick',1:12,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Flow speed [um/min]')

hold on
plot(g, flow, 'ko', 'linewidth', 2)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)

%% %%
turnover = [ctrl; cofilin; myosin; myocof; MLCK; ena_ctrl; ena_mut; ena_over; sn28; ssh_mut; ssh_over; wound];
g = [x_ctrl; x_cofilin; x_myosin; x_myocof; x_MLCK; x_ena_ctrl; x_ena_mut; x_ena_over; x_sn28; x_ssh_mut; x_ssh_over; x_wound];

figure
boxplot(turnover, g)
set(gca,'xtick',1:12,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Actin turnover [A.U.]')

hold on
plot(g, turnover, 'ko', 'linewidth', 2)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
%% %%
sinkI = [ctrl(:,1); cofilin(:,1); myosin(:,1); myocof(:,1); MLCK(:,1);...
    ena_ctrl(:,1); ena_mut(:,1); ena_over(:,1); sn28(:,1); ssh_mut(:,1); ssh_over(:,1); wound(:,1)];
sinkII = [ctrl(:,2); cofilin(:,2); myosin(:,2); myocof(:,2); MLCK(:,2);...
    ena_ctrl(:,2); ena_mut(:,2); ena_over(:,2); sn28(:,2); ssh_mut(:,2); ssh_over(:,2); wound(:,2)];
sinkIII = [ctrl(:,3); cofilin(:,3); myosin(:,3); myocof(:,3); MLCK(:,3);...
    ena_ctrl(:,3); ena_mut(:,3); ena_over(:,3); sn28(:,3); ssh_mut(:,3); ssh_over(:,3); wound(:,3)];
g = [x_ctrl; x_cofilin; x_myosin; x_myocof; x_MLCK; x_ena_ctrl; x_ena_mut; x_ena_over; x_sn28; x_ssh_mut; x_ssh_over; x_wound];

pI = 1:3:36;  
pII = 2:3:37;  
pIII = 3:3:38;  

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
set(gca,'xtick', pII,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Streamlines at sinks [%]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 

%% %%
sinkI = [ctrl(:,1); cofilin(:,1); myosin(:,1); myocof(:,1); MLCK(:,1);...
    ena_ctrl(:,1); ena_mut(:,1); ena_over(:,1); sn28(:,1); ssh_mut(:,1); ssh_over(:,1); wound(:,1)];
sinkII = [ctrl(:,2); cofilin(:,2); myosin(:,2); myocof(:,2); MLCK(:,2);...
    ena_ctrl(:,2); ena_mut(:,2); ena_over(:,2); sn28(:,2); ssh_mut(:,2); ssh_over(:,2); wound(:,2)];
sinkIII = [ctrl(:,3); cofilin(:,3); myosin(:,3); myocof(:,3); MLCK(:,3);...
    ena_ctrl(:,3); ena_mut(:,3); ena_over(:,3); sn28(:,3); ssh_mut(:,3); ssh_over(:,3); wound(:,3)];
g = [x_ctrl; x_cofilin; x_myosin; x_myocof; x_MLCK; x_ena_ctrl; x_ena_mut; x_ena_over; x_sn28; x_ssh_mut; x_ssh_over; x_wound];

pI = 1:3:36;  
pII = 1.2:3:36.2;  
pIII = 1.4:3:36.4;  

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
set(gca,'xtick', pII,...
    'xticklabel',{'ctrl', 'cofilin', 'myosin', 'myocof',...
    'MLCK', 'ena_ctrl', 'ena_mut', 'ena_over',...
    'sn28', 'ssh_mut', 'ssh_over', 'wound'},...
    'xticklabelrotation',45)
ylabel('Divergence at sinks [A.U.]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'Color', [1 1 1]); 