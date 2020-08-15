function [composition strainrate trial compositiondims stbmatrix err] = gatherVideoData;
analysisdata = importdata('Video Analysis - Data.tsv');
trialbytrial = analysisdata.textdata;
metadata = analysisdata.data;

composition = rmmissing(trialbytrial(2:end,2));
strainrate = rmmissing(trialbytrial(2:end,3));
stbstd = rmmissing(metadata(:,4));
trial = trialbytrial(2:end,4);
avgstb = rmmissing(metadata(:,3));
compositiondims = size(unique(composition));

stbmatrix = zeros(compositiondims(1),4);
err = zeros(compositiondims(1),4);
index = 1;
for r = 1:size(stbmatrix,1)
    for c = 1:size(stbmatrix,2)
        stbmatrix(r,c) = avgstb(index);
        err(r,c) = stbstd(index);
        index = index + 1;
    end
end
return;
