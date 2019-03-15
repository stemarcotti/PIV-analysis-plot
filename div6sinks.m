%% INPUT %%
% get the file directory
uiwait(msgbox('Load cell movie folder'));
d = uigetdir('');
warning off

% ask the user for an ouput stamp
prompt = {'Provide a name for the output files', 'Movie ID (n) if file format is cb_(n)_m.tif', ...
    'Pixel length [um]'};
title = 'Parameters';
dims = [1 35]; % set input box size
user_answer = inputdlg(prompt,title,dims); % get user answer
output_name = (user_answer{1,1});
cell_ID = str2double(user_answer{2,1});
px_length = str2double(user_answer{3,1});   % [um]

% parameters
dx_um = 2.5;    % [um] has to be the same as streamlines_plot.m
dy_um = 2.5;    % [um] has to be the same as streamlines_plot.m
dx = ceil(dx_um/px_length); % [px]
dy = ceil(dy_um/px_length); % [px]

dilationSize = 4;
erosionSize = 12;
connectivityFill = 4;

% load interpolated filed
flow = load (fullfile ([d '/data'], ['piv_field_interpolated_', output_name, '.mat']));
flow = flow.vfilt;

% load streamline end points
stream = load (fullfile ([d '/data'], ['flow_streamlines_endpts_', output_name, '.mat']));
stream = stream.stream_end_pts;

% number of frames in the movie
nt = length(imfinfo(fullfile (d, sprintf('cb%d_m.tif', cell_ID))));
div_at_sink = zeros(nt-1,6);

%% DIVERGENCE at sinks %%

