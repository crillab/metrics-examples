# Metrics Demonstration for COP Solvers

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/crillab/metrics-examples/HEAD?labpath=cop-solvers)

This directory contains an analysis demonstrating the use of *Metrics* to
analyze a campaign experimenting COP solvers.

## Description of the environment

The experiments presented here have been run on cluster running Linux CentOS
Stream 8.3 (x86_64), and equipped with Intel XEON X5550 as CPU and 32GB of RAM.

The CPU time was limited to 1200 seconds (20 minutes) and the memory limit was
set to 16 GB.

## Description of the solvers

For our experiments, we ran four COP solvers, namely *ACE*, *Choco*, *Cosoco*
and *Sat4j* in their default configuration.

These 4 solvers are the 4 distinct *experiment-wares* of our analysis.
Note that *experiment-wares* is the generic name used by *Metrics* to
identify software programs which are used for experiments (as such programs
may not necessarily be solvers).

## Data collected during the experiments

During the execution of the solvers above, several files have been produced
by our execution environment.
Thanks to *Metrics-Scalpel*, we can easily parse these files to extract what
is relevant for our analysis.
You can retrieve the full configuration of *Metrics-Scalpel* in
[this file](config/metrics_scalpel.yml).
Below are given some details about what will be extracted from the output files,
based on this configuration.

Let us note that, for the purpose of this example, we modified the way solvers
output information so as to provide a wide variety of different inputs for
*Metrics-Scalpel*.
Yet, all the data stored in these files corresponds to that initially produced
by the solvers.

### Retrieving information from file names

All experiments are identified from the name of the output files produced while
the solvers were running.
More specifically, if several files were written during an experiment, then
all these files have the **same name** (with a different extension).
This kind of campaign is called `multi-files`, and is set up as follows from the
YAML configuration:

```yaml
source:
  path: experiments
  format: multi-files
```

As file names uniquely identify an experiment, one can use these names to
extract data that is relevant for the analysis.
For instance, the configuration below allows to extract, from the name of the
file, the name of the experiment-ware, as well as the family and name of the
input on which the experiment-ware had been run:

```yaml
file-name-meta:
  pattern: "experiments/{any}-{any}_{any}.xml.lzma.stats"
  groups:
    experiment_ware: 1
    family: 2
    input: 3
```

### Files `*.stats`

For each experiment, a file `*.stats` is produced.
It contains the information about the CPU and memory usage of the solver for
the experiment.
Its content could be the following:

```bash
# WCTIME: wall clock time in seconds
WCTIME=2.08164
# CPUTIME: CPU time in seconds (USERTIME+SYSTEMTIME)
CPUTIME=5.07057
# USERTIME: CPU time spent in user mode in seconds
USERTIME=4.86131
# SYSTEMTIME: CPU time spent in system mode in seconds
SYSTEMTIME=0.209267
# CPUUSAGE: CPUTIME/WCTIME in percent
CPUUSAGE=243.585
# MAXVM: maximum virtual memory used in KiB
MAXVM=16877776
# TIMEOUT: did the solver exceed the time limit?
TIMEOUT=false
# MEMOUT: did the solver exceed the memory limit?
MEMOUT=false
```

Here, we are interested in the CPU time used by the solver to solve the
corresponding instance (in this case, 5.07057 seconds).
This value can be retrieved thanks to the following lines from the
configuration:

```yaml
- file: statistics.out
  log-data: cpu_time
  pattern: 'CPUTIME={real}'
```

Here, the `cpu_time` is extracted from the line that matches the specified
(simplified) pattern.
The runtime is mapped to the implicit group `{real}`, that represents a real
value (using any of the representations commonly accepted by most programming
languages).

### Files `*.xml` (*ACE*)

We suppose that the solver *ACE* outputs information related to the exploration
of the search space in an XML file.
Its content could be the following:

```xml
<cop way="min">
	<bounds>
		<bound time="0.67">377000</bound>
		<!-- ... -->
		<bound time="1.26">70000</bound>
	</bounds>
  <status>COMPLETE</status>
</cop>
```

