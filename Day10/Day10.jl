const values::Vector{Int} = Int[]

foldl(eachline("input.txt"); init=1) do register::Int, line::String
    if line == "noop"
        # 1 cycle
        push!(values, register)
        return register
    else
        # 2 cycles
        push!(values, register)
        push!(values, register)
        return register + parse(Int, split(line)[2])
    end
end

# Part 1
part1 = sum([20, 60, 100, 140, 180, 220]) do cycle
    cycle * values[cycle]
end
println("The product of cycles is ", part1)

# Part 2
const crt::Matrix{Char} = fill(' ', 6, 40)
for (cycle, val) in enumerate(values)
    row, col = fldmod1(cycle, 40)
    if -1 <= (col - val - 1) <= 1  # columns are 0-indexed!
        crt[row, col] = '\u2588'
    end
end

println("The CRT displays:")
display(String.(eachrow(crt)))