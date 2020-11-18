module Smooth

include("PointCluster.jl")

using Revise
using .PointCluster
using LightGraphs
# using GraphPlot

cluster = Cluster()
# gplot(cluster.graph)
add_point_to_cluster(cluster,Point(10,15))
gplot(cluster.graph)
println(cluster.points)

end
