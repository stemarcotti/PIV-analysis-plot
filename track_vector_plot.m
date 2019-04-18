%% load parent folder %%

warning off

uiwait(msgbox('Load parent folder'));
parent_d = uigetdir('');

matlab_folder = cd;
cd(parent_d)
listing = dir('**/cb*_m.tif');
cd(matlab_folder)

% ask the user for an ouput stamp
prompt = {'Pixel length [um]'};
title = 'Parameters';
dims = [1 35]; % set input box size
user_answer = inputdlg(prompt,title,dims); % get user answer
mu2px = str2double(user_answer{1,1});

%%
n_files = length(listing);

for file_list = 1:n_files
    
    % file and directory name
    file = listing(file_list).name;
    directory = listing(file_list).folder;
    
    % output name and cell ID
    slash_indeces = strfind(directory,'/');
    output_name = directory(slash_indeces(end)+1:end);
    cell_ID = str2double(output_name(1:2));
    
    % load
    track = load(fullfile([directory '/data'], ['cell_track_', output_name, '.mat']));
    track = track.path;     % [um]
    track = track ./ mu2px; % [px]
    track_diff = [diff(track(:,1)) diff(track(:,2))];
    
    nt = size(track_diff,1);
    
    % make unit vector track_diff
    track_diff_unit = zeros(nt,2);
    for k = 1:nt
        track_diff_unit(k,:) = track_diff(k,:)./norm(track_diff(k,:));
    end
    
    s_unit = load(fullfile([directory '/data'], ['unit_vector_primary_sink_', output_name, '.mat']));
    s_unit = s_unit.s_unit;
    
    largest_ext_unit = load(fullfile([directory '/data'], ['unit_vector_largest_ext_vectors_', output_name, '.mat']));
    largest_ext_unit = largest_ext_unit.largest_ext_unit;
    
    figure
    quiver(track(1:end-1,1), track(1:end-1,2), 10*s_unit(:,1), 10*s_unit(:,2), 'color', [50 205 50]./255, 'linewidth', 1, 'maxheadsize', 0.5)
    hold on
    plot(track(:,1), track(:,2), 'k', 'linewidth',2);
    set(gca,'visible','off')
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', [1 1 1]);
    axis 'equal'
    
    saveas(gcf, [directory '/images/track_primary_sink_' output_name '.tif']);
    close 
    
    
    figure
    quiver(track(1:end-1,1), track(1:end-1,2), 10*largest_ext_unit(:,1), 10*largest_ext_unit(:,2), 'color', [255 114 86]./255, 'linewidth', 1, 'maxheadsize', 0.5)
    hold on
    plot(track(:,1), track(:,2), 'k', 'linewidth',2);
    set(gca,'visible','off')
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', [1 1 1]);
    axis 'equal'
    
    saveas(gcf, [directory '/images/track_largest_ext_' output_name '.tif']);
    close 
    
end

clear; clc; close all
