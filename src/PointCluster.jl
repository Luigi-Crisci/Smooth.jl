module PointCluster

using LightGraphs, SimpleWeightedGraphs
using Rectangle

export Point
export Cluster

struct Point
	x::Int64
	y::Int64
end

struct Cluster
	points::Vector{Point}
	graph::Graph
	rect::Rect
end

Cluster() = Cluster([],SimpleWeightedGraph(0),Rect(0,0,0,0))



export add_point_to_cluster
function add_point_to_cluster(cluster::Cluster,p::Point)
	push!(cluster.points,p)
	add_vertex!(cluster.graph)
	for i = 1:nv(cluster.graph)-1
		add_edge!(cluster.graph,i,nv(cluster.graph))
	end
end

export is_inside_cluster
function is_inside_cluster(cluster::Cluster,p::Point)
	return inside((p.x,p.y),cluster.rect)
end

end