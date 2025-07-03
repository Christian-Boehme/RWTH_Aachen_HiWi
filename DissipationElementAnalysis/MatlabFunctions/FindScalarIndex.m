function index = FindScalarIndex(fileName, datasetPath, scalarName)
% Get information about the dataset
info = h5info(fileName, datasetPath);

% Extract the attributes information
attributes = info.Attributes;

% Initialize the index to a negative number to indicate not found
index = -1;

% Loop through the attributes to find the match
for i = 1:length(attributes)
    % Check if the attribute's value matches the scalar name
    if strcmp(h5readatt(fileName, datasetPath, attributes(i).Name), scalarName)
        % MATLAB attribute names follow the format 'Index N', where N is the index.
        % Extract 'N' as the index.
        indexStr = extractAfter(attributes(i).Name, 'Index ');
        index = str2double(indexStr);
        break; % Exit the loop once the match is found
    end
end

% Check if the scalar name was found
if index == -1
    disp(['Scalar name "', scalarName, '" not found.']);
end

end
