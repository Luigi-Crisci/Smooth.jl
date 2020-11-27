module Smooth

#Using
using Random
using Distances
using LightGraphs, SimpleWeightedGraphs
using Rectangle
# using GraphPlot

# Canvas
export Canvas
export initialize

#Cluster
export Cluster
export add_point_to_cluster
export is_inside_cluster

#LATP
export latp_algorithm

#MobileUser
export MobileUser
export move

include("Cluster.jl")
include("Canvas.jl")
include("LATP.jl")
include("Utils.jl")
include("MobileUser.jl")

end
