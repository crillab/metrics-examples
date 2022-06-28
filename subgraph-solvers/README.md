# Metrics Demonstration for Subgraph Solvers

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/crillab/metrics-examples/HEAD?labpath=subgraph-solvers)

This directory contains an analysis demonstrating the use of *Metrics* to
analyze a campaign experimenting subgraph solvers.

## Description of the solvers

For these experiments, four subgraph solvers have been run, namely *Glasgow*,
*LAD*, *VF2* and *RI*.

These four solvers are the distinct *experiment-wares* of our analysis.
Note that *experiment-wares* is the generic name used by *Metrics* to
identify software programs which are used for experiments (as such programs
may not necessarily be solvers).

## Data collected during the experiments

The runtime of the considered solvers on all instances has been gathered in a
single CSV file.
The particular form of this CSV file is called `reverse-csv` in *Metrics*.
Instead of having an experiment per line, this file has one line per input, and
each column corresponds to the runtime of one of the solvers on this input.
As input are not named in the CSV file, a generic name will be created by
*Metrics for each line.

You can find the full configuration of *Metrics-Scalpel* in
[this file](config/metrics_scalpel.yml).

Of course, this description corresponds to a *particular* execution environment,
and you are not forced to use the same configuration to use *Metrics* to analyze
your experiments.

## Analysis

We now present an analysis of our experiments using *Metrics-Wallet*.
You can browse the notebooks of this analysis from the following table of
contents:

+ [Loading Experiment Data](load_experiments.ipynb)
+ [Analysis of the Runtime](runtime_analysis.ipynb)
