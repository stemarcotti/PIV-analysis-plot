%% input %%

% get the parent directory
uiwait(msgbox('Load parent folder'));
d = uigetdir('');
matlab_folder = cd;

% ask the user for an ouput stamp
prompt = {'Input',...
    'Mutant type'};
title = 'Parameters';
dims = [1 35]; % set input box size
user_answer = inputdlg(prompt,title,dims); % get user answer
input_name = (user_answer{1,1});
mut_name = (user_answer{2,1});

cd(d)
listing = dir(['**/' input_name '*.mat']);
cd(matlab_folder) 

%% load files and save data %%
n_files = length(listing);
data = struct([]);

for k = 1:n_files
    
    file = listing(k).name;
    directory = listing(k).folder;
    
    data_temp = load(fullfile ([directory, '/', file]));
    values = cell2mat(struct2cell(data_temp));
    
    data(k).val = values;
end

% average linescan for this frame
% find length longest track
len = zeros(length(data),1);
for ii = 1:length(data)
    len(ii,1) = length(data(ii).val);
end
max_len = max(len);

% initialise matrix
data_matrix = zeros(max_len, length(data));

% pull data from structure to matrix
for kkk = 1:length(data)
    temp = data(kkk).val;
    temp(end+1:max_len, 1) = NaN;
    data_matrix(:,kkk) = temp;
end

save(fullfile(d, [input_name '_' mut_name '.mat']), 'data_matrix');

av_data_matrix = nanmean(data_matrix,2);