function [moving_aligned,roughAlignInfo]=roughAlign(fixed_obj,moving_obj)
    %Returns the aligned object and optionally a struct roughAlignInfo that
    %contains:
    
    %mPca: principal components of the moving object (3 x 3 matrix with
    %each column the direction of a principal component).
    %fPca: see mPca, but for the fixed object.
    %cm: the center of mass of the moving object
    %cf: see above
    %R: the rotation that transforms mPca into fPca
    %t: the translation that moves cm to cf
    
    
    %Find the principal components. These are 3 x 3 matrices with each
    %column a basis vector.   
    B_moving=real(pca(moving_obj.v, 'Centered',true));
    B_fixed=real(pca(fixed_obj.v, 'Centered',true));

    %Find the center of mass
    [~,mc]=centerObj(moving_obj);
    [~,fc]=centerObj(fixed_obj);
        
    %Rotation about first principal component (z_moving gets rotated
    %into z_fixed by rotating in a plane perpendicular to both). This will
    %let the xy-planes of both bases coincide. 
    zm=B_moving(:,1);
    zf=B_fixed(:,1);
    %Find the angle between both axes
    angle=acos((zm'*zf)/(norm(zm)*norm(zf)));
    %Set up rotation matrix
    R1=rotV(cross(zm,zf), angle);
    
    %Transform
    B1=R1*B_moving;   
    
    %Rotate around z_fixed (both xy-planes should be aligned now, so we
    %find the angle between the B1 y-axis and the fixed y-axis and rotate
    %B1 so that the B1 y-axis and the fixed y-axis coincide.
    y_moving=B1(:,2);
    y_fixed=B_fixed(:,2);
    
    angle=acos((y_moving'*y_fixed)/(norm(y_moving)*norm(y_fixed)));
    R2=rotV(zf, -angle);
    R=R2*R1;
    moving_aligned=rigidTransform(centerObj(moving_obj), real(R1),[0 0 0]); %SHOULD BE R2*R1, but for now I just want to align the z axes
                                
    roughAlignInfo=struct('mPca', B_moving, 'fPca', B_fixed, 'mPcaT',R*B_moving,...
                          'mc', mc,'fc', fc,'R', R, 't', mc-fc);
end

%Written by Jan Morez
%Visielab, Antwerpen
%jan.morez@gmail.com, jan.morez@student.uantwerpen.be
