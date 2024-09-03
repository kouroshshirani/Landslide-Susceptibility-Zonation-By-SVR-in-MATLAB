function X = DeNormalize_Fcn(xN,MinX,MaxX,a,b)
    
    X = (xN - MinX) / (MaxX - MinX) * (b-a) + a;
    
end