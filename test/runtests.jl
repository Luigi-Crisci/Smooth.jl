# using Smooth

# @testset "Smooth.jl" begin
# end

using Test
using Smooth
using Plots

open("log.log","w") do io
    # redirect_stdout(io)
end

@testset "CanvasModule.jl" begin
X_DIM = 3000
Y_DIM = 3000

canvas = Canvas(X_DIM, Y_DIM)
initialize(canvas,50,1000,1)

Points = collect(Iterators.flatten([canvas.clusters[i].points for i in 1:length(canvas.clusters)]))
X = [ Points[i][1] for i in 1:length(Points) ]
Y = [ Points[i][2] for i in 1:length(Points) ]

println(filter(x -> x >X_DIM,X))
println(filter(x -> x >Y_DIM,Y))

# gr()
plot( X, Y, seriestype = :scatter,xlims = (0,X_DIM), ylims = (0,Y_DIM))
savefig("canvas.png")
# define_cluster(canvas, 100, 100)  
end

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

