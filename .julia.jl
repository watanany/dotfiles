#!/usr/bin/env julia
# -*- coding: utf-8 -*-
import Pkg

packages = [
    "Clustering",
    "Combinatorics",
    "Conda",
    "DataFrames",
    "DataFramesMeta",
    "Gadfly",
    "GLM",
    "Glob",
    "HDF5",
    "HypothesisTests",
    "IJulia",
    "JSON",
    "MultivariateStats",
    "Pipe",
    "Plots",
    "PyCall",
    "RDatasets",
    "SQLite",
    "StatsBase",
    "StatsPlots",
]

foreach(Pkg.add, packages)
