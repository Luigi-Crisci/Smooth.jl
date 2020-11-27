X_DIM = 3000
Y_DIM = 3000

canvas = Canvas(X_DIM, Y_DIM)
initialize(canvas,30,1000,1)
# for i in 1:length(canvas.clusters)
#     println(canvas.clusters[i])
# end
Points = collect(Iterators.flatten([canvas.clusters[i].points for i in 1:length(canvas.clusters)]))
X = [ Points[i][1] for i in 1:length(Points) ]
Y = [ Points[i][2] for i in 1:length(Points) ]

println(filter(x -> x >X_DIM,X))
println(filter(x -> x >Y_DIM,Y))

# gr()
plot( X, Y, seriestype = :scatter,xlims = (0,X_DIM), ylims = (0,Y_DIM))
savefig("canvas.png")