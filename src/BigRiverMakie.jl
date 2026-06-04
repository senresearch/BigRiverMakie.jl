module BigRiverMakie

using Makie
using Statistics
using KernelDensity

include("confidence.jl")
export confidenceplot, confidenceplot!

include("dotplot.jl")
export dotplot, dotplot!

end
