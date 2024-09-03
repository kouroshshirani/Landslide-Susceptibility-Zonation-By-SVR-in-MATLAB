function xN = Normalize_Fcn(x,MinX,MaxX,a,b)

% xN = (x - MinX) / (MaxX - MinX) ;
xN = (x - MinX) / (MaxX - MinX) * (b-a) + a;

end