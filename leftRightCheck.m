function fp = leftRightCheck(fp_LR,fp_RL)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(fp_LR);

    for i = 1:m
        for j = 1:n
            fn = j - fp_LR(i,j);
            if fn >= 1
                if abs(fp_LR(i,j)-fp_RL(i,fn)) < 4
                    fp(i,j) = fp_LR(i,j);
                else
                    fp(i,j) = 0;
                end
            end
        end
    end
    
    imtool(fp/64)


end

