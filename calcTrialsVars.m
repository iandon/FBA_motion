function procedure = calcTrialsVars(blockNum)
global params;  
numTrials = params.trialVars.numTrialsPerBlock; % should be 180




numRepeats = 15; %how many times does each trial type repeat?
                 %2 horiz directions * 2 vert directions * 3 cue types = 12
                 %3 staircases, 60 trials each = 180 trials
                 %180 / 12 = 15




horizDirPossible = [180,0]; % L vs R
vertDirPossible  = [-1,1]; % ccw vs cw
cueTypePossible  = [0,1,2];%neut vs valid vs invalid



[horizDir,vertDir,cueType,repeat] = ndgrid(horizDirPossible,vertDirPossible,cueTypePossible,1:numRepeats);

ord = randperm(numTrials);

horizDir = horizDir(ord);
vertDir  = vertDir(ord);
cueType  = cueType(ord); %also will be the stairNum

SOA = repmat(params.ISIVars.preDurVect(blockNum),[numTrials,1]);


cueDir = nan(size(horizDir));
ansResp = nan(size(horizDir));
for i = 1:numTrials
    
    %Validity of the cue is dependent on the direction of the cue &
    %stimulus -> match if valid, mismatch if invalid, and no movement if
    %neutral
    if cueType(i) == 0 %neut -> neut cue
        cueDir(i) = 0;
    elseif cueType(i) == 1 %valid -> cueDir is same as horizDir
        cueDir(i) = horizDir(i);
    elseif cueType(i) == 2 %invalid -> cueDir is opposite from horizDir
        cueDir(i) = -1*horizDir(i);
    end
    
    %Answer of "up" vs "down" -> if moving right ward, a negative angle
    %(-2) relative to horizontal = up, positive = down; But for left ward
    %motion, a more positive angle (182) would be moving upward, negative =
    %downward
    if horizDir(1) == 0
        if vertDir(1) == 1
            ansResp(i) = 1; %up
        else
            ansResp(i) = 2; %down
        end
    elseif horizDir == 180
        if vertDir(1) == -1
            ansResp(i) = 2;%down
        else
            ansResp(i) = 1;%up
        end
    end
    
end
        
procedure = cell(numTrials,1);
for i = 1:numTrials
    procedure{i}.horizDir = horizDir(i);
    procedure{i}.vertDir  = vertDir(i);
    procedure{i}.cueType  = cueType(i);
    procedure{i}.cueDir   = cueDir(i);
    procedure{i}.ansResp  = ansResp(i);
    procedure{i}.stairNum = cueType(i)+1;
    procedure{i}.SOA = SOA(i);
    procedure{i}.trialIndex = i;
end