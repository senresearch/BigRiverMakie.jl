module BigRiverMakie

using Makie
using Statistics
using KernelDensity

include("confidence.jl")
export confidence_plot, confidence_plot!, confidenceplot, confidenceplot!

include("dotplot.jl")
export dot_plot, dot_plot!, dotplot, dotplot!

end
