function [x,y,temp] = findhighestpeaks1(J,P,r)
div= length(J);
J = shiftdim(J);
J(isnan(J))=0; % for finding peaks of J, we need to replace Nan with 0 
ix = find(imregionalmax(J));
[B,Index] = sort(J(ix),'descend');
for i = 1:P
    temp(i) = ix(Index(i));
end
for i = 1:P
    quotient(i) = floor(temp(i)./div);
    remainder(i) = mod(temp(i), div);
end
for i = 1:P
    if remainder(i)>=(r)
        x(i) = remainder(i)-(r+1);
    else
        x(i) = remainder(i)-r;
    end
    
    if quotient(i)>=(r)
        y(i) = quotient(i)-(r);
    else
        y(i) = quotient(i)-r;
    end
end
