 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      screen params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenVar = struct('num', {1}, 'rectPix',{[0 0  1280 960]}, 'dist', {57}, 'size', {[40 30]},...
                   'res', {[1280 960 ]},'monRefresh', 85, 'calib_filename', {'0001_titchener_130226.mat'}); 
screenVar.centerPix = [screenVar.rectPix(3)/2 screenVar.rectPix(4)/2];
white = 255; black = 0;

gray = (white+black)/2; 
screenVar.bkColor = gray; screenVar.black = black; screenVar.white = white;
% Compute deg to pixels ratio:
ratio = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, [1 1]);
ratioX = ratio(1); ratioY = ratio(2);
screenVar.degratioX = ratioX; screenVar.ppd = ratioX; 
screenVar.degratioY = ratioY; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            fixation params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw fixation cross, sizeCross is the cross size,
% and sizeRect is the size of the rect surronding the cross
fixationVar = struct( 'color',{[black black black 255]},'dur', {0.5}, 'penWidthPix', {2.5}, 'bkColor', screenVar.bkColor,...
                      'sizeCrossDeg', {[0.2 0.2]}, 'colorDisc', {[black black black 255]},'present2ndFix',{1}); 
fixationVar.sizeCrossPix = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, fixationVar.sizeCrossDeg); % {15}
fixationVar.rectPix = [0 0 fixationVar.sizeCrossDeg(1)*screenVar.degratioX fixationVar.sizeCrossDeg(2)*screenVar.degratioY];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      stimuli params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stim = struct('dur', {.2}, 'possibleAngels', {[-1 1]},'boundaryAngle', {[0 0]},...
              'radiusDeg',{3}, 'bkColor', {gray}, 'speedDegPerSec', {15},'lifetime', {1},...
              'limitLifetime', {0.05},'apertureCenter',[-5,0,-5,0]);
% [3 357 183 177]
%cw/ccw: Note, response is encoded in responseVar.cw_ccw = [1 2]. Any changes must be done there as well
stim.cw_ccw = [1, 2]; %CW (1) or CCW (2) from the boundary, for example 3deg is CCW from 0deg


stim.boundaryAngleRad = stim.boundaryAngle*pi/180;
% speed = visual degreee per per second; num =# of dots; coh=propotion moving in designated direction; 
% diam = diameter of circle of dots in visual degrees; lifetime = logical, are dots limited life time or not
% limitLifetime = proportion of dots which will be randomly replaced in  each frame

stim.radiusPix = deg2pix1Dim(stim.radiusDeg, ratioX);
stim.durInFrames = round(stim.dur*screenVar.monRefresh);
stim.apertureCenterPix = [stim.apertureCenter(1)*screenVar.degratioX, stim.apertureCenter(3)*screenVar.degratioY];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Stair params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stimValsRangeREAL = [.1,25];
stimValsRangeSTAIR = [stimValsRangeREAL(1)/stimValsRangeREAL(2),1];
numStimVals = 200;
numAlphaRange = 100;


priorAlphaRange = linspace(stimValsRangeSTAIR(1),stimValsRangeSTAIR(2),numAlphaRange);
priorBetaRange = 0:10;
priorLambdaRange = 0:.01:.1;
gamma = .5;


