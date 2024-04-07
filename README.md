# Rethinking RGBT Tracking Benchmarks from the Perspective of Modality Validity: A New Benchmark, Problem, and Method

This main contributions are:

-A new benchmark, MV-RGBT, is collected to bridge the gap between existing benchmarks and the data presented in MMN scenarios. Furthermore, according to the modality validity, MV-RGBT can be divided into two subsets, MV-RGBT-RGB and MV-RGBT-TIR, providing an in-depth analysis of the methods in a compositional way.

-A new problem, when to fuse, is introduced to explore the necessity of multi-modal fusion. Through our investigation, it is demonstrated that fusion does not consistently improve final performance, particularly in MMN scenarios.

-A new method, MoETrack, is derived with three tracking heads (experts), offering a more flexible way to deal with both the RGB- and TIR-specific challenges by adaptively switching the prediction to the one from the most reliable expert.

-Extensive experiments demonstrate that MoETrack achieves new state-of-the-art results on several benchmarks, including MV-RGBT, RGBT234, LasHeR, and VTUAV-ST.

## Benchmark Data Comparison

<img src="figs/data.png" width="600">

## Selection Results

LasHeR:
---
<img src="figs/results-LasHeR.png" width="600">

MV-RGBT:
---
<img src="figs/results-MV-RGBT.png" width="600">

