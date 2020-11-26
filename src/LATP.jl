module LATP

using LightGraphs,SimpleWeightedGraphs
using Random

"""
```julia
	latp_algorithm(G:SimpleWeightedGraph,s::Int)
```
	Perform the *Least-Action trip planning* algorithm on G, starting from s with alpha parameter
"""
latp_algorithm(G::SimpleWeightedGraph,s::Int,alpha::Int)
export latp_algorithm
function latp_algorithm(G::SimpleWeightedGraph,s::Int,alpha::Int)
	V = Set(vertices(G))
	Random.seed!(time_ns())
	Visited = Set(s)
	c = s

	next = 0
	while V != Visited
		#Firstly, get all unvisited nodes next to current node and order them in closeness
		neighbors_ordered = sort([ (G.weights[c,i],i) for i in setdiff(neighbors(G,c),Visited)])
		#Then the probability vector is calculated
		prob_vector = map( d->(1/d[1])^alpha, neighbors_ordered)
		prob_sum = sum( prob_vector )
		prob_vector = map( d -> d / prob_sum, prob_vector)
		#Find node: the probability of selecting a node i is the sum of the probability of all preceiding probs
		p = rand()
		for i in 1:length(neighbors_ordered)
			if p <= sum(prob_vector[1:i])
				next = neighbors_ordered[i][2]
				break
			end
		end
		#TODO: Add pause time 
		push!(Visited,next) 
		c = next
	end
	return c
end

end	