load SOM_eps07_new
w=ww{6};
p=parameters();
Qmap=[];
ii=0;
for i=p.min_a:((p.max_a-p.min_a)/p.nfeats_a):p.max_a
    ii=ii+1;
    jj=0;
    for j=p.min_b:((p.max_b-p.min_b)/p.nfeats_b):p.max_b
        jj=jj+1;
        kk=0;
        Qmap(ii,jj)=0;       
            for act=1:p.A
                Qmap(ii,jj)=Qmap(ii,jj)+Q_val([i j],act,w,p);
            end
    end
end

Qmap=(Qmap-min(min(Qmap)));
Qmap=Qmap/max(max(Qmap));
imshow(imrotate(Qmap,90))