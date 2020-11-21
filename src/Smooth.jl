module Smooth

include("PointCluster.jl")

using Revise
using .PointCluster
using LightGraphs, SimpleWeightedGraphs
using GraphPlot
using Rectangle

cluster = Cluster()
# gplot(cluster.graph)
add_point_to_cluster(cluster,(3,3))
println(cluster.rect)
println(cluster.points)
println(cluster.graph.weights)
length(cluster.graph.weights)
gplot(cluster.graph,nodelabel=1:nv(cluster.graph),
							edgelabel = cluster.graph.weights[1:nv(cluster.graph),:] )

end
