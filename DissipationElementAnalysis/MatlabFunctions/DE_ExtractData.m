function var = DE_ExtractData(Var, x, y, z)
    
    %
    var = [];
    for i = 1:length(x)
        var = [var, Var(x(i), y(i), z(i))];
    end
    var = var';

end
