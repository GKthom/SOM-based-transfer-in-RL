function  [out] = parameters()

a=30;
b=30;
%%%%%%%%%%%%%%%%%%%%%%%%%
addnl_tasks=    [1.4055   24.8887
    4.9008    3.9925
   16.3863   26.9633
   10.4780    8.0296
   24.7374    5.4752
   16.9458   18.9034
   12.7708   14.9737
   26.5955    2.6626
   13.6741    7.5696
   23.0567   27.4859
   10.7489    9.9815
   21.1888   27.2683
   14.7937   15.7880
    8.4829    3.6915
   27.3230   14.0946
   28.7881   13.1627
   10.4744    3.1633
   20.3086   21.6632
   13.9382   10.9132
   21.3708   26.6718
   19.3941    4.5285
   26.6118    4.2264
   24.4367   26.1004
    5.8079   10.1116
   26.5605   11.1528
   28.5052   19.3333
   24.2648   26.3999
    9.9252    9.6226
   14.9475   11.1715
   23.6824   13.8519
    7.1422   12.1433
   21.6239    7.0645
   15.2003    8.7005
   19.2300    8.7695
   15.7691   23.1289
   23.6651   23.0136
   25.9425   26.4634
   24.0861   26.9511
   10.9477   21.4426
   12.7905    7.0871
    9.1697    4.0324
   24.5878   22.7258
   11.9915   11.1654
   15.7803   16.5045
   12.0093    2.1030
   23.9769   26.6666
    4.6918    1.7405
   24.3029    5.5643
   15.7170    9.7506
   24.2792   16.3812
   16.0857   27.5555
    6.6650    9.5038
   11.4539   12.6531
    2.2222    1.7898
   20.7647   24.8652
   21.4259    3.2579
   25.0446   23.3100
    8.0583   28.0745
    5.6798    5.0422
    1.1972   18.9572
   25.0511   10.9837
   19.7799    1.1304
   14.4387    7.1267
   15.7179   21.2354
   25.5013    2.9498
    4.5597    5.9956
   21.6366   15.5295
   19.3668   25.7795
   11.3101   16.0354
   17.8378   18.8192
   18.0559    1.0241
   21.7292    7.1643
   23.7456   20.2843
    4.7567   16.6171
    7.2109   10.0895
   12.4638    2.6100
    5.1768   20.5802
   19.4973    9.5923
   21.3030   14.8161
   25.3392   15.2799
   14.7812   24.8674
   14.4710   17.1812
    6.4353   27.6211
    5.8869    7.2878
    5.7321   11.9138
   19.3685   18.3303
   11.3211    3.3682
   13.4006    7.2380
   26.2939   21.0651
    1.9348    5.8168
   19.4142   22.8945
   20.3952   23.2083
   17.9339   11.2363
   17.6622   17.6743
   18.6813   12.6175
    1.2921   13.4110];%ones(96,2)+(p.a-2)*rand(96,2);
parameters.G_T=0.3;
parameters.addtargs=addnl_tasks;
parameters.std_dev_tol=1;
parameters.init_var=1;
%%%%%%%%%%%%%%%%%%%%%%%%%
parameters.reward_inds=4;
parameters.min_SOM_update=0.1;
parameters.squashparam=20;
parameters.transfer_thresh=0.9;
parameters.initialtasks=1000;
parameters.N_runs=1;
parameters.initlearn=500;
% parameters.N_somQlearnupdates=1000;
parameters.N_SOM=4;
parameters.SOM_iter=1000;
parameters.nfeats_a=30;
parameters.nfeats_b=30;
parameters.min_a=1;
parameters.min_b=1;
parameters.max_a=30;
parameters.max_b=30;
parameters.target_thresh=1;
%Q learning parameters%%
parameters.alpha=0.3;
parameters.lambda=0.9;
parameters.gamma=0.9;
parameters.epsilon=0.3;
parameters.highreward=100;
parameters.penalty=-100;
parameters.livingpenalty=-10;%-10;
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%World and agent parameters
parameters.a=a;
parameters.b=b;
parameters.N_iter=1000;
parameters.tran_prob=0.8;
parameters.A=9;
parameters.target=[28,28];%[28,2];
parameters.target2=[21,7];%[3,28];%[28,2];
parameters.target3=[3,29];%[20,5];
parameters.target4=[26,27];
start=[randi(a) randi(b) rand*360];
% start=[7 8 0];
%%%%%World%%%%%%
world=zeros(a,b);
world(:,1)=1;
world(1,:)=1;
world(:,end)=1;
world(end,:)=1;
% % % world(5:10,10)=1;
% % % world(10,1:10)=1;
% % % world(1:5,26:28)=1;
%%%%%%%%%%%%%%
% while world(start(1),start(2))==1||(start(1)==parameters.target(1)&&(start(2)==parameters.target(2)))
%     start=[randi(a) randi(b) rand*360];
% end
parameters.start=start;
parameters.world=world;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=parameters;