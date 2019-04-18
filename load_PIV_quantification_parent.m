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
data = [];

for k = 1:n_files
    
    file = listing(k).name;
    directory = listing(k).folder;
    
    data_temp = load(fullfile ([directory, '/', file]));
    values = cell2mat(struct2cell(data_temp));
    
    data = [data; values];
end

save(fullfile(d, ['/' mut_name '_' input_name '.mat']), 'data');

clear