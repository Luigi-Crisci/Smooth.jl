# using Smooth

# @testset "Smooth.jl" begin
# end

using Test
include("../src/CanvasModule.jl")
using .CanvasModule
using Suppressor

f = open("test.log","w")
pipe = redirect_stdout(f)

@testset "CanvasModule.jl" begin
canvas = Canvas(1800, 1800)
@test typeof(generate_point(canvas)) == Tuple{Int64,Int64}
initialize(canvas,10,1000,100)
for i in 1:length(canvas.clusters)
    println(canvas.clusters[i])
end
# define_cluster(canvas, 100, 100)  
end

include("../src/LATP.jl")
using .LATP
using LightGraphs,SimpleWeightedGraphs,GraphPlot
using Test
@testset "LATP.jl" begin
    g = SimpleWeightedGraph(0)
    for i in 1:5
        add_vertex!(g)
        for j in 1:nv(g) - 1
            add_edge!(g,i,j,rand(1:15))
        end
    end
    latp_algorithm(g,1,3)
end