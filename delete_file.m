%% %%

uiwait(msgbox('Load parent folder'));
parent_d = uigetdir('');

matlab_folder = cd;
cd(parent_d)
listing = dir('**/divergence_sinks*.mat');
listing1 = dir('**/streamlines_percentage*.mat');
listing2 = dir('**/flow_streamlines*.mat');
listing3 = dir('**/end_points*.tif');

cd(matlab_folder)

%% divergence at sinks
for k = 1:length(listing)
    
    filename = [listing(k).folder '/' listing(k).name];
    delete(filename)
    
end

%% streamlines percentage
for k = 1:length(listing1)
    
    filename = [listing1(k).folder '/' listing1(k).name];
    delete(filename)
    
end

%% end pts quantification
for k = 1:length(listing2)
    
    filename = [listing2(k).folder '/' listing2(k).name];
    delete(filename)
    
end

%% end pts heatmap
for k = 1:length(listing3)
    
    filename = [listing3(k).folder '/' listing3(k).name];
    delete(filename)
    
end