function moveDots_inSquare_boundary(startclut,allPosPix, wPtr,trialAngle)
global params; 
Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



for frame=1:params.stim.durInFrames      
    allDots = [allPosPix.x(:,frame), allPosPix.y(:,frame)]';
    allDots = allDots-repmat(params.screenVar.centerPix', 1, size(allDots,2));
    c = params.screenVar.centerPix;
    r = params.stim.radiusPix;
    %Screen('FillOval', wPtr ,[250 0 0], round([c(1)-r c(2)-r c(1)+r c(2)+r]));
  
    Screen('DrawDots', wPtr, allDots, params.dots.sizeInPix, params.dots.color, params.screenVar.centerPix,1);
    fixation(wPtr);
    
    
    Screen('DrawingFinished',wPtr,0);
    Screen('Flip', wPtr,0,0); 
end 

if params.oval.fixation, fixation(wPtr); end; 
Screen('Flip', wPtr,0,0);

%%% older code for presenting a fixation within an oval for a central stim
% if params.oval.present, Screen('FillOval', wPtr, params.oval.color, params.oval.rectPix); end;
%    
%     if params.oval.fixation, fixation(wPtr); end; 
