using Symbolics

struct Operation
    monkey1::Symbol
    monkey2::Symbol
    operation::Function
end

struct Me
    val::Int
end

getval(x::Int) = x

function getval(x::Operation)
    x.operation(
        getval(monkeys[x.monkey1]),
        getval(monkeys[x.monkey2])
    )
end

# Populate the monkeys dictionary
monkeys = Dict{Symbol, Union{Int, Operation, Me}}()
for line in eachline("input.txt")
    words = split(line)

    name = Symbol(words[1][begin:end-1])
    if name == :humn
        monkeys[name] = Me(parse(Int, words[2]))
    elseif length(words) > 2
        # Operation
        monkeys[name] = Operation(
            Symbol(words[2]),
            Symbol(words[4]),
            Dict("*" => *, "/" => /, "+" => +, "-" => -)[words[3]]
        )
    else
        monkeys[name] = parse(Int, words[2])
    end
end

# Part 1
getval(x::Me) = x.val
println("Root monkey yells: ", Int(getval(monkeys[:root])))

# Part 2
@variables x
getval(::Me) = x
part2 = Symbolics.solve_for(
    getval(monkeys[monkeys[:root].monkey1]) ~ getval(monkeys[monkeys[:root].monkey2]),
    x
)
println("I need to yell: ", round(Int, Symbolics.value(part2)))