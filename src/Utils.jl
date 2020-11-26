export bounded_sum
export bounded_diff
export random_array_fixed_sum

function bounded_sum(x::Int64,y::Int64,bound::Int64)
	return x + y < bound ? x + y : bound
end

function bounded_diff(x::Int64,y::Int64,bound::Int64)
	return x - y > bound ? x - y : bound
end

function random_array_fixed_sum(sum_value::Int64,array_size::Int64)
	if sum_value == 0
		return [ 0 for i in 1:array_size ]
	end
	
	total = sum_value
	array = []
	for i in 1:array_size-1
		push!(array,rand(1:total - (array_size - i) ))
		total -= array[i]
	end
	push!(array,total)

	return array
end