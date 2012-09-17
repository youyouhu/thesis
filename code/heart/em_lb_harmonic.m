function [glb] = EM_LB_Harmonic(p,m0T,gi,N,I1,I2,I3)
% em_lb_harmonic - score function evaluation 
%
% parameters are 
% p(1)=qw,    angular velocity variance
% p(2)=r,     measurement variance
% p(3:3+c-1)  the signal component variances
global m0 P0 c

qx = p(3:end);
if numel(p) < c+2
  qx = [qx repmat(p(end),1,c+2-numel(p))];
end

Q = sinusoid_Q(p(1),qx);
R = p(2);



% gradient

% in the case that numel(qx) == num of components,
% we will put each dlb/dqx(i)
% one after the other in glb
% otherwise we will have just dlb/dqx(1)


% expand the "3" in gi to c*"3"
% if sum(gi==3) == 1 && numel(p) == c+2
%     glb = zeros(numel(vi)+c-1,1);
%     vii = glb;
%     qi = find(vi==2);
%     if (qi > 1)
%         vii(1:(qi-1)) = vi(1:(qi-1));
%     end
%     vii(qi:(qi+c-1)) = 2;
%     if qi < numel(vi) 
%         vii((qi+c):end) = vi(qi:end);
%     end
%     dqxi = eye(c);
% else % the qx variances are the same for all components
%     glb = zeros(numel(vi),1);
%     vii = vi;
%     dqxi = ones(1,c);
% end

%ri = 1; % another counter
glb = zeros(numel(gi));
for j=1:numel(gi)
      % assume all zero
      dSig = zeros(size(P0)); 
      dQ = zeros(size(Q));dR = zeros(size(R));
      dmu = zeros(size(Q,1),1);
    
    if(gi(j)==1) % dlb/dqw
        dQ = zeros(size(Q));
        dQ(1,1) = 1;
    end
    if(gi(j) >= 3) % dlb/dqx(ri)
        %dQ = sinusoid_Q(0,dqxi(ri,:),dt);
        %ri = ri + 1;
        if sum(gi>=3) > 1
          wh = zeros(1,c);
          wh(gi-2) = 1;
          dQ = sinusoid_Q(0,wh);
        else  
          dQ = sinusoid_Q(0,ones(1,c));
        end
    end
    if(gi(j)==2) % dlb/dr
        dR = 1;
    end
    
    % x_0
    glb1 = P0\(dSig/P0*I1+2*dmu*(m0T-m0)'-dSig);
    % x_k|x_(k-1)
    glb2 = Q\(dQ/Q*I2-N*dQ);
    % y_k|x_k
    glb3 = R\(dR/R*I3-N*dR);

    glb(j) = 0.5*(trace(glb1)+trace(glb2)+trace(glb3));
end


end



