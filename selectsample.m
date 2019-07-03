function [mem_ind,b]=selectsample(probs,index,b)

b=b+((2*max(probs))*rand);
while probs(index)<b
    b=b-probs(index);
    index=index+1;
    if index>length(probs)
        index=1;
    end
end
   mem_ind=index;