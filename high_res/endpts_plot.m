%% INPUT %%

% load input folder
uiwait(msgbox('Load cell movie folder'));
d = uigetdir('');

% ask the user for an ouput stamp
prompt = {'Provide a name for the output files', 'Movie ID (n) if file format is cb_(n)_m.tif',...
    'Pixel length [um]'};
title = 'Parameters';
dims = [1 35];
user_answer = inputdlg(prompt,title,dims);
output_name = (user_answer{1,1});
cell_ID = str2double(user_answer{2,1});
px_length = str2double(user_answer{3,1});

% input names
im_file = sprintf('cb%d_m.tif', cell_ID);
im_file_nocb = sprintf('no_cb%d_m.tif', cell_ID);
field = load(fullfile ([d '/data'], ['piv_field_interpolated_', output_name, '.mat']));

% load files
names = fieldnames(field);
field = field.(names{1});
nt = length(field); % get number of frames in .tif file

% size of box to calculate streamlines end points
dx_um = 2.5;    % [um]
dy_um = 2.5;    % [um]

dx = ceil(dx_um/px_length); % [px]
dy = ceil(dy_um/px_length); % [px]

%% ENDPTS %%

for k = 1:nt
    
    % read movies
    im = imread(fullfile(d, im_file), k);
    im = im2double(im);
    
    % define start points for streamlines
    imbw = logical(im);
    imbw = imfill(imbw, 'holes');
    
    erode_cell = imerode(imbw, strel('disk', 15));
    edge_line = edge(erode_cell, 'Canny'); % get cell edge line
    [y, x] = find(edge_line);
    
    % define meshgrid
    [x_str, y_str] = meshgrid(1:1:size(im,2), 1:1:size(im,1));
    
    % compute streamlines (quantitative)
    stream_data = stream2(x_str, y_str, field(k).vx, field(k).vy, x, y);
    
    % compute frequency of end points
    m = size(im,1);
    n = size(im,2);
    [sx, sy, sf] = get_streamline_end_freq(stream_data, m, n, dx, dy);
    s_coord = [sx, sy, sf];
    
    % remove rows with null frequency
    condition = s_coord(:,3)==0;
    s_coord(condition,:) = [];
    
    % remove coordinates outside image
    idx = [];
    for ii = 1:size(s_coord,1)
        if erode_cell(ceil(s_coord(ii,2)), ceil(s_coord(ii,1))) == 0
            idx = [idx, ii];
        end
    end
    s_coord(idx,:) = [];
    
    % create scatter plot with frequency of end points
    imshow(im, [])
    hold on
    scatter(s_coord(:,1), s_coord(:,2), s_coord(:,3)/2, 'm', 'fill');
    hold off
    
    print(gcf, '-dtiffn', '-r200', [d '/images/HR/endpts_', output_name, '_frame' num2str(k) '_HR.tif']);
    
    
end
close all


clear
