
% Finding location, changing current dir to location and adding function
% file to path
path = mfilename('fullpath');
cd(fileparts(path))
addpath('functions')

% Import constant variables from file
DS_constants = drivingSim_constants;

% Find files for analysis
searchStr = fullfile('data', '*.csv');
files = dir(searchStr);

% Prep output variable
DS_output = cell(length(files), 2);

% Prep for drawing plots
if DS_constants.drawPlots
    fig = axes();
    hold on
end
    
for file_n = 1:length(files)

    % Generate filename
    fileName = files(file_n).name;
    
    % Extract participant ID from filename?
    participantID = strsplit(fileName, {'_', '.'});
    participantID = participantID{1};
    
    % Import data
    fullData = importDriveCSV(fullfile('data', fileName));
    
    % Search 2nd data column (distance) for next sample after startPoint
    createPointIdx = find(fullData.Distancetravelledfeet > DS_constants.createPoint, 1, 'first');
    dummyDistance = DS_constants.startPoint - cumsum(diff(fullData.Elapsedtimesec(createPointIdx:end))*DS_constants.velocity);
    dummyDistance = dummyDistance(1:find(dummyDistance < DS_constants.endPoint,1));
    destroyPointIdx = createPointIdx + length(dummyDistance) - 1;
    
    % Extract distance data for number of samples other vehicle exists for
    extractedData = fullData(createPointIdx:destroyPointIdx,:);
    extractedData.Elapsedtimesec = extractedData.Elapsedtimesec - extractedData.Elapsedtimesec(1);
    
    if DS_constants.drawPlots
        % Plot data distance (y-axis) vs time (x-axis) for each participant
        plot(fig, extractedData.Elapsedtimesec, extractedData.Distancetravelledfeet, extractedData.Elapsedtimesec, dummyDistance);
    end
    
    % Locate and extract crossing point for each participant
    [x,y] = intersections(extractedData.Elapsedtimesec, extractedData.Distancetravelledfeet, extractedData.Elapsedtimesec, dummyDistance);
    [~, ix] = min(abs(fullData.Distancetravelledfeet - y));
    
    % Add indcator line to plot?
    
    % Save crossing point row number to output variable
    DS_output(file_n,:) = {participantID, ix + 1};
    
end

if DS_constants.drawPlots
    hold off
    % Save plot?
end

% Write output variable to file
writetable(cell2table(DS_output, 'VariableNames', {'Participant_ID', 'Intersection_point'}),...
           DS_constants.outputFilename);