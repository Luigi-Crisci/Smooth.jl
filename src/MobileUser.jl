mutable struct MobileUser
	id::Int
	starting_point::Tuple{Int64,Int64}
	canvas::Canvas
	alpha::Int
	y::Float16
end

MobileUser(id::Int,canvas::Canvas,start_point::Tuple{Int64,Int64},alpha::Int,y::Float16) = MobileUser(id,start_point,canvas,alpha,y)

function move(m::MobileUser,iterations::Int64)

	logfile = open("results/log_$(m.id).csv","a+")
	write(logfile,"ID;node;time")
	for iteration in 1:iterations
		#Select cluster proportional to the size
		cluster = select_cluster(m.canvas.clusters)
		#Select y% subset of cluster waypoints
		num_waypoints = round(Int64,length(cluster.points) * m.y)
		#Extract subpoint list from the cluster
		vertex_list = rand(1:length(cluster.points),num_waypoints)
		point_list = [cluster.points[i] for i in vertex_list]
		#Add the mobile node to the graph
		push!(point_list,m.starting_point)
		#Generate subgraph
		subgraph = generate_graph(point_list)
		#Visit node with LATP algorithm, starting from the node position
		last_node_visited =  latp_algorithm(m,subgraph,nv(subgraph),m.alpha)
		m.starting_point =	point_list[last_node_visited]
	end
end

#TODO: This would be more efficient if the edge weights are generated first and then the Graph is constructed, according to SimpleWeightedGraph doc
function generate_graph(point_list::Array{Tuple{Int64,Int64},1})
	g = SimpleWeightedGraph()
	for j in 1:length(point_list)
		add_vertex!(g)
		for i in 1:nv(g)-1
			add_edge!( g, i, nv(g), node_distance(point_list[i],point_list[nv(g)]))
		end
	end
	return g
end


function select_cluster(clusters::Vector{Cluster})
		cluster_ordered = sort([(length(clusters[i].points),i) for i in 1:length(clusters)],rev=true)
		prob_vector = map(d->d[1],cluster_ordered)
		prob_sum = sum( prob_vector )
		prob_vector = map( d -> d / prob_sum, prob_vector)
		#Find node: the probability of selecting a node i is the sum of the probability of all preceiding probs
		next = -1
		p = rand()
		for i in 1:length(cluster_ordered)
			if p <= sum(prob_vector[1:i])
				next = cluster_ordered[i][2]
				break
			end
		end
		return clusters[next]
end