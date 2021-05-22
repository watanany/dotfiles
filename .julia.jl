#!/usr/bin/env julia
# -*- coding: utf-8 -*-
import Pkg

packages = [
    "Clustering",
    "Combinatorics",
    "Conda",
    "CSV",
    "DataFrames",
    "DataFramesMeta",
    "Gadfly",
    "GLM",
    "Glob",
    "HDF5",
    "HTTP",
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


Pkg.add(packages)

