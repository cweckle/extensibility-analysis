function num = getCompositionNumber(name)
ans = gatherVideoData();
compositions = unique(ans,'stable');
idx = strfind(name,'_');
hpmc = name(1:idx(1)-1);
pegpla = name(idx(1)+1:idx(2)-1);
search = append(hpmc,'-',pegpla);
num = 0;

for k = 1:size(compositions,1)
    if strcmp(compositions{k},search) == 1
        num = k;
    end
end
return;