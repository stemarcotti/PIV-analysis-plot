%% INPUT %%

% load input folder
uiwait(msgbox('Load cell movie folder'));
d = uigetdir('');

% ask the user for an ouput stamp
prompt = {'Provide a name for the output files', 'Movie ID (n) if file format is cb_(n)_m.tif'};
title = 'Parameters';
dims = [1 35];
user_answer = inputdlg(prompt,title,dims);
output_name = (user_answer{1,1});
cell_ID = str2double(user_answer{2,1});

% input names
im_file = sprintf('cb%d_m.tif', cell_ID);
im_file_nocb = sprintf('no_cb%d_m.tif', cell_ID);
field = load(fullfile ([d '/data'], ['piv_field_interpolated_', output_name, '.mat']));

% load files
names = fieldnames(field);
field = field.(names{1});
nt = length(field); % get number of frames in .tif file

iptsetpref('ImshowBorder','tight');

%% STREAMLINES %%

for k = 1:nt
    
    % read movies
    im = imread(fullfile(d, im_file), k);
    im = im2double(im);
    
    % if image without cell body is available
    file_name = [d '/' im_file_nocb];
    if exist(file_name, 'file') == 2
        
        im_nocb = im2double(imread(fullfile(d, im_file_nocb), k));
        
        % eliminate cell body data from vector field
        field(k).vx = field(k).vx .* logical(im_nocb);
        field(k).vy = field(k).vy .* logical(im_nocb);
    end
    
    % define meshgrid
    [x_str, y_str] = meshgrid(1:1:size(im,2), 1:1:size(im,1));
    
    pippo = zeros(size(im,1), size(im,2));
    bw = logical(im);
    bw = imfill(bw, 'holes');
    
    [L,~] = bwlabel(bw);
    stats = regionprops(L, 'Area');
    allArea = [stats.Area];
    area_largest_obj = max(allArea(:));
    bw = bwareaopen(bw,area_largest_obj);
    
    edge_line = edge(bw, 'Canny'); % get cell edge line
    [y_edge, x_edge] = find(edge_line == 1);
    
    % plot
    imshow(pippo);
    hold on
    plot(x_edge, y_edge, 'w.', 'markersize',1)
    slc = streamslice(x_str, y_str, field(k).vx, field(k).vy, 2, 'method', 'cubic');
    set(slc, 'Color', 'g', 'LineStyle', '-', 'LineWidth', 1);
    
    % white image background
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', [1 1 1]);
    
    hold off
    print(gcf, '-dtiffn', '-r200', [d '/images/HR/streamlines_', output_name, '_frame' num2str(k) '_HR.tif']);
    
    
end

close all
clear