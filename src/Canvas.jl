
mutable struct Canvas
	x::Int64
	y::Int64
	clusters::Vector{Cluster}
	num_cluster::Int64
end

Canvas(x::Int64,y::Int64) = Canvas(x, y, [], 0)

function initialize(canvas::Canvas, num_clusters::Int64, num_waypoints::Int64, trasmission_range::Int64)
	waypoints_per_cluster = random_array_fixed_sum(num_waypoints,num_clusters)
	canvas.num_cluster = num_clusters
	# For each cluster
	for i = 1:num_clusters
		push!(canvas.clusters,define_cluster(canvas, waypoints_per_cluster[i], trasmission_range))
	end
end

function define_cluster(canvas::Canvas, waypoints_per_cluster::Int, trasmission_range)
	cluster = Cluster(trasmission_range,canvas.x,canvas.y)
	groups = random_array_fixed_sum(waypoints_per_cluster,rand(1:waypoints_per_cluster))
	last_plotted_point = Tuple{Int64,Int64}((0,0))

	for i in 1:length(groups)
		group_points = Tuple{Int64,Int64}[]
		# println("Plotting $i group")
		# First we plot the first point in the cluster, which has a different rule
		if length(cluster.points) == 0  ##If I'm plotting the very first point, plot it with an uniform distribution on the canvas
			last_plotted_point = generate_point(canvas)
			# println("First Point $i group : $last_plotted_point")
			add_point_to_cluster(cluster,last_plotted_point)
		else #The first point of the other groups are plotted with a Y/4 - Y/3 distance from the last plotted point
			last_plotted_point = generate_group_first_point(canvas,last_plotted_point,cluster)
			# println("Point $i group : $last_plotted_point")
			add_point_to_cluster(cluster,last_plotted_point)
		end
		push!(group_points,last_plotted_point)

		for j in 2:groups[i] #Plot the other ones within 0.1R from the last plotted point
			last_plotted_point = generate_group_internal_point(canvas,trasmission_range,cluster,group_points)
			push!(group_points,last_plotted_point)
			add_point_to_cluster(cluster,last_plotted_point)
		end
	end
	return cluster
end


#TODO: Collapse point generation point functions into one, with acceptance funcion as parameter 
function generate_group_internal_point(canvas::Canvas,R::Int64,cluster::Cluster,group_points::Array{Tuple{Int64,Int64}})
	t = ceil(Int,0.1 * R)
	
	while true
		last_point = group_points[rand(1:length(group_points))]
		xl = (last_point[1] - t) >= 0 ? last_point[1] - t : 0
		xr = (last_point[1] + t) <= canvas.x ? last_point[1] + t : canvas.x
		yb = (last_point[2] - t) >= 0 ? last_point[2] - t : 0
		yt = (last_point[2] + t) <= canvas.y ? last_point[2] + t : canvas.y
		
		x = rand(xl : xr) # A point inside the radious
		y = rand(yb : yt)

		d = evaluate(Euclidean(),collect(last_point),[x,y])
		# println("Point ($x,$y) -- distance $d -- t: $t")
		if d <= t && !((x,y) in cluster.points) && !is_inside_another_cluster(canvas,(x,y))
			return (x,y)
		end
	end
end

function generate_group_first_point(canvas::Canvas,last_point::Tuple{Int64,Int64},cluster::Cluster)
	# Y = round(Int,(2 * canvas.x * canvas.y) / canvas.num_cluster)
	Y = round(Int,(canvas.x ) / canvas.num_cluster)
	
	xl = (last_point[1] - Y/3) >= 0 ? last_point[1] - Y/3 : 0
	xr = (last_point[1] + Y/3) <= canvas.x ? last_point[1] + Y/3 : canvas.x
	yb = (last_point[2] - Y/3) >= 0 ? last_point[2] - Y/3 : 0
	yt = (last_point[2] + Y/3) <= canvas.y ? last_point[2] + Y/3 : canvas.y

	while true
		x = ceil(Int,rand(xl : xr)) # A point inside the radious
		y = ceil(Int,rand(yb : yt))

		d = evaluate(Euclidean(),collect(last_point),[x,y])
		# println("Point ($x,$y) -- distance $d -- Y/3:$(Y/3) -- Y/4:$(Y/4) -- Y: $Y")
		if d >= Y/4 && d <= Y/3 && !((x,y) in cluster.points) && !is_inside_another_cluster(canvas,(x,y))
			return (x,y)
		end
	end
end

# Get a poin in the Canvas

function generate_point(canvas::Canvas)
	while true
		p = (rand(0:canvas.x) , rand(0:canvas.y))
		if !is_inside_another_cluster(canvas,p)
			return p
		end
	end
		
end

function is_inside_another_cluster(canvas::Canvas, point::Tuple)
	if length(canvas.clusters) == 0
		return false
	else
		for i in 1:length(canvas.clusters)
			if is_inside_cluster(canvas.clusters[i], point)
				return true
			end
		end
		return false
	end
end
