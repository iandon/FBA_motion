function audFB(correctTrial)
global params;

if correctTrial == 0
    beep2(params.fbVars.low,params.fbVars.dur)  
elseif  isnan(correctTrial) == 1
    beep2(params.fbVars.high,params.fbVars.dur)
end