function object_t=rigidTransform(object,TR,TT)
    n=length(object.v);
    object_t=object;
    for j=1:n
        object_t.v(j,1:3)=(TR*object.v(j,1:3)'+reshape(TT,3,1))';
        object_t.vn(j,1:3)=TR*object.vn(j,1:3)';
    end
end

%Written by Jan Morez, 22/10/2015
%Visielab, Antwerpen
%jan.morez@gmail.com