"""
    dotplot(x, y; kwargs...)
    dotplot!(x, y; kwargs...)

Plots dotplots with the points spread out horizontally around the
central points. The central points represent each category.

# Arguments
- `x`: The x values.
- `y`: The y values.
"""
@recipe DotPlot (x, y) begin
    """
    Shape of mean value scatter markers. Check the Makie documentation for more
    shape options.
    """
    meanmarkershape = :circle
    """
    Size of mean value scatter points.
    """
    meanmarkersize = 10
    """
    Color of mean value scatter markers. Check the Makie documentation for more
    color options.
    """
    meancolor = :orange
    """
    Color of the horizontal line at 0. Check the Makie documentation for more
    color options.
    """
    linecolor = :red
    """
    Style of the horizontal line at 0. Check the Makie documentation for more
    line style options.
    """
    linestyle = :dash
    """
    Algorithm to use for jittering the data. One of :none, :random or :quasirandom.
    """
    jitter_alg = :random
    """
    Width of the jitter — the jitter will be in the range of
    (-jitter_width / 2, jitter_width / 2).
    """
    jitter_width = 1.0

    # All other attributes of Scatter are inherited and passed to the scatter plot
    Makie.documented_attributes(Scatter)...
end

function Makie.preferred_axis_attributes(::Type{Axis}, ::DotPlot)
    return (
        xgridvisible = false, ygridvisible = false,
        leftspinevisible = false, rightspinevisible = false,
        topspinevisible = false, yticksvisible = false,
        title = "Dot Plot", xlabel = "Super Class"
    )
end

function Makie.plot!(p::DotPlot)
    # Validate jitter_alg early to ensure proper error handling
    jitter_alg = p.jitter_alg[]
    @assert jitter_alg in [:none, :random, :quasirandom] "Invalid algorithm: $jitter_alg"

    map!(unique, p.attributes, :x, :x_unique)
    map!(
        p.attributes,
        [:x, :y, :jitter_alg, :jitter_width],
        :x_jitter
    ) do x, y, jitter_alg, jitter_width
        base_min, base_max = (-jitter_width / 2, jitter_width / 2)
        return x .+ calculate_jitter_shift(y, jitter_alg; base_min, base_max)
    end
    map!(p.attributes, [:x, :x_unique, :y], :mean_y) do x, x_unique, y
        return [mean(y[x .== i]) for i in x_unique]
    end
    # dotplot
    scatter!(p, p.attributes, p.x_jitter, p.y)
    # overlay scatter with mean values for each category
    scatter!(
        p, p.x_unique, p.mean_y; color = p.meancolor, markersize = p.meanmarkersize,
        marker = p.meanmarkershape
    )
    # horizontal line at 0
    hlines!(p, 0; color = p.linecolor, linestyle = p.linestyle)
    return p
end

# returns a jitter array weighted by the PDF of the data. This is used to spread
# out the points horizontally across the center of the dot plot.
function calculate_jitter_shift(data, jitter_alg; base_min = -0.5, base_max = 0.5)
    if isempty(data)
        return Float64[]
    end

    # For :none algorithm, return zeros
    if jitter_alg == :none
        return zeros(length(data))
    end

    # Get base jitter array
    jitter = _jitter_array(base_min, base_max, jitter_alg, length(data))
    k = KernelDensity.kde(data, npoints = 200)
    pdf_data = KernelDensity.pdf(k, data)
    pdf_data ./= maximum(pdf_data)
    return jitter .* pdf_data
end

# returns a jitter array based on the algorithm, the range of the jitter, and the
# length of the data.
function _jitter_array(base_min, base_max, alg, data_len)
    @assert alg in [:none, :random, :quasirandom] "Invalid algorithm: $alg"
    if alg == :none
        return zeros(data_len)
    end
    jitter = alg == :random ? rand(data_len) : jitter_quasirandom.(1:data_len)
    return clamp!(jitter .* (base_max - base_min) .+ base_min, base_min, base_max)
end

# also called van der Corput sequence
@inline function jitter_quasirandom(N)
    return sum(d * 2.0^-ex for (ex, d) in enumerate(digits(N, base = 2)))
end
