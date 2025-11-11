# Hypergraph Exponential Centrality (HEC) Toolbox

This repository provides a MATLAB implementation of **exponent-based centrality in hypergraphs (HEC)** and several baseline hypergraph centrality measures, together with utilities for:

- Constructing hypergraphs from adjacency or incidence data  
- Computing node-level centrality scores  
- Simulating SIR dynamics on hypergraphs  
- Performing epilepsy SEEG-based analyses (EZ vs. NEZ comparison, ROC, boxplots, violin plots)

The code was originally developed for a study on identifying important nodes in brain hypergraphs derived from SEEG recordings in epilepsy patients, but the implementation is general and can be applied to other hypergraph-structured data.

---

## Contents

### Core centrality functions

- `HEC_method.m`  
  Hyperedge-based Exponential Centrality (HEC).  
  Given a binary connection matrix and an initial 2-hyperedge index, constructs a hyperedge adjacency graph (1-line graph) of hyperedges, computes Laplacian energy centrality and shortest-path distances in the hyperedge adjacency graph, combines them via an exponential model, and maps hyperedge scores back to node-level importance.

- `HDC.m`  
  Hypergraph Degree Centrality (HDC): counts how many hyperedges each node participates in.

- `HCC.m`  
  Hypergraph Closeness Centrality (HCC): projects the hypergraph to a simple graph (nodes co-occurring in any hyperedge are connected) and computes closeness centrality based on shortest paths (Floyd–Warshall).

- `HGC.m`  
  Hypergraph Gravity Centrality (HGC): gravity-style centrality using hypergraph degree and higher-order node-to-node distances.

- `VC.m`  
  Vector Centrality (VC): hyperedge-based measure that distributes normalized hyperedge centrality equally among the nodes in each hyperedge.

### Distance / structure utilities

- `compute_edge_distances.m`  
  Compute pairwise distances between hyperedges (e.g., Jaccard- or path-based metrics).  

- `compute_node_distances.m`  
  Compute higher-order node-to-node distances based on `hyperEdges` and `edgeDistances`.

- `read_hyperedges_txt.m`  
  Read hyperedges from a text file into a cell array (one hyperedge per line).

- `hypergraph_to_line_adj_matrix.m`  
  Construct the 1-line graph adjacency matrix from a hypergraph adjacency tensor (for 3-uniform hypergraphs).

### SIR dynamics and evaluation

- `SIR_simulation_hypergraph.m`  
  Simulate SIR dynamics on a hypergraph (nodes, hyperedges, infection along hyperedges).

- `demo_SIR_hypergraph.m`  
  Example script demonstrating SIR simulation on a small toy hypergraph.

### SEEG / epilepsy analysis pipeline

- `main_SEEG_HDC_analysis.m`  
  Example pipeline for:
  - loading SEEG data for a patient  
  - selecting channels and time windows  
  - computing PLV-based connectivity  
  - constructing a hypergraph  
  - computing node-level centrality (HDC / HEC / etc.)  
  - mapping to EZs and NEZs  
  - saving `DataL` and `DataR` and visualizing differences.

- `load_patient_data.m`  
  Helper to load SEEG `.mat` file and select channels of interest.

- `select_time_window.m`  
  Extract a time window from SEEG recordings given start/end times and sampling frequency.

- `compute_plv_matrix.m`  
  Compute PLV connectivity matrix from multi-channel SEEG data.

- `build_connection_matrix.m`  
  Threshold PLV matrix to obtain a binary adjacency matrix.

- `build_hypergraph_from_connection.m`  
  Build 2-node and 3-node hyperedges (pairs and triangles) from a binary adjacency matrix.

- `compute_node_centrality.m`  
  Dispatcher/wrapper to call `HDC`, `HGC`, `HCC`, `VC`, or `HEC1` as needed.

- `boxplot_permtest_HEC.m`  
  Boxplot for EZ vs. NEZ with permutation test for the mean difference.

- `violin_HEC.m`  
  Violin plots of HEC scores across patients (EZ vs. NEZ), with significance labels.
- `evaluate_HEC_ROC.m`  
  Compute ROC curve and AUC for HEC-based node scores (EZ vs. NEZ), find the optimal threshold (Youden index), and compute classification metrics (sensitivity, specificity, precision, accuracy).
---

## Requirements

- MATLAB R2021b (tested with R20xxa/b; any recent version should work)
- Signal Processing Toolbox (for `hilbert`)
---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your_username/HEC-hypergraph-centrality.git
cd HEC-hypergraph-centrality

