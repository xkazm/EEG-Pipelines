function [EEGNew, missing, selectMask] = selectEEGChannels(EEG, channels)
%% Creates a new EEG structure with only channels (in order specified)
%
%  Parameters:
%    EEG       EEG structure
%    channels  Cell array of channel labels to be selected
%    EEGNew    (output) EEG structure with only the specified channels 
%    missing   (output) Cell array of missing channel labels

%% Create the new EEG structure containing only specified channels
myLabels = {EEG.chanlocs.labels};
[commonChannels, ~, selectMask] = intersect(channels, myLabels, 'stable');
if length(commonChannels) ~= length(channels)
    missing = setdiff(channels, commonChannels);
else
    missing = '';
end
EEGNew = EEG;
EEGNew.chanlocs = EEGNew.chanlocs(selectMask);
EEGNew.data = EEGNew.data(selectMask, :);
EEGNew.nbchan = length(EEGNew.chanlocs);
   