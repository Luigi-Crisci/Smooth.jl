module CanvasModule

include("PointCluster.jl")
using .PointCluster
using Random

export Canvas
struct Canvas
	clusters::Vector{Cluster}
	x::Int64
	y::Int64
	bound<:Number
end

Canvas(x::Int64,y::Int64,bound<:Number) = Canvas(x,y,Vector{Cluster},bound)

export initialize
function initialize(canvas::Canvas,num_clusters::Int64,num_waypoints::Int64,trasmission_range<:Number)
	waypoints_per_cluster = num_waypoints / num_clusters #TODO:This shoud be random, according to model specification
	#For each cluster
	for i = 1 : num_clusters
		current_cluster = Cluster()
		while length(current_cluster.points) != waypoints_per_cluster
			p = generate_point(canvas)
			if !is_inside_another_cluster(canvas,p,i)
				add_point_to_cluster(current_cluster,p)
			end
		end
	end
end

# Get a poin in the Canvas according to the given bound
function generate_point(canvas::Canvas)
	return Point(rand(canvas.bound:canvas.x-canvas.bound)[1],
					rand(canvas.bound:canvas.y-canvas.bound)[1])
end

function is_inside_another_cluster(canvas::Canvas,point::Point,index<:Number)
	if index == 1
		return true
	else
		for i in vcat(1:index-1,index+1:length(canvas.clusters))
	end
end
