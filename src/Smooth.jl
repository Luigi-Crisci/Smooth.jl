module Smooth

include("PointCluster.jl")

using Revise
using .PointCluster
using SimpleWeightedGraphs
using GraphPlot
using Rectangle

cluster = Cluster()
# gplot(cluster.graph)
add_point_to_cluster(cluster,(0,0))
println(cluster.rect)
gplot(cluster.graph)
println(cluster.points)

end
