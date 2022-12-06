 # Julia provides `isunique()` O(log n) but this is optimised for large arrays.
 # For small arrays, the O(n^2) exhaustive search is faster and non-allocating.
 function alluniqueN2(xs)
    for (i, x) in enumerate(xs)
        for (j, y) in enumerate(xs)
            if i != j && x == y
                return false
            end
        end
    end
    return true
end

function findunique(data, N)
    for (istart, istop) in zip(1:length(data), N:length(data))
        if alluniqueN2(@view data[istart:istop])
            return istop
        end
    end

    throw(ErrorException("No starting index found"))
end

const data::Vector{UInt8} = read(joinpath(@__DIR__, "input.txt"))

# Part 1
println("Start of packet: ", findunique(data, 4))

# Part 2
println("Start of message: ", findunique(data, 14))
