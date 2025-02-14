README


This repository contains MATLAB scripts used for analyzing fluorescence dynamics and their response to different stimulation conditions. The scripts primarily focus on calculating correlations, shuffling analyses, and computing the area under the curve (AUC) for different datasets.

Files Description
1. continuous_stim_shuffle.m
Purpose: Performs correlation analysis between fluorescence data and stimulation timing under continuous stimulation conditions.
Main Features:
Reads .mat files containing fluorescence and stimulation data.
Computes cross-correlations between the fluorescence signals and stimulation events.
Implements a circular shuffling method (100 iterations) to generate control distributions.
Outputs statistical comparisons between real and shuffled data using boxplots and correlation coefficient analysis.
Generates and exports time-series plots showing mean fluorescence changes with shaded standard deviations.
2. instant_stim_shuffle.m
Purpose: Similar to continuous_stim_shuffle.m, but designed for instantaneous stimulation (e.g., pinprick).
Main Features:
Extracts a time window (±20 seconds) around the stimulation onset.
Performs a circular shift shuffle (100 iterations) to obtain a control distribution.
Plots real vs. shuffled fluorescence responses with shaded standard deviation regions.
Conducts statistical tests to compare responses.
Saves the resulting figures.
3. Hotplate_AreaUnderCurve.m
Purpose: Computes the area under the curve (AUC) of fluorescence signals for different temperature ranges in a hotplate experiment.
Main Features:
Loads fluorescence and stimulation data.
Segments fluorescence responses based on temperature bins (T=25°C, 25°C < T < 45°C, and T ≥ 45°C).
Computes AUC using trapezoidal integration.
Performs Wilcoxon rank-sum tests to compare different temperature conditions.
Generates boxplots comparing AUC values across different temperature bins.
4. otherStimulation_AreaUnderCurve.m
Purpose: Calculates and compares the AUC of fluorescence signals between CRH and WT mice under different stimulation conditions.
Main Features:
Loads fluorescence and stimulation data for CRH and WT mice.
Extracts time windows of interest based on stimulation onset.
Computes AUC using trapezoidal integration.
Uses Wilcoxon rank-sum tests to compare CRH vs. WT responses.
Generates boxplots displaying the differences between conditions.
Dependencies
MATLAB with basic statistics and plotting functions.
.mat files containing fluorescence and label data.
Ensure that required file directories exist and contain appropriate .mat datasets.
Usage
Run the script:

Open MATLAB and navigate to the directory containing the script.
Execute: run('script_name.m'), replacing script_name with the desired file.
Select the required folders when prompted.
Outputs:

Correlation coefficients and statistical results will be displayed in MATLAB.
Figures comparing real and shuffled data will be saved in the specified output directory.
Contact
For any questions or modifications, please contact James Wang or refer to Dr. Liu
