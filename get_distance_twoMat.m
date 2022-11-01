%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to calculate a distance between two non-paired vector lists
% Author: Jingjing Jiang jing.jing.jiang@outlook.com
%  
% created on 2022.11.01
% modified  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function disMat = get_distance_twoMat(A, B)
m = size(A,2);
n = size(B,2);
% m = 546
% n = 1e6
% Agpu = rand(3,m,"gpuArray");
% Bgpu = rand(3,n,"gpuArray");
Agpu = gpuArray(A);
Bgpu = gpuArray(B);
M = zeros(m,n,"gpuArray");
 
% tic
for ii = 1:m
    aa = Agpu(:,ii);
    dis = sqrt(sum((Bgpu - aa).^2));
    M(ii,:) = dis;
end
% toc
disMat = gather(M);

end