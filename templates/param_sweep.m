%% Clean Workspace

clear all
close all
clc
tic

%%  Add Paths

%%  Sweep Arrays
    % define some arrays of the value combinations you want here

%% Input Files

cfgFile = 'vicrt_cdb.cfg';
systemFile = 'mdids://VI_Racer_2020/systems.tbl/VI_Racer_CV.xml';
baseFingerprint = ;

%% Create Temporary Folder and Generate System Structure
modelDirFiles = ;
cfg = createCfg(cfgFile);
systemStruct = generateSystemStruct(systemFile,cfg,modelDirFiles);
systemStruct.output.xmlFlag = 1;

%% Start Loop

Simulations_Remaining = length( variable here );

for i = 1:length( variable here)
    
    %% Simulations Remaining Counter
    display(Simulations_Remaining)
    Simulations_Remaining = Simulations_Remaining - 1;
    
    %% Define Keys and Attributes for variable parameters
        % Open the model files as text files from working directory to see the key names
        
    keys{1,1} = ''; % overarching parameter section e.g. CRTAerodynamicForces
    keys{2,1} = ''; % "name" attribute of that parameter section
    attributes = {''}; % actual parameter you want to change e.g. front downforce scale
    values = {array_of_values(i)}; % must be a string!
    systemStruct = bodySetValue(systemStruct,keys,attributes,values);
        
    % copy and paste the above chunk as many times as attributes you
    % want to change
    
    %% Set Working Directory, Results File Suffix, and Run Fingerprint
    
    workingDir = modelDirFiles;
    outSuffix = strcat('descriptive_suffix',num2str(cla(i)));
    [successFlag, outputNameList]=runViCrt(baseFingerprint,systemStruct,outSuffix,workingDir)
    
    %% Load Lap Time and plot
    load(char(strcat(outputNameList,'.mat')))
    
    lap_time(i) = time(end);
    display(time(end),'lap time')
    
    close all
    figure
    scatter(variable_name(1:i),lap_time(1:i),'filled')
    title('Lap time vs ____')
    xlabel('param changed')
    ylabel('time (s)')
    grid on
    
    %% End Loop
    display('==================================================')
end

%% End Script

display('Done')
toc
    
    
    
    
    