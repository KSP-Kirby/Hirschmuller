function iout = filOcc( fp )
% State machine definitions:
% State = 0     % first non zero value found

    [m,n] = size(fp);
    iout = fp;
    h = waitbar(0,'Crunching')
    neigh = zeros([3,3]);
    
    for i = 1:m
        for j = 1:n
            
            if i == 3 && j == 63
                disp('stop');
            end
            if fp(i,j) == 0;
                %find value to left
                if j == 1
                    neigh(2,1) = 0;
                else
                    k = j-1;
                    while k >= 1
                        if fp(i,k) > 0
                            neigh(2,1) = fp(i,k);
                            k = 0;
                        else
                            k = k - 1;
                        end
                    end
                end
                
                %find value to right
                if j == n
                    neigh(2,3) = 0;
                else
                    k = j+1;
                    while k <= n
                        if fp(i,k) > 0
                            neigh(2,3) = fp(i,k);
                            k = n+1;
                        else
                            k = k + 1;
                        end
                    end
                end
                
                %find above
                if i == 1
                    neigh(1,2) = 0;
                else
                    k = i-1;
                    while k >= 1
                        if fp(k,j) > 0
                            neigh(1,2) = fp(k,j);
                            k = 0;
                        else
                            k = k - 1;
                        end
                    end
                end
                
                %find below
                if i == m
                    neigh(3,2) = 0;
                else
                    k = i+1;
                    while k <= m
                        if fp(k,j) > 0
                            neigh(3,2) = fp(k,j);
                            k = m+1;
                        else
                            k = k + 1;
                        end
                    end
                end 
                
                v = sort(reshape(neigh,9,1));
                p = 1;
                while v(p) == 0
                    p = p+1;
                end
                
                iout(i,j) = v(p); 
                
            end
        end
        waitbar(i/m);
    end
    close(h);
end

