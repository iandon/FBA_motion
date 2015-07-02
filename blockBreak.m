function blockBreak(wPtr, b)
global params;
if b>1
    instruct = sprintf('Block number %d ended. The experiment will start after a short break.', b-1);
    start=sprintf('Press space when ready, to start!');
    Screen('TextSize', wPtr, params.textVars.size);
    Screen('TextColor', wPtr, params.textVars.color);
    Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );

    Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2));
  
    Screen('Flip', wPtr);
    if b == 4
        WaitSecs(30)    
    else
        WaitSecs(15)
    end
    Screen('DrawText', wPtr, start, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2));
    Screen('Flip', wPtr);
    keyIsDown = 0;
    while (~keyIsDown)
        [keyIsDown,secs,keyCode] = KbCheck;
         if keyCode(kbname('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end   
    end
end