function findunique(data, N)
    for (istart, istop) in zip(1:length(data), N:length(data))
        if allunique(@view data[istart:istop])
            return istop
        end
    end

    throw(ErrorException("No starting index found"))
end

const data::Vector{Char} = collect(Char, read("input.txt"))

# Part 1
println("Start of packet: ", findunique(data, 4))

# Part 2
println("Start of message: ", findunique(data, 14))
