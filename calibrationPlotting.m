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

constants = spreadsheet{1:3, 7};
beta = constants(1);
refRes = constants(2);
refTemp = constants(3);

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

% setup figure
name = "Thermistor Calibration Curve";
fig = figure("Name", name);
title(name);
xlabel("R = Resistance (\Omega)");
ylabel("T = Temperature (K)");
fontsize(14, "points");
hold on;

% plot calibration datapoints
obsPlot = scatter(res, temp);
obsPlot.SizeData = 10;
obsPlot.MarkerFaceColor = "flat";
hold on;

% plot beta parameter trendline
x = linspace(3000,11000);
y = arrayfun(resToTemp, x);
betaPlot = plot(x, y);
betaPlot.LineWidth = 2;
hold on;

% display line fit equation and r-squared
% a horrid combo of latex math and printf
text(3600, 327, ...
    sprintf("\\(T = \\frac{%.1f}{ln(\\frac{R}{%.5f})},\\ " + ...
        "r^2 = %.3f\\)", ...
        beta, refConst, rsq), ...
    "Interpreter", "latex", ...
    "FontSize", 20);

% config figure
grid; grid minor;
legend("Observed values", "\beta-parameter fit");
fig.Position(3:4) = [1200, 800];                    % figure size
