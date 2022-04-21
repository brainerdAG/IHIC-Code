function Gamma = getCoeff_hsph(Y)
% Assuming Y -> (I x (N+1)^2), I sensors, N order.
% To satisfy Orthogonal property, with coefficent method...

% Method 1: Using least Square with cost function as frobenius norm of
% error, |(Y')[hermetian]*Y-I(identity)|^2

siz = size(Y); I=siz(1); 
for i=1:I
    Yalp(i,:,:)=Y(i,:)'*Y(i,:);
    b(i) = sum(sum(shiftdim(Yalp(i,:,:)).*eye(siz(2)))); % 'siz(2)' is (N+1)^2
end
for i=1:I
    for j=1:I
        M(i,j)=sum(sum(shiftdim(Yalp(i,:,:).*Yalp(j,:,:))));
    end
end
[vects,d]=eig(M);
[val,indx]=sort(diag(d),'descend'); % descending order
vects=vects(:,indx);
total=sum(abs(val));
% type 1
% perc=99.2;
% for i=1:length(val)
%     if(100*(sum(val(1:i))/total) > perc)
%         rank=i;
%         break;
%     end
% end
% type 2
% indx=val>(0.001*total); % thresholding, looks always like step
% type 3
% indx=val>(0.001*max(val));
% type 4
indx=val>(0.001);
% I feel type 4 is the correct one because... Here we want to invert matrix
% 'M' which might have low eigen values. When inverted these low
% eigen value components shoot up as (1/very low)=very high. Thus, we need
% to limit eigen values till a threshold level.. here I considered 100,
% which is (0.01) as threshold. this is the method used else where too..
% I'll mention math references later..
% Yes, from observation, '0.01' is best threshold compared with '0.001' as
% sources came out very distinctively as peaks in case of '0.01', whereas
% in '0.001' case, there were source peaks, as well as other peaks, with
% value of peak more than the ones at source. Ideally, source's peak value
% must be the global max, compared with other noisy peaks..
rank=sum(indx);
% to observe what 'rank' is set, by enabling each type of thresholding.. I
% used the command below, saving 'rank'
save rank.mat rank val
% rank=length(M); % total rank
d=diag(val(1:rank));
u=vects(:,1:rank);
Gamma = diag(u*inv(d)*u'*b');
% Gamma = diag(inv(M)*b');