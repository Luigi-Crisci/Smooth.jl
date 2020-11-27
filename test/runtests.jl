# using Smooth

# @testset "Smooth.jl" begin
# end

using Test
include("../src/LATP.jl")
include("../src/PointCluster.jl")
include("../src/CanvasModule.jl")
using .CanvasModule
using .PointCluster
using Suppressor
using Plots


f = open("test.log","w")
pipe = redirect_stdout(f)

@testset "CanvasModule.jl" begin
X_DIM = 3000
Y_DIM = 3000

canvas = Canvas(X_DIM, Y_DIM)
@test typeof(generate_point(canvas)) == Tuple{Int64,Int64}
initialize(canvas,10,1000,200)
# for i in 1:length(canvas.clusters)
#     println(canvas.clusters[i])
# end
Points = collect(Iterators.flatten([canvas.clusters[i].points for i in 1:length(canvas.clusters)]))
X = [ Points[i][1] for i in 1:length(Points) ]
Y = [ Points[i][2] for i in 1:length(Points) ]

println(filter(x -> x >X_DIM,X))
println(filter(x -> x >Y_DIM,Y))

gr()
plot( X, Y, seriestype = :scatter,xlims = (0,X_DIM), ylims = (0,Y_DIM))
savefig("canvas.png")
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

using Test
@testset "Plot" begin
    gr()
    plot(1:10,1:10)
    savefig("test.png")
end