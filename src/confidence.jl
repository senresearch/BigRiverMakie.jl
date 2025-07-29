"""
    confidence_plot(x_data, y_labels, error_values; kwargs...)

Generates a confidence interval plot around `x_data` with error bars as given by `error_values`.
The y-axis is labeled with `y_labels`.

# Arguments

- `x_data`: A vector of x values.
- `y_labels`: A vector of y labels.
- `error_values`: A vector of error values.
- `kwargs`: Additional arguments to pass to the confidenceplot! function.
"""
function confidence_plot(
        x_data::Vector{<:Real},
        y_labels::Vector{<:AbstractString},
        error_values::Vector{<:Real};
        kwargs...
    )
    fig = Figure()
    ax = Axis(
        fig[1, 1],
        yticks = (1:length(y_labels), y_labels),
        xlabel = "Effect Size",
        title = "Confidence Interval Plot",
        leftspinevisible = false,
        rightspinevisible = false,
        topspinevisible = false,
        xgridvisible = false,
        ygridvisible = false,
        yticksvisible = false
    )
    confidenceplot!(ax, x_data, error_values; kwargs...)
    return fig
end

function confidence_plot!(
        ax,
        x_data::Vector{<:Real},
        y_labels::Vector{<:AbstractString},
        error_values::Vector{<:Real};
        kwargs...
    )
    ax.yticks = (1:length(y_labels), y_labels)
    ax.xlabel = "Effect Size"
    ax.title = "Confidence Interval Plot"
    ax.xgridvisible = false
    ax.ygridvisible = false
    ax.yticksvisible = false
    ax.leftspinevisible = false
    ax.rightspinevisible = false
    return confidenceplot!(ax, x_data, error_values; kwargs...)
end

"""
    confidenceplot!(x, ϵ; kwargs...)
    confidenceplot(x, ϵ; kwargs...)

Generate a confidence interval plot. This is a very simple plot that takes a vector of x values
and a vector of error values. The error values are used to create a confidence interval around 
the x values. If the confidence interval contains 0, then it is considered to be significant and 
the point is colored dark blue, otherwise it is colored light blue. 

This plot is a Makie recipe and does not set any theming options, or even the axis labels. It can
of course be customized with the same variety that any Makie plot can be, but for a plot with more
default options and the choice to pass in axis labels, see also [`confidence_plot`](@ref).

# Arguments

- `x`: A vector of x values.
- `ϵ`: A vector of error values.
"""
@recipe ConfidencePlot (x, ϵ) begin
    """
    Color of the error bars. Check the Makie documentation for more color options.
    """
    errorbarcolor = :black
    """
    Width of the whiskers of the error bars.
    """
    whiskerwidth = 10
    """
    Shape of the markers for the scatter plot. Check the Makie documentation for
    more marker shape options.
    """
    markershape = :rect
    """
    Size of the markers.
    """
    markersize = 15
    """
    Colors for the markers. This uses the first and last colors of the colormap
    provided, or if a vector of colors is provided, the first and last colors of
    the vector. Check the Makie documentation for more color options.
    """
    scattercolors = :Blues_3
    """
    Color of the border of the markers. Check the Makie documentation for more
    color options.
    """
    scatterbordercolor = :black
    """
    Width of the border of the markers.
    """
    scatterborderwidth = 1
    """
    Color of the vertical line at 0. Check the Makie documentation for more
    color options.
    """
    linecolor = :red
    """
    Style of the vertical line at 0. Check the Makie documentation for more
    line style options.
    """
    linestyle = :dash
end

function Makie.plot!(p::ConfidencePlot)
    map!(p.attributes, [:x], :labels) do x
        return 1:length(x)
    end
    map!(p.attributes, [:x, :ϵ, :scattercolors], :markercolor) do x, ϵ, scattercolors
        x_significant = (x - ϵ) .* (x + ϵ) .> 0
        cmap = Makie.to_colormap(scattercolors)
        return ifelse.(x_significant, first(cmap), last(cmap))
    end
    errorbars!(
        p, p.attributes, p.x, p.labels, p.ϵ; direction = :x,
        whiskerwidth = p.whiskerwidth, color = p.errorbarcolor
    )
    scatter!(
        p, p.attributes, p.x, p.labels; marker = p.markershape,
        markersize = p.markersize, color = p.markercolor,
        strokecolor = p.scatterbordercolor, strokewidth = p.scatterborderwidth
    )
    vlines!(p, 0; color = p.linecolor, linestyle = p.linestyle)
    return p
end
