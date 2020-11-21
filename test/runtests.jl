using Smooth

@testset "Smooth.jl" begin
end

using Test
include("../src/CanvasModule.jl")
using .CanvasModule

@testset "CanvasModule.jl" begin
    canvas = Canvas(10000, 10000)
    @test typeof(generate_point(canvas)) == Tuple{Int64,Int64}
    initialize(canvas,10,1000,100)
    println(canvas.clusters)
    # define_cluster(canvas, 100, 100)  
end