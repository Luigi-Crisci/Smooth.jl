module PointCluster

using LightGraphs, SimpleWeightedGraphs
using Rectangle
using Distances

export Cluster

mutable struct Cluster
	points::Vector{Tuple{Int64,Int64}}
	graph::SimpleWeightedGraph
	rect::Rect
end

Cluster() = Cluster([],SimpleWeightedGraph(0), Rect([ [0,0] [0,0] ]))


export add_point_to_cluster
function add_point_to_cluster(cluster::Cluster,p::Tuple{Int64,Int64})
	if p in cluster.points
		return false
	end

	push!(cluster.points,p)
	add_vertex!(cluster.graph)
	for i = 1:nv(cluster.graph)-1
		add_edge!(cluster.graph,i,nv(cluster.graph),
					node_distance(cluster.points[i],cluster.points[nv(cluster.graph)]))
	end
	update_rect(cluster::Cluster,p::Tuple{Int64,Int64})
	return true
end

function node_distance(p1::Tuple,p2::Tuple)
	return round(evaluate(Euclidean(),collect(p1),collect(p2)),digits=3)
end

# That's sad
#TODO: Add trasmission range
export update_rect
function update_rect(cluster::Cluster,p::Tuple{Int64,Int64})
	if length(cluster.points) == 1
		cluster.rect = Rect([[p[1],p[2]] [p[1],p[2]]  ])
		return
	end
	
	x1,x2 = x(cluster.rect)
	y1,y2 = y(cluster.rect)

	if length(cluster.points) == 2
		cluster.rect = Rect(x1,y1,p[1],p[2])
		return
	end

	x1 = min(x1,p[1])
	x2 = max(x2,p[1])
	y1 = min(y1,p[2])
	y2 = max(y2,p[2])

	cluster.rect = Rect(x1,y1,x2,y2)
	println(cluster.rect)
end

export is_inside_cluster
function is_inside_cluster(cluster::Cluster,p::Tuple{Int64,Int64})
	return inside(p,cluster.rect)
end

end