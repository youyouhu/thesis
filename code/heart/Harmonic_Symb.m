%% Discretize stochastic oscillator in closed form

syms w dt g Qx real;

g = 0;
w = 0;
F = [ 0  1; 
    -w^2  -g];
L = [0;1];
A = simple(expm(F*dt));
n   = size(F,1);
Phi = [F L*Qx*L'; zeros(n,n) -F'];
AB  = expm(Phi*dt)*[zeros(n,n);eye(n)];
Q   = simple(AB(1:n,:)/AB((n+1):(2*n),:));

%% test

w_r = 2*pi*2;
dt_r = 0.02;
g_r = 0.4;
Qc_r = 0.01;

[Ar,Qr] = splti_disc(subs(F,[w g],[w_r g_r]),L,Qc_r,dt_r)
subs(A,[w g dt],[w_r g_r dt_r])
subs(Q,[g dt Qc],[g_r dt_r Qc_r])

%% Jacobian of f

syms x1 x2 x3 dt j real

%diff(cos(dt*j*x1)*x2+(sin(dt*j*x1)/(j*x1))*x3,x1)
diff(-j*x1*sin(dt*j*x1)*x2+cos(dt*j*x1)*x3,x3)

%% M-step equations

syms N qw dt q1 q2 q3 positive;

Q11 = dt^2/3;
Q12 = dt/2;
Q22 = 1;

qx = [q1 q2 q3];
c = cell(1,3);
c{1} = qw;
for k = 1:numel(qx)
    c{k+1} = exp(qx(k))*dt*[Q11 Q12; Q12 Q22];
end

Q = blkdiag(c{:});
  
I = sym('I%d%d',[7 7]);
lbq = -0.5*trace(Q\I)-0.5*N*log(det(Q));

c = 3;
jj = (c-1)*2;

solve(diff(lbq,q3)==0,q3)

%solve(diff(lbq,qw)==0,qw)
sum(sum([1 dt;dt dt^2].*[6 -3; -3 2].*I(jj+2:jj+3,jj+2:jj+3)))/(N*dt^3)

%% shared case

qx = [q1 q1 q1];
c = cell(1,3);
c{1} = qw;
for k = 1:numel(qx)
    c{k+1} = qx(k)*dt*[Q11 Q12; Q12 Q22];
end

Q = blkdiag(c{:});
  
I = sym('I%d%d',[7 7]);
lbq = -0.5*trace(Q\I)-0.5*N*log(det(Q));
ans1 = solve(diff(lbq,q1)==0,q1);

ans2 = 0;
for c=1:3
  jj = (c-1)*2;
  ans2 = ans2 + sum(sum([1 dt;dt dt^2].*[6 -3; -3 2].*I(jj+2:jj+3,jj+2:jj+3)));
end

ans1-ans2/(3*N*dt^3)

%% wq

solve(diff(lbq,qw)==0,qw)

%% r







