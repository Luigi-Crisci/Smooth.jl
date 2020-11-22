module MobileUserModule
include("CanvasModule.jl")
include("PointCluster.jl")
include("LATP.jl")

using .CanvasModule,.PointCluster,.LATP
using LightGraphs,SimpleWeightedGraphs
using Distances

export MobileUser
mutable struct MobileUser
	id::Int
	starting_point::Tuple{Int64,Int64}
	canvas::Canvas
	alpha::Int
	y::Float16
end

MobileUser(id::Int,canvas::Canvas,start_point::Tuple{Int64,Int64},alpha::Int,y::Float16) = MobileUser(id,start_point,canvas,alpha,y)

function move(m::MobileUser)
	#Select cluster TODO: Should be proportional to the size
	cluster = m.canvas.clusters[rand(1:m.canvas.num_cluster)]
	#Select y% subset of cluster waypoints
	num_waypoints = length(cluster.points) * y
	#Extract subpoint list from the cluster
	vertex_list = rand(1:length(cluster.points),num_waypoints)
	point_list = [cluster.points[i] for i in vertex_list]
	#Add the mobile node to the graph
	push!(point_list,m.starting_point)
	#Generate subgraph
	subgraph = generate_graph(point_list)
	#Visit node with LATP algorithm, starting from the node position
	m.starting_point = latp_algorithm(subgraph,nv(subgraph),m.alpha)

end

#TODO: This would be more efficient if the edge weights are generated first and then the Graph is constructed, according to SimpleWeightedGraph doc
function generate_graph(point_list::Array{Tuple{Int64,Int64},1})
	g = SimpleWeightedGraph()
	for j in vertex_list
		add_vertex!(g)
		for i = 1:nv(g)-1
			add_edge!( g, i, nv(g), node_distance(point_list[i],point_list[nv(cluster.graph)]))
		end
	end
	return g
end

function node_distance(p1::Tuple,p2::Tuple)
	return round(evaluate(Euclidean(),collect(p1),collect(p2)),digits=3)
end

end