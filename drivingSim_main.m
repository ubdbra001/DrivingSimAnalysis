clear;close;clc

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
DS_output = cell(length(files), 4);

if ~exist(DS_constants.outputDir, 'dir')
    mkdir(DS_constants.outputDir)
end

% Prep for drawing plots
if DS_constants.drawPlots
    fig = axes();
    hold on
end
    
for file_n = 1:length(files)
    
    clc

    % Generate filename
    fileName = files(file_n).name;
    
    % Extract participant ID from filename?
    participantID = strsplit(fileName, {'_', '.'});
    participantID = participantID{1};    
    
    % Check to see if participant ID is a number
    if ~isnan(str2double(participantID))
        %participantID = str2num(participantID);
        % If it is the decide the group and line color based on the participant ID
        switch participantID
            case DS_constants.driveDCD
                lineCol = 'r';
            case DS_constants.nodriveDCD
                lineCol = 'g';
            case DS_constants.driveCON
                lineCol = 'b';
            case DS_constants.nodriveCON
                lineCol = 'c';
        end
    else
        lineCol = 'm';
    end
    
    fprintf('\nLoading %s. Please wait...\n\n', fileName)
    
    % Import data
    fullData = importDriveCSV(fullfile('data', fileName));
    
    fprintf('\nProcessing data.\n\n')

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
        plot(fig, extractedData.Elapsedtimesec, extractedData.Distancetravelledfeet, lineCol, extractedData.Elapsedtimesec, dummyDistance, 'k');
    end
    
    % Locate and extract crossing point for each participant
    [x,y] = intersections(extractedData.Elapsedtimesec, extractedData.Distancetravelledfeet, extractedData.Elapsedtimesec, dummyDistance);
    [~, ix] = min(abs(fullData.Distancetravelledfeet - y));
    
    % Check if timeRange or distanceRange is specified
    if ~isempty(DS_constants.timeRange)
        searchCol = 1;
        lowerLimit = fullData{ix,searchCol} - DS_constants.timeRange;
        upperLimit = fullData{ix,searchCol} + DS_constants.timeRange;
    elseif ~isempty(DS_constants.distanceRange)
        searchCol = 2;
        lowerLimit = fullData{ix,searchCol} - DS_constants.distanceRange;
        upperLimit = fullData{ix,searchCol} + DS_constants.distanceRange;
    else 
        error('Time or Distance range is required. Please check the drivingSim_constants.m file')
    end
    
    
    % Find index for start and end of data to be saved
    startIdx = find(fullData{:,searchCol} >= lowerLimit,1);
    endIdx = find(fullData{:,searchCol} >= upperLimit,1);
    
    % Add indcator line to plot?
    
    % Extract portion of data
    data2Save = fullData(startIdx:endIdx,:);
    
    writetable(data2Save, fullfile(DS_constants.outputDir, sprintf('%s_extractedData.csv', participantID)));
    
    fprintf('\nData extracted and saved\n\n')
    
    % Save crossing point row number to output variable
    DS_output(file_n,:) = {participantID, ix + 1, fullData.Elapsedtimesec(ix), fullData.Distancetravelledfeet(ix)};
    
end

if DS_constants.drawPlots
    hold off
    xlabel('Time (seconds)')
    ylabel('Distance travelled (feet)')
    % Save plot?
end

% Write output variable to file
writetable(cell2table(DS_output, 'VariableNames', {'Participant_ID', 'Intersection_row', 'Intersection_time', 'Intersection_dist'}),...
           DS_constants.outputFilename);