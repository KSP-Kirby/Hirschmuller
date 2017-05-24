function fp = filOcc( fp )
% State machine definitions:
% State = 0     % first non zero value found

    [m,n] = size(fp);
    state = 0;
    
    for i = 1:m
        for j = 2:n-1
            if i == 154 && j == 137
                disp('stop')
            end
            switch state
                case 0
                    if fp(i,j) > 0
                        state = 1;
                    end
                case 1
                    if fp(i,j) == 0
                        firstCellInZeroString = j;
                        leftSideValue = fp(i,j-1);
                        state = 2;
                    end
                case 2
                    if fp(i,j) > 0
                        lastCellInZeroString = j;
                        rightSideValue = fp(i,j);
                        fp(i,firstCellInZeroString:lastCellInZeroString) = min(leftSideValue,rightSideValue);
                        state = 1;
                    end
            end
        end
    end
end

