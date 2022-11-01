%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simple FBP for PAT
% output: rec: reconstructed 3D volume 
% input:  signalMat: sample number -by  detector number
%         distanceMat: detector number by voxel number
%            stores the distances [voxel] between detectors and voxels
%         dim:  x by y by z
%            volume dimension
%         fs: sampling frequency [Hz]
%         v: acoustic velocity [m/s]
% Author: Jingjing Jiang jing.jing.jiang@outlook.com
% created on 2022.11.01
% modified  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rec = FBP(signalMat, distanceMat, dim, fs,v)
    [nSamp nDet] = size(signalMat);
    
    % create filter
    N = 2048;
    f1 = fs/2 .*linspace(0,1, floor(N/2+1));
    f2 = -fliplr(f1);   
    f2 = f2(2:end-1);

    filtRamp = [f1,f2 ];  %ramp filter 
    k = 2*pi.*filtRamp/v; % wave vector
    k = k'; 
    
% figure,
% subplot(221)
% plot(fv)
% subplot(222)
% plot(fv2)
% subplot(223)
% plot(filtRamp)
% subplot(224)
% plot(k)
    bp=0;
    for ii = 1: nDet
        p = signalMat(:, ii);
        pfft = fft(p,N);
        pFilt = ifft(-1j.*k .*  pfft);
        pFilt = real(pFilt(1:nSamp));
    %     figure(101)
    %     plot(p./mean(p))
    %     hold on
    %     plot(pf ./mean(pf))

        isample_bin = distanceMat(ii,:);
        sig_tmp = pFilt(isample_bin);

        bp =bp + sig_tmp;
%         figure(1)
%         subplot(233)
%         rec=reshape(bp,dim(1),dim(2),dim(3));
%         imagesc(squeeze(rec(:,:,z_sel)))
%         title(['+ id ' num2str(ii)])
%         axis square
    %     pause(0.01)
    end
    rec = reshape(bp,dim(1),dim(2),dim(3));
end