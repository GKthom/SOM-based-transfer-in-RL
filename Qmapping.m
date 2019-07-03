clear
close all
clc

load SOM_19sept
Qmap=[];
for i=1:30
    for j=1:30        
        Qmap(i,j)=0;
        for k=1:p.A
            Qmap(i,j)=Qmap(i,j)+Q_val([i j],k,ww{7},p);
        end
    end
end

Qmap=(Qmap-min(min(Qmap)));
Qmap=Qmap/max(max(Qmap));
imshow(imrotate(Qmap,90))