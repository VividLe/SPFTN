function weightmat=pixhingeloss(supproimg,salmat)
%

[imrows,imcols,~]=size(supproimg);
% matweisize=56;

supgt=logical(supproimg);
supgt=double(supgt);
% supgt=imresize(supgt,[imrows,imcols],'bilinear');
%标记正负样例
supgt(supgt==0)=-1;
% supgt(supgt>0)=1;
aload=salmat;
salscores=aload.salmap_s;
salscores=imresize(salscores,[imrows,imcols],'bilinear');

hingelossmat=1*ones(imrows,imcols)-supgt.*salscores;
%hingeloss
hingelossmat(hingelossmat<0)=0;

%选前80%进行训练
gamma=0.2;
choper=0.8;
weightmat=zeros(imrows,imcols);
negpos=1;
weightmat=pixweight(supgt,hingelossmat,weightmat,gamma,choper,negpos);
negpos=-1;
weightmat=pixweight(supgt,hingelossmat,weightmat,gamma,choper,negpos);


end

