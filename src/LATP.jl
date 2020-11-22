module LATP

using LightGraphs,SimpleWeightedGraphs

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
	Visited = Set(s)
	c = s

	next = 0
	while V != Visited
		p = -1
		prob_sum = sum( map( d->(1/d)^alpha ,[ G.weights[c,i] for i in setdiff(neighbors(g,c),Visited)]))
		for v in 1:setdiff(V,Visited)
			current_prob = ((1/G.weights[c,v]) ^ alpha) / prob_sum
			if current_prob > p
				p = current_prob
				next = v
			end
		push!(Visited,next) 
		c = next
	end
	return c
end

end