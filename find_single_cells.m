%% %%
% load mask
[file,directory] = uigetfile('.tif');
nt = length(imfinfo([directory,'/', file]));

% ask the user for an ouput stamp
prompt = {'Output name',...
    'Px length [um]'};
title = 'Parameters';
dims = [1 35]; % set input box size
user_answer = inputdlg(prompt,title,dims); % get user answer
output_name = (user_answer{1,1});
mu2px = str2num(user_answer{2,1});

iptsetpref('ImshowBorder','tight');
%% %%
for k = 1:nt
    
    im = imread(fullfile(directory, file), k);
    im = im2double(im);
    
    bw = logical(im);
    bw_clean = bwareaopen(bw, 100);  % remove small objects (area less than 100 px)
    
    [L,~] = bwlabel(bw_clean);
    stats = regionprops(L, 'Area');
    allArea = [stats.Area];
    
    idx = [];
    for jj = 1:length(allArea)
        if allArea(jj) >= 4400 && allArea(jj) <= 15000
            
            [x, y] = find(L == jj);
            
            L1 = find(x == 1 | y == 1);
            L2 = find(x == size(im,1) | y == size(im,2));
            if isempty(L1) && isempty(L2)
                idx = [idx; jj];
%                 hold on; plot(y,x,'m.')
            end
            
        end
    end
    
    single_im = zeros(size(im,1), size(im,2));
    single_im = logical(single_im);
    imshow(single_im)
    
    area_single_um = [];
    perimeter_single_um = [];
    centroid_single_um = [];
    for kk = 1:length(idx)
        single_im_raw = L == idx(kk);
        single_im = imfill(single_im_raw, 4, 'holes');
        
        N = regionprops(single_im,'Centroid');
        centroid_single_px = cat(1, N.Centroid); % [px]
        centroid_single_um = [centroid_single_um; centroid_single_px .* mu2px];
        
        [x_s, y_s] = find(single_im == 1);
        hold on; plot(y_s, x_s, 'w.', 'markersize',1)
        
        area_single_px = length(find(single_im == 1));
        area_single_um = [area_single_um; area_single_px * mu2px^2];
        
        edge_line = edge(single_im, 'Canny');
        perimeter_single_px = length(find(edge_line == 1));
        perimeter_single_um = [perimeter_single_um; perimeter_single_px * mu2px];
        
        clear x_s y_s N 
    end
    
    hold off 
    
    data_single(k).area = area_single_um;
    data_single(k).perimeter = perimeter_single_um;
    if isempty(centroid_single_um) == 0
        data_single(k).centroid_x = centroid_single_um(:,1);
        data_single(k).centroid_y = centroid_single_um(:,2);
    end
    
    % save stack in folder [images]
    im_out = getframe(gcf);
    im_out = im_out.cdata;
    imwrite(im_out, fullfile(directory, [file(1:end-4) '_singlecells.tif']), ...
        'writemode', 'append');
    
end


%%
iptsetpref('ImshowBorder','loose');

save(fullfile(directory, ...
['single_cell_area_perimeter_' output_name '.mat']), ...
'data_single');

% clear
close all