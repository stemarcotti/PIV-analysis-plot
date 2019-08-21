%% load parent folder %%

warning off

uiwait(msgbox('Load parent folder'));
parent_d = uigetdir('');

matlab_folder = cd;
cd(parent_d)
listing = dir('**/cb*_m.tif');
cd(matlab_folder)

%% open one file at a time and perform analysis %%

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
    mu2px = 0.1;
    track = load(fullfile([directory '/data'], ['cell_track_', output_name, '.mat']));
    track = track.path ./ mu2px;     % [px]
    track_diff = [diff(track(:,1)) diff(track(:,2))];
    
    nt = length(imfinfo([directory,'/', file]));
    
    track_diff_unit = zeros(nt-1,2);
    for k = 1:nt-1
        track_diff_unit(k,:) = track_diff(k,:)./norm(track_diff(k,:));
    end
    
    for kk = 1:nt-1
        
        currentFrame = double(imread([directory '/' file],kk))/255;
        nextFrame = double(imread([directory '/' file],kk+1))/255;
        
        imbw1 = edge(currentFrame, 'canny');
        imbw1 = imdilate(imbw1, strel('disk', 4));
        imbw1 = imfill(imbw1, 'holes');
        imbw1 = imerode(imbw1, strel('disk', 4));
        
        imbw2 = edge(nextFrame, 'canny');
        imbw2 = imdilate(imbw2, strel('disk', 4));
        imbw2 = imfill(imbw2, 'holes');
        imbw2 = imerode(imbw2, strel('disk', 4));
        
        im_diff = imbw2 - imbw1; % 0 if images are the same; -1 if retraction; +1 extension
        
        % get extensions
        ext = im_diff;
        ext(ext < 0) = 0; % get only extension from im_diffext_label = bwlabel(ext);
        ext_label = logical(ext);
        data_ext = regionprops(ext_label,'Centroid','Area');
        
        [x_ext, y_ext] = find(ext ~= 0);
        
        data_centroid = cat(1, data_ext.Centroid);
        % plot
        imshow(currentFrame, [])
        hold on
        plot(y_ext, x_ext, 'g.')
        
        for count = 1:size(data_ext,1)
            % vector max ext
            p1 = [track(kk,1) track(kk,2)];
            p2 = [data_centroid(count,1) data_centroid(count,2)];                         % Second Point
            dp = p2-p1;
            quiver(p1(1),p1(2),dp(1),dp(2), 'g', ...
                'linewidth', 1, 'autoscale', 'off', 'maxheadsize', 0.3)
        end
        quiver(track(kk,1), track(kk,2), 100*track_diff_unit(kk,1), 100*track_diff_unit(kk,2), 'm', ...
            'linewidth', 2, 'autoscale', 'off', 'maxheadsize', 0.5)
        
        print(gcf, '-dtiffn', '-r200', [directory '/images/HR/all_ext_vect_', output_name, '_frame' num2str(kk) '_HR.tif']);
        
    end
end
