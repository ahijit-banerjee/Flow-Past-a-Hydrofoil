%Name: Ahijit Banerjee
%Purpose: MECH 479 Project 2 - Data Processing
clc; clear; close all;
%%processing FLUENT data

%reading the Fluent output files
AoA_0_Lift = readmatrix("Steady-Ma0_3-AoA-0-Lift.csv");
AoA_2_Lift = readmatrix("Steady-Ma0_3-AoA-2-Lift.csv");
AoA_2_Drag = readmatrix("Steady-Ma0_3-AoA-2-Drag.csv");
AoA_4_Lift = readmatrix("Steady-Ma0_3-AoA-4-Lift.csv");
AoA_4_Drag = readmatrix("Steady-Ma0_3-AoA-4-Drag.csv");
AoA_8_Lift = readmatrix("Steady-Ma0_3-AoA-8-Lift.csv");
AoA_8_Drag = readmatrix("Steady-Ma0_3-AoA-8-Drag.csv");

%using the values of Cl & Cd for the last 1000 iterations of fluent for our
%reporting purposes
CL_0 = AoA_0_Lift((length(AoA_0_Lift) - 1000):(length(AoA_0_Lift)), 2);
CL_2 = AoA_2_Lift((length(AoA_2_Lift) - 1000):(length(AoA_2_Lift)), 2);
CL_4 = AoA_4_Lift((length(AoA_4_Lift) - 1000):(length(AoA_4_Lift)), 2);
CL_8 = AoA_8_Lift((length(AoA_8_Lift) - 1000):(length(AoA_8_Lift)), 2);

CD_2 = AoA_2_Drag((length(AoA_2_Drag) - 1000):(length(AoA_2_Drag)), 2);
CD_4 = AoA_4_Drag((length(AoA_4_Drag) - 1000):(length(AoA_4_Drag)), 2);
CD_8 = AoA_8_Drag((length(AoA_8_Drag) - 1000):(length(AoA_8_Drag)), 2);

AoA = [2 4 8] .* (pi/180);
%calculating the mean Cl & Cd values for various angles of attack
CL_2_avg = quantile(CL_2, 0.5);
CL_4_avg = quantile(CL_4, 0.5);
CL_8_avg = quantile(CL_8, 0.5);
CL = [CL_2_avg CL_4_avg CL_8_avg];

CD_2_avg = quantile(CD_2, 0.5);
CD_4_avg = quantile(CD_4, 0.5);
CD_8_avg = quantile(CD_8, 0.5);
CD = [CD_2_avg CD_4_avg CD_8_avg];

%calculating the error in the value of Cl & Cd for the last 1000 iterations
%of the numerical simulation
CL_neg_error = abs([quantile(CL_2, 0.25) quantile(CL_4, 0.25) quantile(CL_8, 0.25)] - CL);
CL_pos_error = abs([quantile(CL_2, 0.75) quantile(CL_4, 0.75) quantile(CL_8, 0.75)] - CL);
CD_neg_error = abs([quantile(CD_2, 0.25) quantile(CD_4, 0.25) quantile(CD_8, 0.25)] - CD);
CD_pos_error = abs([quantile(CD_2, 0.75) quantile(CD_4, 0.75) quantile(CD_8, 0.75)] - CD);

%% calculating theoretical results using inviscid thin airfoil theory

CL_0 = quantile(CL_0, 0.5);
CL_theoretical = AoA.*2*pi + CL_0;

%% plotting results

%plotting results
figure(1)
hold on;
errorbar(AoA, CL, CL_neg_error, CL_pos_error, "--o");
plot(AoA, CL_theoretical, "--^")
xlabel("Angle of attack of the airfoil (radian)")
ylabel("Coefficient of Lift")
legend("Numerical Simulation Results", "Inviscid Thin Airfoil Theory Results", Location="northwest")
xlim([0.02 0.15])
hold off;

figure(2)
errorbar(AoA, CD, CD_neg_error, CD_pos_error, "--o");
xlabel("Angle of attack of the airfoil (radian)")
ylabel("Coefficient of Drag")

trendline = polyfit(AoA, CL, 1);
slope = trendline(1);

fprintf("Line of best fit of the CL vs AoA plot is %d \n", slope)