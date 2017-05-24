function fp = filOcc( fp )
% State machine definitions:
% State = 0     % first non zero value found

    [m,n] = size(fp);
    state = 0;
    
    for i = 1:m
        for j = 1:n
            if fp(i,j) == 0;
                %find value to left
                if j == 1
                    leftValue = 0;
                else
                    k = j-1;
                    while k >= 1
                        if fp(i,k) > 0
                            leftValue = fp(i,k);
                            k = 0;
                        else
                            k = k - 1;
                        end
                    end
                end
            end
        end
    end
end

