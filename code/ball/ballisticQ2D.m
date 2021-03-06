function [ Q ] = ballisticQ2D( qx,qy,notransform)
global dt
if nargin < 3
   notransform = 0;
end

if ~notransform % by default it is assumed that input is in std
  %qx = exp(2*qx);
  %qy = exp(2*qy); % NOT CHANGED !!!!!
  qx = qx^2;
  qy = qy^2;
end
%   +-                -+
%   |       3       2  |
%   |  Qx dt   Qx dt   |
%   |  ------, ------  |
%   |    3       2     |
%   |                  |
%   |       2          |
%   |  Qx dt           |
%   |  ------,  Qx dt  |
%   |    2             |
%   +-                -+

    Q1 = [dt^2/3  dt/2;
          dt/2    1];
         
    Q = blkdiag(qx*dt*Q1,qy*dt*Q1);

end

