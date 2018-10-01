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
        
        % Variable for setting filename
        outputFilename = 'DS_output.csv';
    end
    
end

