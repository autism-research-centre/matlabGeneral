%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% StoreFiles
%%
%% Load files with a specific suffix and store them in a mat-file
%%
%% © R.A.I. Bethlehem 2012
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = rb_StoreFiles(Dir,Suffix)

% check input variables
if nargin<2, fprintf('You probably forgot something, check your input!!\n'), return, end;

% get directory list given filetype and suffix
FileList = dir(fullfile(Dir,Suffix));

% loop trough all files and give them a cell index and index name
for i=1:(length(FileList)
    file_name = FileList
    data = load(file_name)
    % convert to single precision to reduce filesize
    data = single(data);
    % put data in cell structure
    DATA(i).data = data;
    % put name in cell structure
    DATA(i).name = file_name1;
end

% input for storage name
new_name = input('Name of the dataset: ','s');
% save with compression
save(new_name,'DATA','-v7.3');

end
