% "Michael's 1st Matlab Script"
% Electrical Materials Lab
% Calibration Plotting

% reset environment
clear; clc; close all;

% CHANGE TO WHEREVER YOU'VE STORED THE SPREADSHEET
dataPath = "~/tcd/onedrive/materials/elec-lab/calibration-results.xlsx";


% read spreadsheet
spreadsheet = readtable(dataPath);

data = spreadsheet(:, 1:4);
res = data{:, 2};
temp = data{:, 4};

constants = spreadsheet{2:10, 7};
beta = constants(1);
refRes = constants(2);
refTemp = constants(3);
linearSlope = constants(4);
linearIntercept = constants(5);
linearRSq = constants(6);
logSlope = constants(7);
logIntercept = constants(8);
logRSq = constants(9);

% beta parameter function
refConst = refRes * exp(-beta/refTemp);
resToTemp = @(res) beta / log(res/refConst);

% r-squared calculation
prediction = arrayfun(resToTemp, res);
resisual = temp - prediction;
deviation = temp - mean(temp);
ssr = sum(resisual.^2);                 % sum of square residuals
sst = sum(deviation.^2);                % sum of square totals
rsq = 1 - ssr/sst;

% common figure values
xlabelVal = "R = Resistance (\Omega)";
ylabelVal = "T = Temperature (K)";
fontSizeVal = 14;
markerSizeVal = 10;
lineWidthVal = 2;
figWidthVal = 1000;
figHeightVal = 800;
fitMinVal = 3000;
fitMaxVal = 11000;


% setup new figure
fig = figure("Name", "Beta-parameter Thermistor Calibration Curve");
title("\beta-parameter Thermistor Calibration Curve");
xlabel(xlabelVal);
ylabel(ylabelVal);
fontsize(fontSizeVal, "points");
hold on;

% plot calibration datapoints
obsPlot = scatter(res, temp);
obsPlot.SizeData = markerSizeVal;
obsPlot.MarkerFaceColor = "flat";
hold on;

% plot beta parameter trendline
x = linspace(fitMinVal, fitMaxVal);
y = arrayfun(resToTemp, x);
betaPlot = plot(x, y);
betaPlot.LineWidth = lineWidthVal;
hold on;

% display fit equation and r-squared
% a horrid combo of latex math and printf
text(3600, 327, ...
    sprintf("\\(T = \\frac{%.0f}{ln(\\frac{R}{%.5f})},\\ " + ...
        "r^2 = %.3f\\)", ...
        beta, refConst, rsq), ...
    "Interpreter", "latex", ...
    "FontSize", 20);

% config figure
grid; grid minor;
legend("Observed values", "\beta-parameter fit");
fig.Position(3:4) = [figWidthVal, figHeightVal];


% setup new figure
name = "Linear Thermistor Calibration Curve";
fig = figure("Name", name);
title(name);
xlabel(xlabelVal);
ylabel(ylabelVal);
fontsize(fontSizeVal, "points");
hold on;

% plot calibration datapoints
obsPlot = scatter(res, temp);
obsPlot.SizeData = markerSizeVal;
obsPlot.MarkerFaceColor = "flat";
hold on;

% plot linear trendline
x = [fitMinVal, fitMaxVal];
y = arrayfun(@(x) linearSlope*x + linearIntercept, x);
betaPlot = plot(x, y);
betaPlot.LineWidth = lineWidthVal;
hold on;

% display fit equation and r-squared
% a horrid combo of latex math and printf
text(4250, 325, ...
    sprintf("\\(T = %.3f{\\times}10^{-3}\\,R + %.1f\\)" + "\n" + ...
        "\\(r^2 = %.3f\\)", ...
        linearSlope*10^3, linearIntercept, linearRSq), ...
    "Interpreter", "latex", ...
    "FontSize", 16);

% config figure
grid; grid minor;
legend("Observed values", "Linear fit");
fig.Position(3:4) = [figWidthVal, figHeightVal];


% setup new figure
name = "Logartihmic Thermistor Calibration Curve";
fig = figure("Name", name);
title(name);
xlabel(xlabelVal);
ylabel(ylabelVal);
fontsize(fontSizeVal, "points");
hold on;

% plot calibration datapoints
obsPlot = scatter(res, temp);
obsPlot.SizeData = markerSizeVal;
obsPlot.MarkerFaceColor = "flat";
hold on;

% plot logarithmic trendline
x = linspace(fitMinVal, fitMaxVal);
y = arrayfun(@(x) logSlope*log(x) + logIntercept, x);
betaPlot = plot(x, y);
betaPlot.LineWidth = lineWidthVal;
hold on;

% display fit equation and r-squared
% a horrid combo of latex math and printf
text(4250, 325, ...
    sprintf("\\(T = %.2f\\ln(R) + %.1f\\)" + "\n" + ...
        "\\(r^2 = %.3f\\)", ...
        logSlope, logIntercept, logRSq), ...
    "Interpreter", "latex", ...
    "FontSize", 16);

% config figure
grid; grid minor;
legend("Observed values", "Logarithmic fit");
fig.Position(3:4) = [figWidthVal, figHeightVal];
