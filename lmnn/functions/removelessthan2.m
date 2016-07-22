function [labeltype2,cc2]=removelessthan5(labeltype,cc2)

y=unique(labeltype);
n=hist(labeltype,y);
n(2,:)=y';

indices=find(abs(n(1,:)<2));
labeltype2=labeltype;
for k=length(indices):-1:1
    
  n1=  n(2,indices(k));
  n2= n(1,indices(k));
  I=find(labeltype==n1);
  labeltype2=labeltype2([1:(I-1),(I+n2):end]);
  cc2=cc2([1:(I-1),(I+n2):end],:);
end

