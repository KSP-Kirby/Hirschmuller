Isub1 = I1(145:261,238:440);
Isub = Isub1(106:115,47:55);

[m,n] = size(Isub);

k = 1;
for i = 1:m
    for j = 1:n
        if Isub(i,j) > 127
            v(k) = Isub(i,j);
            k = k+1;
        end
    end
end
mean(v)
std(double(v))