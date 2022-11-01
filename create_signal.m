%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate forward signals
% output: signalMat: sample number -by  detector number
%         distanceMat: detector number by voxel number
%            stores the distances [voxel] between detectors and voxels
% input   disMat_scl: distance matrix [voxel] 
%         true_object:  x- by y- by- z volume 
%            
%         nSamp: number of samples
%
% Author: Jingjing Jiang jing.jing.jiang@outlook.com
% created on 2022.11.02
% modified  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function signalMat = create_signal(disMat_scl, true_object, nSamp)

[xd yd zd] = size(true_object);
true_object_list = reshape(true_object, xd*yd*zd,1);

[nDet nVoxel] = size(disMat_scl);
signalMat = zeros(nSamp, nDet);
    for jj = 1:nDet
        isample_bin = disMat_scl(jj,:);
        sig_tmp = ones(nSamp,1);
        for ii = 1:nVoxel
            id = isample_bin(ii); % sample id
            value_v = true_object_list(ii);
            sig_tmp(id) = sig_tmp(id) + value_v;
        end
        signalMat(:, jj) = sig_tmp;
    end
end