function correctTrial = checkResp(resp, angleOffset)
global params;

angleIdx = find(angleOffset == [-1,1]);
respIdx = find(resp.key(1) == params.responseVar.allowedRespKeysCodes);


if resp.check == 0
    correctTrial = 2;
elseif resp.check == 1
    if angleIdx == respIdx
        correctTrial = 1;
    else
        correctTrial = 0;
    end
end

% correctTrial;


end