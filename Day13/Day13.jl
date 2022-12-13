function inorder(left::Int, right::Int)
    left == right && return nothing
    left < right && return true
    left > right && return false
end

inorder(left::Int, right::Vector) = inorder([left], right)
inorder(left::Vector, right::Int) = inorder(left, [right])

function inorder(left::Vector, right::Vector)
    for (x, y) in zip(left, right)
        ord = inorder(x, y)
        if !isnothing(ord)
            return ord
        end
    end

    length(left) < length(right) && return true
    length(left) > length(right) && return false
    return nothing
end

packets = map(Iterators.filter(!isempty, eachline("input.txt"))) do line
    return eval(Meta.parse(line))
end

# Part 1
total = sum(enumerate(Iterators.partition(packets, 2))) do (i, (left, right))
    inorder(left, right) ? i : 0
end
println("There are $(total) packets in order")

# Part 2
push!(packets, [[2]])
push!(packets, [[6]])
sort!(packets, lt=inorder)
product = findfirst(==([[2]]), packets) * findfirst(==([[6]]), packets)
println("The decoder key is $(product)")