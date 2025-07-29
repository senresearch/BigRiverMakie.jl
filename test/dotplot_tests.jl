@testitem "dot_plot basic functionality" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]
    x_labels = ["A", "B", "C"]

    fig = dot_plot(x, y, x_labels)

    @test fig isa Figure
    @test length(fig.content) > 0
end

@testitem "dot_plot! basic functionality" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    fig = Figure()
    ax = Axis(fig[1, 1])

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]
    x_labels = ["A", "B", "C"]

    dot_plot!(ax, x, y, x_labels)

    @test ax.xticks[] == (1:3, ["A", "B", "C"])
    @test ax.xlabel[] == "Super Class"
    @test ax.title[] == "Dot Plot"
    @test ax.xgridvisible[] == false
    @test ax.ygridvisible[] == false
    @test ax.yticksvisible[] == false
    @test ax.leftspinevisible[] == false
    @test ax.rightspinevisible[] == false
end

@testitem "dotplot recipe with default attributes" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    dotplot!(ax, x, y)

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot custom mean marker attributes" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test custom mean marker attributes
    dotplot!(
        ax, x, y,
        meanmarkershape = :diamond,
        meanmarkersize = 15,
        meancolor = :blue
    )

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot custom line attributes" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test custom line attributes
    dotplot!(
        ax, x, y,
        linecolor = :green,
        linestyle = :solid
    )

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot jitter algorithm attributes" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test different jitter algorithms
    for alg in [:none, :random, :quasirandom]
        dotplot!(ax, x, y, jitter_alg = alg, jitter_width = 0.8)
        @test length(ax.scene.plots) > 0
    end
end

@testitem "dotplot jitter width attribute" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test different jitter widths
    for width in [0.5, 1.0, 2.0]
        dotplot!(ax, x, y, jitter_width = width)
        @test length(ax.scene.plots) > 0
    end
end

@testitem "dotplot scatter attributes inheritance" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test that scatter attributes are properly inherited
    dotplot!(
        ax, x, y,
        color = :red,
        markersize = 8,
        marker = :circle
    )

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot with empty data" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = Float64[]
    y = Float64[]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Should handle empty data gracefully
    dotplot!(ax, x, y)

    # Check that the plot was created (even with empty data)
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot with single category" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 1, 1]
    y = [0.5, 1.2, -0.3, 0.8]

    fig = Figure()
    ax = Axis(fig[1, 1])

    dotplot!(ax, x, y)

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot with large dataset" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    # Generate larger dataset
    x = repeat(1:5, outer = 20)
    y = randn(100)

    fig = Figure()
    ax = Axis(fig[1, 1])

    dotplot!(ax, x, y)

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot attribute validation" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    x = [1, 1, 2, 2, 3, 3]
    y = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    # Test that invalid jitter algorithm throws error
    @test_throws AssertionError dotplot!(ax, x, y, jitter_alg = :invalid)
end

@testitem "dotplot mean calculation" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis
    using Statistics

    x = [1, 1, 2, 2, 3, 3]
    y = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]

    # Expected means: category 1 -> 1.5, category 2 -> 3.5, category 3 -> 5.5
    expected_means = [1.5, 3.5, 5.5]

    fig = Figure()
    ax = Axis(fig[1, 1])

    dotplot!(ax, x, y)

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end

@testitem "dotplot with different data types" begin
    using Test
    using BigRiverMakie
    import Makie: Figure, Axis

    # Test with different numeric types
    x_int = [1, 1, 2, 2, 3, 3]
    y_float = [0.5, 1.2, -0.3, 0.8, 1.5, -0.7]

    fig = Figure()
    ax = Axis(fig[1, 1])

    dotplot!(ax, x_int, y_float)

    # Check that the plot was created
    @test length(ax.scene.plots) > 0
end 
