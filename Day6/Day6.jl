function findunique(data, N)
    for (istart, char) in enumerate(data[N:end])
        istop = istart + N - 1

        if allunique(@view data[istart:istop])
            return istop
        end
    end

    raise(ErrorException("No starting index found"))
end

const data::Vector{Char} = collect(Char, read("input.txt"))

# Part 1
println("Start of packet: ", findunique(data, 4))

# Part 2
println("Start of message: ", findunique(data, 14))
