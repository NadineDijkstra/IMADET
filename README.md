# IMADET - The influence of mental imagery on perceptual detection

This repository contains data, analysis code and experimental code supporting: 

Dijkstra, Mazor, Kok & Fleming (2021) "Mistaking imagination for reality: congruent mental imagery leads to more liberal perceptual detection"

The jsPsych folders contain the .html code needed to run the experiments online using jsPsych. 

The experiment folders contain, per experiment, all data and code necessary to produce the main figures in the paper. 
Each 'MasterWrapper.m' will run through all necessary analysis steps and plot the main results. 
Data for each experiment and for each participant can be found under 'ExperimentX/Data' as .mat files indicating trial by trial data in the 'data' variable and summary stats such as D' and criterion in the 'results' variable.
The 'check_data.m' scripts check the data based on the exclusion criteria in the paper and output a 1 if the participant should be included and a 0 if not. 
