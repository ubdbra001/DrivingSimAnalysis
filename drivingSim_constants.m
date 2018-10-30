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
        drawPlots = false;
        
        timeRange = 1
        
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

