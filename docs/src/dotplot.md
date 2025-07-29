# Dot plot

This plot shows the distribution of data points in each category. The yellow points are the mean of the data points in each category.

```@setup dot
function generate_dotplot_data(n_categories::Int = 4, points_per_category::Int = 20)
    # Generate category labels
    categories = ["Group $i" for i in 1:n_categories]
    
    # Generate data points for each category
    x_indices = Int[]
    y_values = Float64[]
    
    for (i, category) in enumerate(categories)
        # Generate random data points for this category
        # Use different normal distributions with different means to show variety
        if i == 1
            # Normal distribution centered around -0.5
            group_data = randn(points_per_category) * 0.4 .- 0.5
        elseif i == 2
            # Normal distribution centered around 0
            group_data = randn(points_per_category) * 0.4
        elseif i == 3
            # Normal distribution centered around 0.5
            group_data = randn(points_per_category) * 0.4 .+ 0.5
        else
            # Normal distribution centered around 1.0
            group_data = randn(points_per_category) * 0.4 .+ 1.0
        end
        
        # Add category index and data points
        append!(x_indices, fill(i, points_per_category))
        append!(y_values, group_data)
    end
    
    return x_indices, y_values, categories
end

# Generate sample data
x_indices, y_values, categories = generate_dotplot_data(4, 150)
```

An example of all three jitter algorithms:

```@example dot
using CairoMakie, BigRiverMakie

algs = [:none, :random, :quasirandom]

fig = Figure(; size = (1000, 400))
axs = [Axis(fig[1, i]) for i in 1:3]
for (i, alg) in enumerate(algs)
    dot_plot!(axs[i], x_indices, y_values, categories; color = (:blue, 0.5), jitter_alg = alg, jitter_width = 0.5)
    axs[i].title = "Jitter algorithm: $alg"
end

fig
```

```@docs
BigRiverMakie.dot_plot
BigRiverMakie.dotplot
BigRiverMakie.dotplot!
BigRiverMakie.DotPlot
```
