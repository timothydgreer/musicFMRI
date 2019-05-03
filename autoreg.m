%load matrix
function RMSE = autoreg(ymatrix)
    mymod = arima(20,0,0);
    EstMdl = estimate(mymod,ymatrix(40*30:floor(.8*length(ymatrix))));
    EstMdl.AR

    prediction = conv(ymatrix,cell2mat(EstMdl.AR));
    RMSE = sqrt(mean((prediction(floor(.8*length(ymatrix)):length(prediction)-19) - ymatrix(floor(.8*length(ymatrix)):length(ymatrix))).^2))
end