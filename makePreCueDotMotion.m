function preCueMotion = makePreCueDotMotion
global params


dxdy_dirc.right = params.stim.speedDegPerMsec * (1/params.screenVar.monRefresh) * [cos(0) sin(0)];

dxdy_dirc.left 	= params.stim.speedDegPerMsec * (1/params.screenVar.monRefresh) * [cos(pi) sin(0)];

% 
% q = rand(params.dots.num,1)*pi*2; 
% r = (rand(params.dots.num,1)).^0.5;
preCueMotion.right.x(:,1) = [-params.preCueVars.horizDistPix + params.screenVar.centerPix(1);
                             -params.preCueVars.horizDistPix + params.screenVar.centerPix(1)];
              
preCueMotion.left.x(:,1)  = [params.preCueVars.horizDistPix + params.screenVar.centerPix(1);
                             params.preCueVars.horizDistPix + params.screenVar.centerPix(1)];

allPos.y = [-params.preCueVars.vertDistPix + params.screenVar.centerPix(2);
             params.preCueVars.vertDistPix + params.screenVar.centerPix(2)];


for i =2:params.preCueVars.durInFrames
        preCueMotion.right.x(:,i) = preCueMotion.right.x(:,i-1)+dxdy_dirc.right(:,1);
        preCueMotion.right.y(:,i) = allPos.y;
        
        preCueMotion.left.x(:,i) = preCueMotion.right.x(:,i-1)+dxdy_dirc.left(:,1);
        preCueMotion.left.y(:,i) = allPos.y(1);
end



