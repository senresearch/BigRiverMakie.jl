# Dot plot

```@example dot
using CairoMakie, BigRiverMakie, DataFrames, CSV, Statistics

df = DataFrame(CSV.File("/Users/theabhirath/Downloads/data_dot_plot.csv"))
y = df[:, :Age]
x = DataFrames.PooledArray(sort(convert(Vector{String}, df[:, :super_class])))

algs = [:none, :random, :quasirandom]

fig = Figure(; size = (1000, 400))
axs = [Axis(fig[1, i]) for i in 1:3]
for (i, alg) in enumerate(algs)
    dot_plot!(axs[i], Int.(x.refs), y, x.pool; color = (:blue, 0.5), jitter_alg = alg, jitter_width = 0.5)
end

fig
```

```@example dot
using CairoMakie, BigRiverMakie, DataFrames, CSV

df = DataFrame(CSV.File("/Users/theabhirath/Downloads/data_dot_plot.csv"))
y = df[:, :Age]
x = DataFrames.PooledArray(sort(convert(Vector{String}, df[:, :super_class])))
dot_plot(Int.(x.refs), y, x.pool; color = (:blue, 0.5), jitter_alg = :random, jitter_width = 0.5)
```

```@example dot
using CairoMakie, BigRiverMakie, DataFrames, CSV

df = DataFrame(CSV.File("/Users/theabhirath/Downloads/data_dot_plot.csv"))
y = df[:, :Age]
x = DataFrames.PooledArray(sort(convert(Vector{String}, df[:, :super_class])))
dot_plot(Int.(x.refs), y, x.pool; color = (:blue, 0.5), jitter_alg = :quasirandom, jitter_width = 0.5)
```

```@example dot
using CairoMakie, BigRiverMakie, DataFrames, CSV

df = DataFrame(CSV.File("/Users/theabhirath/Downloads/data_dot_plot.csv"))
y = df[:, :Age]
x = DataFrames.PooledArray(sort(convert(Vector{String}, df[:, :super_class])))
dot_plot(Int.(x.refs), y, x.pool; color = (:blue, 0.5), jitter_alg = :none, jitter_width = 0.5)
```

```@docs
dot_plot
BigRiverMakie.dotplot
BigRiverMakie.dotplot!
BigRiverMakie.DotPlot
```