stairVars = struct('stimRange',stimValsRangeSTAIR,'stimRangeDisplay',stimValsRangeREAL,...
                   'priorAlphaRange',priorAlphaRange,...
                   'priorBetaRange',priorBetaRange,...
                   'gamma',gamma,'lambda',priorLambdaRange,...
                   'PF',@PAL_Weibull,'marginalize',[4,2],...
                   'AvoidConsecutive',1,'WaitTime',4,'numTrials',60,'numStairs',3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Dot params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dots = struct( 'color',{black},'sizeInPix', {4});
numdotsperdeg = 3; %1.65
dots.num = round(numdotsperdeg*(pi*(stim.radiusDeg)^2)); % 1 dot per deg/deg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Oval within dots params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oval = struct('radiusDegSize',{.75}, 'color',{[gray gray gray 255]});
xoval = oval.radiusDegSize*ratioX; 
yoval = oval.radiusDegSize*ratioY; %radius
oval.rectPix = [screenVar.centerPix(1)-xoval, screenVar.centerPix(2)-yoval, screenVar.centerPix(1)+xoval, screenVar.centerPix(2)+yoval];
oval.present = 1; %whether to present the black oval within the circle of dots
oval.fixation = 1; %whether to present a fixation in the oval or not


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     response params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbName('UnifyKeyNames');
responseVar = struct( 'allowedRespKeys', {['1', '2']}, 'dur',{1.5},'keyEscape', 'ESCAPE', 'percentEstimation', {0});
responseVar.cw_ccw = [1 2]; %6 up, 3 down

for i = 1:length(responseVar.allowedRespKeys)
    responseVar.allowedRespKeysCodes(i) = KbName(responseVar.allowedRespKeys(i));
end
% Note that the correctness of the resp will be computed according to the
% index in the array of resp so that allowedRespKeys(i) is the correct
% response of stim.possibleAngels(i)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      PreCue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preCueVars = struct('dur', .1,'vertDistDeg',1);

preCueVars.horizDistDeg = (stim.speedDegPerSec/2)*preCueVars.dur;

preCueVars.vertDistPix = ratioY*preCueVars.vertDistDeg;
preCueVars.horizDistPix = ratioX*preCueVars.horizDistDeg;

preCueVars.durInFrames = round(preCueVars.dur*screenVar.monRefresh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      neutral PreCue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

neutralCue = struct('rectDeg', {[0.2, 0.1]}, 'color',{black}, 'bkColor', {screenVar.bkColor}, ...
                   'dur', {0.06}, 'penWidthPix', {1}, 'dist2centerDeg', {0.9}); 
sp1 = deg2pix1Dim(neutralCue.rectDeg(1), ratioX); sp2 = deg2pix1Dim(neutralCue.rectDeg(2), ratioY); 


neutralCue.dist2centerPix = deg2pix1Dim(neutralCue.dist2centerDeg, ratioY);

neutralCue.locationsPix1 = [screenVar.centerPix(1), (screenVar.centerPix(2) - neutralCue.dist2centerPix)];
neutralCue.locationsPix2 = [screenVar.centerPix(1), (screenVar.centerPix(2) + neutralCue.dist2centerPix)];

neutralCue.rectPix = [0 0 sp1 sp2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Block params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blockVars = struct('numBlocks', 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Trial params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trialVars = struct('numTrialsPerBlock', {180}); %total number of trials in a blocks
% if mod(trialVars.numTrialsPerBlock,length(stim.possibleAngels))~=0
%     error('number of trials must be a multiplication of the possible angles');
% end
trialVars.numTrialstotal = trialVars.numTrialsPerBlock * blockVars.numBlocks;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Save Data params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveVars = struct('fileName', {'motionExp'}, 'expTypeDirName', {'EstiDisc'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Text params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textVars = struct('color', black, 'bkColor', gray, 'size', 24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ISI params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISIVars = struct('postDur', {0.05},'preOrder',2);

switch ISIVars.preOrder
    case 1
        ISIVars.preDurVect = [0.05,  0.250, 0.450]; % short, medium, long
    case 2
        ISIVars.preDurVect = [0.250, 0.450, 0.05];  % medium, long, short
    case 3
        ISIVars.preDurVect = [0.450,  0.05, 0.250]; % long, short, medium
    case 4
        ISIVars.preDurVect = [0.05,  0.450, 0.250]; % short, long, medium
    case 5
        ISIVars.preDurVect = [0.250,  0.05, 0.450]; % medium, short, long
    case 6
        ISIVars.preDurVect = [0.450, 0.250, 0.05];  % long, medium, short
    otherwise
        error('SOA order by block set incorrectly')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Feedback params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fbVars = struct('dur', {0.1}, 'high', {1250}, 'low', {200}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     eye params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eye = struct('run',{0}, 'fixCheck',{0}, 'fixRequiredSecs', {0.2}, 'fixCheckRadiusDeg', {2},...
                'fixLongGoCalbirate', {2}); 
% record (1) or not to record (0)
%If recording set that there will be a second fixation because transfering
%the files takes time and we want to present a fixation when that happens
eye.fixCheckRadiusPix = ratioX*eye.fixCheckRadiusDeg;


%-------------------------------------------------------------------------%
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%                        TOTAL ALL params                                 %
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%-------------------------------------------------------------------------%

global params;
params = struct('screenVar', screenVar, 'trialVars', trialVars, 'blockVars', blockVars, 'saveVars', saveVars,...
                'fixationVar', fixationVar,'textVars',textVars, 'responseVar', responseVar, 'fbVars', fbVars,...
                'stim', stim, 'ISIVars', ISIVars, 'dots', dots, 'eye', eye, 'oval', oval,...
                'stairVars',stairVars,'preCueVars',preCueVars,'neutralCue',neutralCue); 
cl = 1;
if cl
    clear white gray black locationL locationR screenVar stim fixationVar precueExg box postCueVar responseVar ;
    clear trialVars i blockVars fbVars ratio ratioX ratioY sp1 sp2 rc1 ISIVar sqslope hfslp neutralCue boundary stair;
    clear saveVars textVars preCue screenInfo mouse dotInfo eye xres yres test xoval yoval oval dots cl outerRadiusDeg;
end
    