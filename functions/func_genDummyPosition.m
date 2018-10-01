function output = func_genDummyPosition(startPoint, endPoint, velocity, sampleRate)

position = startPoint:-(velocity/sampleRate):endPoint;
time = round(0:1/sampleRate:(length(position)-1)/sampleRate,2);

output = table(time', position', 'VariableNames', {'Time', 'OncomingDistance'});