function scripts = savescripts
%% This script puts the scripts you have in the current folder into variable
% Often, it's useful to save the actual scripts you're running
% with your data. This means you'll be able to go back and see
% what the scripts looked like at the point in time when you
% ran the participant. Only makes files minimally larger.
% Make sure to actually save the output variable with data!
% output is a structure with fields "name" and "content"

all_dirs = strsplit(genpath(pwd), ';');
all_dirs(end) = []; % infuriating
i = 0;
for curr_dir = all_dirs
    curr_dir = curr_dir{1}; % fuck off matlab
    sub_files = dir(fullfile(curr_dir, '*.m'));
    if numel(sub_files)>0
        for ii = 1:numel(sub_files);
            i = i+1;
            scripts(i).name = fullfile(curr_dir, sub_files(ii).name);
            scripts(i).content = fileread(scripts(i).name);
        end
    end
end