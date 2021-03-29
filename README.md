# IMADET - The influence of mental imagery on perceptual detection

This repository contains the data, analysis code and experimental code supporting: 

Dijkstra, Mazor, Kok & Fleming (2021) "Mistaking imagination for reality: congruent mental imagery leads to more liberal perceptual detection"

The 'ExperimentX/Data.zip' folders contain .mat files for each participant with trial by trial data in the 'data' variable and summary stats such as d' and criterion in the 'results' variable. NOTE: you need to unzip these files before the analyses code can be run.

The 'ExperimentX/Analyses' folders contain all scipts required for analysis. Each 'MasterWrapper.m' will run through all necessary steps and automatically plot the main figures. 
The 'check_data.m' scripts check the data based on the exclusion criteria in the paper and output a 1 if the participant should be included and a 0 if not. 

The 'ExperimentX/jsPsych' folders contain the .html code to run the experiment online using jsPsych. 
