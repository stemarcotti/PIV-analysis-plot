%% %%
% load mask
[file,directory] = uigetfile('.tif');
nt = length(imfinfo([directory,'/', file]));
 
dilationSize = 4;
erosionSize = 4;
connectivityFill = 4;

iptsetpref('ImshowBorder','tight');
%% %%
for k = 1:nt
     
     im = imread(fullfile(directory, file), k);
     im = im2double(im);
     
     bw = logical(im);
     bw_clean = bwareaopen(bw, 30);  % remove small objects (noise: area less than 30 px)
     
     edge_line = edge(bw_clean, 'Canny');
     
     BW2d = imdilate(edge_line, strel('disk', dilationSize));
     BW2f = imfill(BW2d, connectivityFill, 'holes');
     BW2 = imerode(BW2f, strel('disk', erosionSize));
     
     [L,~] = bwlabel(BW2);
     stats = regionprops(L, 'Area');
     allArea = [stats.Area];
     area_largest_obj = max(allArea(:));
     BW3 = bwareaopen(BW2,area_largest_obj);
     
     imshow(BW3)

     % save stack in folder [images]
     im_out = getframe(gcf);
     im_out = im_out.cdata;
     imwrite(im_out, fullfile(directory, [file(1:end-4) '_clean.tif']), ...
         'writemode', 'append');
     
end
iptsetpref('ImshowBorder','loose');
clear
close all