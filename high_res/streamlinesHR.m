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

% parameters
dilationSize = 4;       % [px]
erosionSize = 12;       % [px]
connectivityFill = 4;   % [px]

%% %%
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
    
    cellOutline = detectObjectBw(im, dilationSize, erosionSize, connectivityFill);
    edge_line = edge(cellOutline, 'Canny');
    [y, x] = find(edge_line);
    
    field(k).vx = field(k).vx .* cellOutline;
    field(k).vy = field(k).vy .* cellOutline;

    % define meshgrid 
    [x_str, y_str] = meshgrid(1:1:size(im,2), 1:1:size(im,1));
    
    % plot
    imshow(edge_line); 
    hold on
    slc = streamslice(x_str, y_str, field(k).vx, field(k).vy, 2, 'method', 'cubic');
    set(slc, 'Color', 'g', 'LineStyle', '-', 'linewidth', 2);
    plot(x,y,'w.', 'markersize', 3)
    
    % white image background
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', [1 1 1]);
    
    hold off

    print(gcf, '-dtiffn', '-r200', [d '/images/streamlines_thick_', output_name, '_frame', mat2str(k), '_HR.tif']);
    
end

close all
clear