classdef drivingSim_constants < handle
    
    properties (Constant)
    
        % Point at which vehicle is created in feet
        createPoint = 5000;
        
        % Position where vechicle is created in feet
        startPoint = 6000;
        
        % Position where vechile is destroyed in feet
        endPoint = 4000;
        
        % Velocity of vehicle in feet/s
        velocity = 30;
        
        % Sample rate of he simulation (May not be needed)
        sampleRate = 30;
        
        
        % Set to true for data plots, false to switch plots off
        drawPlots = true;
        
        % set to true if you want to set line colour by group, set false if
        % you want to have individual line colours 
        plotGroups = true;
        
        
        % For the range variables below use [] to indicate when they are
        % not in use
        
        % Time range (in seconds) to extract data from around the crossing point
        timeRange = 1
        
        % distance range (in feet) to extract data from around the crossing point
        distanceRange = []
        
        % Variable for setting filename
        outputFilename = 'DS_output.csv';
        outputDir = 'extractedData';
        
        % Leading number for the different condtion types
        driveDCD = '0'
        nodriveDCD = '1'
        driveCON = '2'
        nodriveCON = '3'
        
        % Plot variables
        
        
    end
    
end

