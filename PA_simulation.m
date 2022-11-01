%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PA simulation
% Author: Jingjing Jiang jing.jing.jiang@outlook.com
%  
% created on 2022.11.01
% modified  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create a true object
xd = 80;
% mask1 = abs(phantom3d(xd))>0.25;
% mask2 = abs(phantom3d(xd))<0.5;
% true_object = double(mask1 .* mask2) ;

true_object = abs(phantom3d(xd));

z_sel = 35;
h_fig = figure(1);
% true_object =ones(xd,xd,xd);
subplot(221)
imagesc(squeeze(true_object(:,:,z_sel)))
title('true')
axis square

%% read in acqusition information
fldr_PA = '../../PAT_Zhenyue/';
fn_sig = [fldr_PA 'rs_m1_730_750_800_850_900_800_sigMat_ave.mat'];
load(fn_sig)
p = acquisitionInfo.transducerPositions;
pc = acquisitionInfo.center;

voxel = acquisitionInfo.voxelSize;
v = acquisitionInfo.speedOfSound; % [m/s]
n_transducers= length(find(acquisitionInfo.activeChannels));

%% plot transducer positions and ROI in voxel coordinate
dir_list = p-pc;
[X,Y,Z]=meshgrid(1:xd,1:xd,1:xd); 
vCoord = [X(:) Y(:) Z(:)];
vCOORD = [vCoord-xd/2];
tCOORD = [dir_list'./voxel];

figure(h_fig)
subplot(223)
plot3(tCOORD(1,:), tCOORD(2,:), tCOORD(3,:), 'o')
hold on
plot3(vCOORD(:,1), vCOORD(:,2), vCOORD(:,3), 'ro') 
legend('transducers','ROI')
xlabel('x [voxel]')
ylabel('y [voxel]')
zlabel('z [voxel]')
%% distance Matrix 
disMat = get_distance_twoMat(tCOORD, vCOORD'); 
size(disMat)


% %% volume to list
% true_object_list = reshape(true_object, xd*xd*xd,1);

%% create a signal array
v = 1485; % acoustic velocity [m/s]
samplingFreq = 40000000;
voxel = 1e-4;% voxel size [m]
dr = v/samplingFreq; % [m]
dr_voxel = dr/voxel;
nSample = 140;
signal_mat = zeros(nSample, n_transducers);
nDelay = 900; % sample
voxelDelay = nDelay * dr_voxel;
disMat_scl = floor(disMat - voxelDelay);


%% generate signal
tic
signal_mat = create_signal(disMat_scl, true_object, nSample);
toc

figure(h_fig),
subplot(222)
imagesc(signal_mat)
title('signal')

%% simple FBP
tic
rec = FBP(signal_mat, disMat_scl, [xd, xd, xd], samplingFreq, v);
toc
rec_norm =rescale(rec);

figure(h_fig),
subplot(224)
imagesc(squeeze(rec_norm(:,:,z_sel)))
title('rec') 
axis square
%% visualization
h_fig2 = figure;
for zz =1:xd
    subplot(121)
     imshow(squeeze(true_object(:,:,zz)))
      title(num2str(zz))
    subplot(122)
    imshow(squeeze(rec_norm(:,:,zz)))
%     caxis([0 max(rec(:))])
        pause(0.1)
end

   

% %% MLEM BP reconstruction
% n_iterations = 10;
% rec_mlem = BP_MLEM(signal_mat, disMat_scl, [xd, xd, xd], ...
%     n_iterations,samplingFreq, v);
% 
% %%
% rec_mlem_norm = rescale(rec_mlem);
% figure
% 
% for zz =1:xd
%     subplot(121)
%      imshow(squeeze(true_object(:,:,zz)))
%       title(num2str(zz))
%     subplot(122)
%     imshow(squeeze(rec_mlem_norm(:,:,zz)))
% %     caxis([0 max(rec(:))])
%         pause(0.1)
% end

 