%% Load data
% rawdata = readtable('2015_IMS_ADS.csv');
rawdata = readtable('2015_IMS_ADS.nt.csv');

% Make the respondentIDs as the row names
rawdata.Properties.RowNames = rawdata.V1;
data = removevars( rawdata, {'V1'} );

%% remove all text features
% rmFeatrues = {};
% for feature = data.Properties.VariableNames
%    if contains( feature{1}, 'TEXT' ) % Remove text features. Deal with them later.
%        rmFeatrues(end+1) = feature;
%    end
% end
% data = removevars( data, rmFeatrues );

%% convert data
for feature = data.Properties.VariableNames
    fea = feature{1};
    if iscell( data.(fea) )
        temp = str2double( data.(fea) );
        if sum( isnan(temp) ) < length(temp)
            data.(fea) = temp;
        else
            data.(fea) = strtrim( data.(fea) );
        end
    end
end

%% count not nan
num = zeros(1, length(data.Properties.VariableNames));
for k = 1 : length(data.Properties.VariableNames)
    feature = data.Properties.VariableNames{k};
    if iscell( data.(feature) )
        num(k) = sum( ~isempty( data.(feature) ) );
    else
        num(k) = sum( ~isnan([data.(feature)]) );
    end
end

%% Convert NaN to -100, which may or may not help 
for k = 1 : length(data.Properties.VariableNames)
    feature = data.Properties.VariableNames{k};
    if ~iscell( data.(feature) )
        data.(feature)( ~isnan([data.(feature)]) ) = -100;
    end
end

%% Given the k-th feature, select samples whose k-th features are non-nan.
% Keep features containing at least 10 non-NaN values in the chosen samples.
selectedData = data;
feature = data.Properties.VariableNames{ 10 };
if iscell( selectedData.(feature) )
    sampleFlag = strcmp( selectedData.(feature), '' );
else
    sampleFlag = isnan( selectedData.(feature) );
end
selectedData(sampleFlag > 0, :) = [];

%%
mdl = fitctree( selectedData, 'W_2');