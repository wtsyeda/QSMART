%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%     Reads Bruker 3D MGE MRI fid data into Matlab       %
%                                                        %
%                    David Wright                        %
%                                                        %
%              Called by BrukerReader.m                  %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image, param]=Bruker_MGE_3D(datapath)

acqpfile=fopen([datapath,'/acqp']);
acqp=fread(acqpfile,'*char')';
fclose(acqpfile);
clear acqpfile;

param.dimensions=3;
param.sequence='MGE';
acqp2=acqp;
clear acqp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                 Get Matrix Size                        %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matrixsize=strfind(acqp2,'ACQ_size=(');
matrixsize1=matrixsize+15;
tt=acqp2(matrixsize1);
while (tt~='$' && tt~='#')
   matrixsize1=matrixsize1+1;
   tt=acqp2(matrixsize1);
end
param.matrix=str2num(acqp2(matrixsize+15:matrixsize1-1));
clear matrixsize1 matrixsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                 Get Read Extension                     %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

readext1=findstr(acqp2,'##$ACQ_read_ext=');
readext2=readext1+16;
tt=acqp2(readext2);
while (tt~='#' & tt~='$')
   readext2=readext2+1;
   tt=acqp2(readext2);
end
readextstr=acqp2(readext1+16:readext2-1);
re=str2num(readextstr);
param.matrix(1)=param.matrix(1)/(2*re);
clear readext1 readext2 readextstr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                 Get Phase Offset                       %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phaseshift1=findstr(acqp2,'##$ACQ_phase1_offset=(');
phaseshift2=phaseshift1+21;
tt=acqp2(phaseshift2);
while (tt~=')')
    phaseshift2=phaseshift2+1;
    tt=acqp2(phaseshift2);
end
start=phaseshift2+1;
tt=acqp2(start);
while (tt~=' ' & tt~='#' & tt~='$')
    phaseshift2=phaseshift2+1;
    tt=acqp2(phaseshift2);
end
phaseshiftstr=acqp2(start:phaseshift2-1);
phoffset1=str2num(phaseshiftstr);
clear phaseshift1 phaseshift2 phaseshiftstr tt start;

phaseshift1=findstr(acqp2,'##$ACQ_phase2_offset=(');
phaseshift2=phaseshift1+21;
tt=acqp2(phaseshift2);
while (tt~=')')
    phaseshift2=phaseshift2+1;
    tt=acqp2(phaseshift2);
end
start=phaseshift2+1;
tt=acqp2(start);
while (tt~=' ' & tt~='#' & tt~='$')
    phaseshift2=phaseshift2+1;
    tt=acqp2(phaseshift2);
end
phaseshiftstr=acqp2(start:phaseshift2-1);
phoffset2=str2num(phaseshiftstr);

param.phoffset=[phoffset1 phoffset2];

clear phaseshift1 phaseshift2 phaseshiftstr tt start phoffset1 phoffset2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                  Get Slice Offset                      %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sliceoffset1=strfind(acqp2,'##$ACQ_slice_offset=(');
sliceoffset2=sliceoffset1+20;
tt=acqp2(sliceoffset2);
while (tt~=')')
    sliceoffset2=sliceoffset2+1;
    tt=acqp2(sliceoffset2);
end
start=sliceoffset2+1;
tt=acqp2(start);
while (tt~=' ' & tt~='#' & tt~='$')
    sliceoffset2=sliceoffset2+1;
    tt=acqp2(sliceoffset2);
end
param.sliceoffset=str2num(acqp2(start:sliceoffset2-1));
clear sliceoffset sliceoffset2 sliceoffset1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                     Get FOV                            %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fov1=strfind(acqp2,'##$ACQ_fov=( ');
fov2=fov1+16;
tt=acqp2(fov1+16);
while (tt~='#' & tt~='$')
   fov2=fov2+1;
   tt=acqp2(fov2);
end
param.fov=(str2num(acqp2(fov1+16:fov2-1))).*10;
param.resolution=param.fov./param.matrix;
clear fov1 fov2;
clear acqp1 acqp2 acqpfid acqpfile L tt start;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                    Load Method                         %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

methodfile=fopen([datapath,'/method']);
method=fread(methodfile,'*char')';
fclose(methodfile);
clear methodfile;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                Get Number of Echoes                    %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

te1=findstr(method,'##$PVM_NEchoImages=');
te2=te1+19;
tt=method(te2);
while (tt~=')' & tt~='#' & tt~='$')
    te2=te2+1;
    tt=method(te2);
end
param.echoes=str2num(method(te1+19:te2-2));
clear te1 te2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                   Get Receivers                        %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rec1=findstr(method,'PVM_EncNReceivers=');
rec2=rec1+18;
tt=method(rec2);
while (tt~=')' & tt~='#' & tt~='$')
    rec2=rec2+1;
    tt=method(rec2);
end
param.coils=str2num(method(rec1+18:rec2-2));

clear rec1 rec2 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                   Get echo Times                       %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

te1=findstr(method,'##$EffectiveTE=(');
te2=te1+21;
tt=method(te2);
while (tt~=')' & tt~='#' & tt~='$')
    te2=te2+1;
    tt=method(te2);
end
param.echo_times=str2num(method(te1+21:te2-2));
clear te2 te1 method tt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%               load kspace (fid file)                   %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim_x=param.matrix(1);
dim_y=param.matrix(2);
dim_z=param.matrix(3);
coils=param.coils;
FOV=param.fov;
echoes=param.echoes;

infile=[datapath,'/fid'];
infid=fopen(infile,'r','ieee-le');
[buf,count] = fread(infid,'int32');
raw=complex(buf(1:2:count),buf(2:2:count));
clear infid infile buf count;

if size(raw,1)/(dim_x*dim_y*dim_z*coils*echoes)~=1
    zerofill=size(raw,1)/(dim_y*dim_z*coils*echoes);
    kspace=reshape(raw,[zerofill*coils,length(raw)/(zerofill*coils)]); 
    raw=kspace(1:(dim_x*coils),:);
end
clear kspace;

kspace=reshape(raw,[dim_x,coils,echoes,dim_y,dim_z]);
clear raw;

kspace=permute(kspace,[1,4,5,3,2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                      Reco Image                        %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image=zeros(size(kspace));
for k=1:echoes
    for l=1:coils
        datatemp=fftshift(ifftn(fftshift(squeeze(kspace(:,:,:,k,l)))));
        image(:,:,:,k,l)=datatemp;
    end
end

clear datatemp kspace;

ksp_shift = [param.phoffset(2), param.phoffset(1), -param.sliceoffset];
phasor = zeros(dim_x,dim_y,dim_z);

for i = 1 : dim_x
    for j = 1 : dim_y
        for k = 1 : dim_z
            phasor(i,j,k) = exp(-1i*2*pi*((i-dim_x/2)*ksp_shift(1)/FOV(1)...
                +(j-dim_y/2)*ksp_shift(2)/FOV(2) + (k - dim_z/2)*ksp_shift(3)/FOV(3)));
        end
    end
end

clear i j k ksp_shift FOV dim_x dim_y dim_z;

iField=zeros(size(image));
for k=1:echoes
    for l=1:coils
        iField(:,:,:,k,l) = ifftn(ifftshift(fftshift(fftn(squeeze(image(:,:,:,k,l)))).*phasor));
    end
end

clear image phasor k l coils echoes;

%image = conj(iField);
image=iField;

clear iField;

end
