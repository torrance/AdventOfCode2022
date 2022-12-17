mutable struct Valve
    label::Symbol
    rate::Int
    children::Vector{Valve}
end

struct Spacetime
    pos::Symbol
    time::Int
end

mutable struct Edge
    spacetime::Vector{Spacetime}
    profit::Int
    opened::Vector{Symbol}
end

"""Calculate shortest distance between initial valve and all other valves"""
function shortest(init::Valve)
    distances = Dict{Symbol, Int}(init.label => 1)  # Init with 1, for cost of turning on valve

    edges = [init]
    while !isempty(edges)
        edge = popfirst!(edges)
        cost = distances[edge.label]

        for child in edge.children
            if child.label ∉ keys(distances)
                distances[child.label] = cost + 1
                push!(edges, child)
            end
        end
    end

    distances
end

"""Perform BFS with pruning to find maximal flow rate"""
function maximalflow(init::Edge, pathlengths; timelimit)
    edges = [init]
    maxflow = 0

    for t in 1:timelimit
        for n in eachindex(init.spacetime)
            # Get all edges ready to move at current time
            for edge in splice!(edges, findall(e -> e.spacetime[n].time == t, edges))

                for (dest, steps) in pathlengths[edge.spacetime[n].pos]
                    if t + steps <= timelimit && dest ∉ edge.opened && valves[dest].rate > 0
                        future = deepcopy(edge)
                        future.spacetime[n] = Spacetime(dest, t + steps)
                        push!(future.opened, dest)
                        future.profit += (timelimit - future.spacetime[n].time + 1) * valves[dest].rate
                        push!(edges, future)

                        maxflow = max(future.profit, maxflow)
                    end
                end
            end
        end

        # Prune edges by removing any edges with identical spacetime values
        # and only leaving the most profitable.
        pruned = Dict{Vector{Spacetime}, Edge}()
        for edge in edges
            other = get!(pruned, edge.spacetime) do
                edge
            end
            if edge.profit > other.profit
                pruned[edge.spacetime] = edge
            end
        end
        edges = collect(values(pruned))
    end

    return maxflow
end

lines = readlines("input.txt")

# Allocate valves
valves = Dict{Symbol, Valve}()
for line in lines
    words = split(line)
    valves[Symbol(words[2])] = Valve(
        Symbol(words[2]),
        parse(Int, words[5][6:end-1]),
        Valve[],
    )
end

# Connect valves
for line in lines
    words = split(line)
    parent = Symbol(words[2])
    children = Symbol.(strip.(words[10:end], ','))

    parent = valves[parent]
    for child in children
        child = valves[child]
        push!(parent.children, child)
    end
end

const pathlengths::Dict{Symbol, Dict{Symbol, Int}} = Dict(v.label => shortest(v) for v in values(valves))

# Part 1
part1 = maximalflow(
    Edge([Spacetime(:AA, 1)], 0, Int[]),
    pathlengths;
    timelimit=30
)
println("Part 1: maximal flow is $(part1)")

# Part 2
part2 = maximalflow(
    Edge([Spacetime(:AA, 1), Spacetime(:AA, 1)], 0, Int[]),
    pathlengths;
    timelimit=26
)
println("Part 2: maximal flow with the help of the elephant is $(part2)")