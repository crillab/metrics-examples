# Metrics Demonstration for SAT Solvers

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/crillab/metrics-examples/HEAD?labpath=sat-solvers)

This directory contains an analysis demonstrating the use of *Metrics* to
analyze a campaign experimenting SAT solvers.

## Description of the solvers

For these experiments, two SAT solvers have been run, namely *Glucose* and
*Kissat*.

These two solvers are the distinct *experiment-wares* of our analysis.
Note that *experiment-wares* is the generic name used by *Metrics* to
identify software programs which are used for experiments (as such programs
may not necessarily be solvers).

## Data collected during the experiments

The runtime of the considered solvers on all instances has been gathered in two
CSV-like files (one per solver).
These files have three columns, separated with a single space character ` `:

0. the path of the input instance,
1. the decision made by the solver, and
2. the runtime of the solver, in seconds.

Because the CSV files do not provide any header, a `mapping` configuration is
needed to map the columns (automatically named from their index) to a more
explicit name:

```yaml
mapping:
  input: 0
  decision: 1
  cpu_time: 2
```

Moreover, the name of the solver is also that of the CSV file, and can be
extracted using the following `file-name-meta` configuration:

```yaml
file-name-meta:
  pattern: "{word}.txt"
  groups:
    experiment_ware: 1
```

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
