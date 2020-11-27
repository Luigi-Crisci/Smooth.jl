mutable struct Cluster
	points::Vector{Tuple{Int64,Int64}}
	boundary::Rect
	r::Int64
	x_bound::Int64
	y_bound::Int64
end

Cluster(r::Int64,x_bound::Int64,y_bound::Int64) = Cluster([], Rect([ [0,0] [0,0] ]),r,x_bound,y_bound)

function add_point_to_cluster(cluster::Cluster,p::Tuple{Int64,Int64})
	if p in cluster.points
		return false
	end

	push!(cluster.points,p)
	update_rect(cluster::Cluster,p::Tuple{Int64,Int64})
	return true
end

function node_distance(p1::Tuple,p2::Tuple)
	return round(evaluate(Euclidean(),collect(p1),collect(p2)),digits=3)
end


function update_rect(cluster::Cluster,p::Tuple{Int64,Int64})
	if length(cluster.points) == 1
		cluster.boundary = Rect( bounded_diff(p[1],cluster.r,0),
							  	 bounded_diff(p[2],cluster.r,0),
							 	 bounded_sum(p[1],cluster.r,cluster.x_bound),
							  	 bounded_sum(p[2],cluster.r,cluster.y_bound))
		return
	end
	
	x1,x2 = x(cluster.boundary)
	y1,y2 = y(cluster.boundary)

	if length(cluster.points) == 2
		cluster.boundary = Rect(x1,y1,
								 bounded_sum(p[1],cluster.r,cluster.x_bound),
								 bounded_sum(p[2],cluster.r,cluster.y_bound))
		return
	end

	x1 = min(x1, bounded_diff(p[1],cluster.r,0))
	x2 = max(x2, bounded_sum(p[1],cluster.r,cluster.x_bound))
	y1 = min(y1, bounded_diff(p[2],cluster.r,0))
	y2 = max(y2, bounded_sum(p[2],cluster.r,cluster.y_bound))

	cluster.boundary = Rect(x1,y1,x2,y2)
end


function is_inside_cluster(cluster::Cluster,p::Tuple{Int64,Int64})
	return inside(p,cluster.boundary)
end