for k = 1:nt-1
    
    % load current and next frame
    currentFrame = double(imread(fullfile(d, sprintf ...
        ('cb%d_m.tif', cell_ID)),k)) / 255;
    
    nextFrame = double(imread(fullfile(d, sprintf ...
        ('cb%d_m.tif', cell_ID)),k+1)) / 255;
    
    % calculate divergence
    u = flow(k).vx;
    v = flow(k).vy;
    
    div = divergence(u,v);
    
    % find intersection
    cellOutline1 = detectObjectBw(currentFrame, dilationSize, erosionSize, connectivityFill);
    cellOutline2 = detectObjectBw(nextFrame, dilationSize, erosionSize, connectivityFill);
    cellOutline = cellOutline1 .* cellOutline2;
    cellOutline(cellOutline==0)=NaN;
    
    div_mask = div .* cellOutline;
    
    % remove cell body if present
    file_name = [d, '/', sprintf('no_cb%d_m.tif', cell_ID)];
    if exist(file_name, 'file') == 2
        
        no_cb_frame = double(imread(fullfile(file_name),k)) / 255;
        lim = logical(no_cb_frame);
        
        div_mask = div_mask .* lim;   % remove cell body if no_cb exists
        div_mask(lim == 0) = NaN;
    end
    
    % find max 6 sinks coordinates by sorting frequency field
    stream_f = stream(k).f(:);
    [stream_f_sorted, stream_f_sorted_index] = sort(stream_f, 'descend');
    
    if length(stream_f) >= 6
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        s2_x = stream(k).xf(stream_f_sorted_index(2),1);
        s2_y = stream(k).yf(stream_f_sorted_index(2),1);
        s3_x = stream(k).xf(stream_f_sorted_index(3),1);
        s3_y = stream(k).yf(stream_f_sorted_index(3),1);
        s4_x = stream(k).xf(stream_f_sorted_index(4),1);
        s4_y = stream(k).yf(stream_f_sorted_index(4),1);
        s5_x = stream(k).xf(stream_f_sorted_index(5),1);
        s5_y = stream(k).yf(stream_f_sorted_index(5),1);
        s6_x = stream(k).xf(stream_f_sorted_index(6),1);
        s6_y = stream(k).yf(stream_f_sorted_index(6),1);
        
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        s2_box_x = round(s2_x-(dx/2));
        s2_box_y = round(s2_y-(dy/2));
        s3_box_x = round(s3_x-(dx/2));
        s3_box_y = round(s3_y-(dy/2));
        s4_box_x = round(s4_x-(dx/2));
        s4_box_y = round(s4_y-(dy/2));
        s5_box_x = round(s5_x-(dx/2));
        s5_box_y = round(s5_y-(dy/2));
        s6_box_x = round(s6_x-(dx/2));
        s6_box_y = round(s6_y-(dy/2));
        
        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        if isnan(s2_box_x)
            s2_div = zeros(dx+1, dy+1) * NaN;
        else
            s2_div = div_mask(s2_box_y:s2_box_y+dy, s2_box_x:s2_box_x+dx);
        end
        
        if isnan(s3_box_x)
            s3_div = zeros(dx+1, dy+1) * NaN;
        else
            s3_div = div_mask(s3_box_y:s3_box_y+dy, s3_box_x:s3_box_x+dx);
        end
        
        if isnan(s4_box_x)
            s4_div = zeros(dx+1, dy+1) * NaN;
        else
            s4_div = div_mask(s4_box_y:s4_box_y+dy, s4_box_x:s4_box_x+dx);
        end
        
        if isnan(s5_box_x)
            s5_div = zeros(dx+1, dy+1) * NaN;
        else
            s5_div = div_mask(s5_box_y:s5_box_y+dy, s5_box_x:s5_box_x+dx);
        end
        
        if isnan(s6_box_x)
            s6_div = zeros(dx+1, dy+1) * NaN;
        else
            s6_div = div_mask(s6_box_y:s6_box_y+dy, s6_box_x:s6_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
        div_at_sink(k,2) = nanmean(s2_div(:));
        div_at_sink(k,3) = nanmean(s3_div(:));
        div_at_sink(k,4) = nanmean(s4_div(:));
        div_at_sink(k,5) = nanmean(s5_div(:));
        div_at_sink(k,6) = nanmean(s6_div(:));
      
    elseif length(stream_f) == 5
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        s2_x = stream(k).xf(stream_f_sorted_index(2),1);
        s2_y = stream(k).yf(stream_f_sorted_index(2),1);
        s3_x = stream(k).xf(stream_f_sorted_index(3),1);
        s3_y = stream(k).yf(stream_f_sorted_index(3),1);
        s4_x = stream(k).xf(stream_f_sorted_index(4),1);
        s4_y = stream(k).yf(stream_f_sorted_index(4),1);
        s5_x = stream(k).xf(stream_f_sorted_index(5),1);
        s5_y = stream(k).yf(stream_f_sorted_index(5),1);
       
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        s2_box_x = round(s2_x-(dx/2));
        s2_box_y = round(s2_y-(dy/2));
        s3_box_x = round(s3_x-(dx/2));
        s3_box_y = round(s3_y-(dy/2));
        s4_box_x = round(s4_x-(dx/2));
        s4_box_y = round(s4_y-(dy/2));
        s5_box_x = round(s5_x-(dx/2));
        s5_box_y = round(s5_y-(dy/2));
        
        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        if isnan(s2_box_x)
            s2_div = zeros(dx+1, dy+1) * NaN;
        else
            s2_div = div_mask(s2_box_y:s2_box_y+dy, s2_box_x:s2_box_x+dx);
        end
        
        if isnan(s3_box_x)
            s3_div = zeros(dx+1, dy+1) * NaN;
        else
            s3_div = div_mask(s3_box_y:s3_box_y+dy, s3_box_x:s3_box_x+dx);
        end
        
        if isnan(s4_box_x)
            s4_div = zeros(dx+1, dy+1) * NaN;
        else
            s4_div = div_mask(s4_box_y:s4_box_y+dy, s4_box_x:s4_box_x+dx);
        end
        
        if isnan(s5_box_x)
            s5_div = zeros(dx+1, dy+1) * NaN;
        else
            s5_div = div_mask(s5_box_y:s5_box_y+dy, s5_box_x:s5_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
        div_at_sink(k,2) = nanmean(s2_div(:));
        div_at_sink(k,3) = nanmean(s3_div(:));
        div_at_sink(k,4) = nanmean(s4_div(:));
        div_at_sink(k,5) = nanmean(s5_div(:));
        
    elseif length(stream_f) == 4
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        s2_x = stream(k).xf(stream_f_sorted_index(2),1);
        s2_y = stream(k).yf(stream_f_sorted_index(2),1);
        s3_x = stream(k).xf(stream_f_sorted_index(3),1);
        s3_y = stream(k).yf(stream_f_sorted_index(3),1);
        s4_x = stream(k).xf(stream_f_sorted_index(4),1);
        s4_y = stream(k).yf(stream_f_sorted_index(4),1);
        
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        s2_box_x = round(s2_x-(dx/2));
        s2_box_y = round(s2_y-(dy/2));
        s3_box_x = round(s3_x-(dx/2));
        s3_box_y = round(s3_y-(dy/2));
        s4_box_x = round(s4_x-(dx/2));
        s4_box_y = round(s4_y-(dy/2));
        

        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        if isnan(s2_box_x)
            s2_div = zeros(dx+1, dy+1) * NaN;
        else
            s2_div = div_mask(s2_box_y:s2_box_y+dy, s2_box_x:s2_box_x+dx);
        end
        
        if isnan(s3_box_x)
            s3_div = zeros(dx+1, dy+1) * NaN;
        else
            s3_div = div_mask(s3_box_y:s3_box_y+dy, s3_box_x:s3_box_x+dx);
        end
        
        if isnan(s4_box_x)
            s4_div = zeros(dx+1, dy+1) * NaN;
        else
            s4_div = div_mask(s4_box_y:s4_box_y+dy, s4_box_x:s4_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
        div_at_sink(k,2) = nanmean(s2_div(:));
        div_at_sink(k,3) = nanmean(s3_div(:));
        div_at_sink(k,4) = nanmean(s4_div(:));
        
    elseif length(stream_f) == 3
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        s2_x = stream(k).xf(stream_f_sorted_index(2),1);
        s2_y = stream(k).yf(stream_f_sorted_index(2),1);
        s3_x = stream(k).xf(stream_f_sorted_index(3),1);
        s3_y = stream(k).yf(stream_f_sorted_index(3),1);
        
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        s2_box_x = round(s2_x-(dx/2));
        s2_box_y = round(s2_y-(dy/2));
        s3_box_x = round(s3_x-(dx/2));
        s3_box_y = round(s3_y-(dy/2));
        
        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        if isnan(s2_box_x)
            s2_div = zeros(dx+1, dy+1) * NaN;
        else
            s2_div = div_mask(s2_box_y:s2_box_y+dy, s2_box_x:s2_box_x+dx);
        end
        
        if isnan(s3_box_x)
            s3_div = zeros(dx+1, dy+1) * NaN;
        else
            s3_div = div_mask(s3_box_y:s3_box_y+dy, s3_box_x:s3_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
        div_at_sink(k,2) = nanmean(s2_div(:));
        div_at_sink(k,3) = nanmean(s3_div(:));
        
    elseif length(stream_f) == 2
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        s2_x = stream(k).xf(stream_f_sorted_index(2),1);
        s2_y = stream(k).yf(stream_f_sorted_index(2),1);
        
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        s2_box_x = round(s2_x-(dx/2));
        s2_box_y = round(s2_y-(dy/2));
        
        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        if isnan(s2_box_x)
            s2_div = zeros(dx+1, dy+1) * NaN;
        else
            s2_div = div_mask(s2_box_y:s2_box_y+dy, s2_box_x:s2_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
        div_at_sink(k,2) = nanmean(s2_div(:));
        
    elseif length(stream_f) == 1
        
        s1_x = stream(k).xf(stream_f_sorted_index(1),1);
        s1_y = stream(k).yf(stream_f_sorted_index(1),1);
        
        % calculate div in boxes around sinks
        s1_box_x = round(s1_x-(dx/2));
        s1_box_y = round(s1_y-(dy/2));
        
        if isnan(s1_box_x)  % verify sink it's not at the cell edge
            s1_div = zeros(dx+1, dy+1) * NaN;
        else
            s1_div = div_mask(s1_box_y:s1_box_y+dy, s1_box_x:s1_box_x+dx);
        end
        
        div_at_sink(k,1) = nanmean(s1_div(:));
    
    end
    
    clear stream_f
    clear s1_div s2_div s3_div s4_div s5_div s6_div
    clear s1_x s1_y s2_x s2_y s3_x s3_y s4_x s4_y s5_x s5_y s6_x s6_y
    
end

average_div_at_sink = nanmean(div_at_sink);

%% SAVE %%
save(fullfile(d, 'data', ...
    ['divergence_6sinks_', output_name, '.mat']), ...
    'div_at_sink');

clear