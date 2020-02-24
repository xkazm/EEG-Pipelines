%% Plot the robust amplitudes before and after pipeline as scalp maps

%% Set up the file names and which methods
dataDir = 'D:\Research\EEGPipelineProject\dataOut';
imageDir = 'D:\Research\EEGPipelineProject\dataImages';
eegBaseFile = 'basicGuardSession3Subj3202Rec1';
%eegBaseFile = 'dasSession16Subj131004Rec1';
%eegBaseFile = 'speedControlSession1Subj2015Rec1';
%eegBaseFile = 'trafficComplexitySession1Subj2002Rec1';
methodNames = {'LARG', 'MARA', 'ASR_10', 'ASRalt_10', 'ASR_5', 'ASRalt_5'};
numMethods = length(methodNames);

%% Specify the formats in which to save the data
%figureFormats = {'.png', 'png'; '.fig', 'fig'; '.pdf' 'pdf'; '.eps', 'epsc'};
figureFormats = {'.png', 'png'};
figureClose = false;
%% Read in the files
eegs = cell(numMethods, 1);
for m = 1:numMethods
    fileName = [dataDir filesep eegBaseFile '_' methodNames{m} '.set'];
    eegs{m} = pop_loadset(fileName);
end

%% Specify the parameters parameters
channels = getCommonChannelLabels();
numChans = length(channels);
theColorMap = parula(20);
electrodeFlag = 'ptslabels';
axisLimits = [];

%% Now plot the before and after scalp maps
hFigsBefore = cell(numMethods, 1);
hFigsAfter = cell(numMethods, 1);
for m = 1:numMethods
    [EEG, missing, selectMask] = selectEEGChannels(eegs{m}, channels);
    if ~isempty(missing)
        warning('EEG is missing channels %s\n-- can not compute spectral fingerprints', ...
            getListString(missing, ','));
        continue;
    end
    beforeValues = EEG.etc.amplitudeInfoBefore.channelRobustStd(selectMask);
    afterValues = EEG.etc.amplitudeInfoAfter.channelRobustStd(selectMask);
    beforeTitle = [methodNames{m} ': robust amplitude before artifact removal'];
    afterTitle = [methodNames{m} ': robust amplitude after artifact removal'];
    hFigsBefore{m} = plotScalpMap(beforeValues, EEG.chanlocs, beforeTitle, axisLimits, ...
        theColorMap, electrodeFlag);
    hFigsAfter{m} = plotScalpMap(afterValues, EEG.chanlocs, afterTitle, axisLimits, ...
        theColorMap, electrodeFlag);
    
    baseFile = [imageDir filesep 'channelAmplitude_' methodNames{m}];
    saveFigures(h1Fig, baseFile, figureFormats, figureClose);  
end
