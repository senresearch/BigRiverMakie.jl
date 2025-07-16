# Confidence interval plot

```@setup example_data
function generate_confidence_data(n::Int = 8)
    # Random effect sizes (normally distributed around 0)
    x_data = randn(n) * 0.8

    # Random error bars (positive values)
    errors = abs.(randn(n) * 0.3) .+ 0.1

    # Generate category labels
    categories = ["Category $i" for i in 1:n]
    # Or use more realistic labels:
    # categories = ["Treatment A", "Treatment B", "Control", "Placebo", 
    #               "Method 1", "Method 2", "Baseline", "Enhanced"]

    return x_data, categories, errors
end

x_data, y_labels, error_values = generate_confidence_data(6)
```

```@example example_data
using CairoMakie, BigRiverMakie

confidence_plot(x_data, y_labels, error_values)
```

```@docs
confidence_plot
BigRiverMakie.confidenceplot
BigRiverMakie.confidenceplot!
BigRiverMakie.ConfidencePlot
```
