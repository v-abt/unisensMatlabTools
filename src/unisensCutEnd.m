function [status, message] = unisensCutEnd(path, duration, new_path)
%UNISENSCUTEND cut off the end of a unisens dataset

% Copyright 2017 movisens GmbH, Germany
message = '';
status = 1;

if nargin == 2
    % generate a random uinique temporary path
    temp_path = tempname();
    
    % crop the dataset
    unisensCrop(path, temp_path, 1, 0, duration);
    
    % list all files in the original directory
    tempContent = dir(temp_path);
    
    status = ones(1, length(tempContent));
    for i = 1 : length(tempContent)
        % move each file to the original directory and check for possible
        % errors while moving (this way even non unisens files from the
        % original dataset, logs etc, will be copied in the original 
        % directory)
        if isfile(fullfile(tempContent(i).folder, tempContent(i).name))
            [status(i), tmpMessage] = movefile( ...
                fullfile(tempContent(i).folder, tempContent(i).name), ...
                path, 'f');
            if ~isempty(tmpMessage)
                message = [tmpMessage newline];
            end
        end
    end
    
    % delete the temp directory to free up space
    rmdir(temp_path,'s');
    
    % if an error occurred, set th status flag accordingly
    if sum(status) > length(tempContent)
        status = 0;
    else
        status = 1;
    end
elseif nargin == 3
    unisensCrop(path, new_path, 1, 0, duration);
end
end