This structured file can be automatically read by *Metrics-Scalpel*, and a
dotted notation is used to represent all the information provided by this
file.

For instance, here, the key `cop.way` is assigned the value `min`, `cop.status`
the value `COMPLETE` and the lists `cop.bounds.bound` and 
`cop.bounds.bound.time` will contain the bounds that were found by the solver,
and the timestamp at which it had been found, respectively.

### Files `*.json` (*Choco*)

We suppose that the solver *Choco* outputs information related to the
exploration of the search space in a JSON file.
Its content could be the following:

```json
{
    "track": "COP",
    "best_bound": 800,
    "status": "OPTIMUM",
    "b": [377000, 70000],
    "t": [1, 2]
}
```

This structured file can be automatically read by *Metrics-Scalpel*, and a
dotted notation is used to represent all the information provided by this
file, as for the XML files described in the previous section.

For instance, here, the key `track` is assigned the value `COP`, `best_bound`
the value `800`, etc.

### Files `*.csv` and `*.status` (*Cosoco*)

We suppose that the solver *Cosoco* outputs information related to the
exploration of the search space in a CSV file.
Its content could be the following:

```csv
bounds,timestamp
377000,0.67
70000,1.26
```

This structured file can be automatically read by *Metrics-Scalpel*, and the
header of the CSV file will be used to identify the values it contains.

For instance, here, the lists `bounds` and `timestamp` will contain the bounds
that were found by the solver, and the timestamp at which it had been found,
respectively.

Finally, the file `*.status` contains a single line, which corresponds to the
status of *Cosoco* on the corresponding instance.

```
COMPLETE
```

To retrieve this word, one can use the following `log-data` in
*Metrics-Scalpel*'s configuration.

```yaml
- log-data: status
  file: "*.status"
  pattern: "{word}"
```

### Files `*.log` (*Sat4j*)

We suppose that the solver *Sat4j* outputs information related to the
exploration of the search space in a raw log file.
Its content could be the following:

```
...
o 800
o 561
o 462
o 446
o 437
o 432
o 383
...
c number of remaining assigned 	: 0
c speed (assignments/second)	: 820880.9523809523
c non guided choices	: 935
s OPTIMUM FOUND
```

For such unstructured files, you need to provide in *Metrics-Scalpel*'s
configuration the description on how to extract data from the raw output
produced by *Sat4j*.
For instance, the configuration may be defined as follows:

```yaml
- log-data: status
  file: "*.log"
  pattern: "s {any}"
  exact: true
- log-data: bound_list
  file: "*.log"
  pattern: "o {integer}"
  exact: true
```

Here, the `status` is obtained by reading the value next to the prefix `s` in
the raw data file.
The `bound_list` is obtained similarly, by reading from each line starting with
the prefix `o` the integer that follows.

In both cases, the `exact` option allows to make sure that the full line
matches the simplified pattern (for instance, to avoid matching something in the
middle of a line).

## Mapping data to *Metrics-Scalpel*'s expectations

Since some keys are automatically generated (especially, when parsing
structured files), they do not necessarily fit *Metrics-Scalpel*'s expectations,
or they may be impractical to manipulate.
When this is the case, one may use a `mapping` to rename these keys, as in
the example below.

```yaml
mapping:
  # XML tags from ACE.
  bounds: cop.bounds.bound
  timestamp: cop.bounds.bound.time
  status: cop.status

  # JSON fields from Choco.
  b: bounds
  t: timestamp

  # Remapping for ACE and Choco.
  bound_list: b
  timestamp_list: t
```

For instance, here, `cop.bounds.bound.time` is mapped to `timestamp`, before
being remapped to `t` and then to `timestamp_list`.
This recursive mapping allows to make sure that all keys that represent the
same thing use the same name.

## Analysis

We now present an analysis of our experiments using *Metrics-Wallet*.
You can browse the notebooks of this analysis from the following table of
contents:

+ [Loading Experiment Data](load_experiments.ipynb)
+ [Analysis of the Runtime](runtime_analysis.ipynb)
+ [Analysis of the Best Bounds](optim_analysis.ipynb)
