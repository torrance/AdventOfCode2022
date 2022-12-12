mutable struct Monkey
    items::Vector{Int}
    operation::Function
    divisor::Int
    option1::Int
    option2::Int
    inspected::Int
end

function Monkey()
    return Monkey(Int[], identity, 0, 0, 0, 0)
end

function runrounds(monkeys, N; relax)
    # To avoid overflow, remove a multiple of the common product of all divisors
    # (including the 'relaxing' divisor of 3, used in part one)
    commonproduct = prod(monkey.divisor for monkey in monkeys) * 3

    for round in 1:N
        for monkey in monkeys
            for _ in 1:length(monkey.items)
                # Log the inspecton
                monkey.inspected += 1

                item = popfirst!(monkey.items)
                item = monkey.operation(item)::Int

                # Check for and mitigate Int64 overflow
                @assert item >= 0 "Overflowed!"
                item = rem(item, commonproduct)

                if relax
                    item = fld(item, 3)
                end

                # Note monkey indices are 0-indexed
                if item % monkey.divisor == 0
                    push!(monkeys[monkey.option1 + 1].items, item)
                else
                    push!(monkeys[monkey.option2 + 1].items, item)
                end
            end
        end
    end
end

global const monkeys::Vector{Monkey} = []

# Parse the input into a vector of Monkeys
foreach(eachline("input.txt")) do line
    parts = split(line)
    if isempty(parts)
        # pass
    elseif parts[1] == "Monkey"
        push!(monkeys, Monkey())
    elseif parts[1] == "Starting"
        last(monkeys).items = parse.(Int, strip.(parts[3:end], ','))
    elseif parts[1] == "Operation:"
        op = parts[5] == "*" ? (*) : (+)
        val = parts[6] == "old" ? :old : parse(Int, parts[6])
        last(monkeys).operation = @eval function(old)
            return $op(old, $val)
        end
    elseif parts[1] == "Test:"
        last(monkeys).divisor = parse(Int, parts[4])
    elseif parts[2] == "true:"
        last(monkeys).option1 = parse(Int, parts[6])
    elseif parts[2] == "false:"
        last(monkeys).option2 = parse(Int, parts[6])
    else
        @assert false "Unreachable: got $(line)"
    end
end

# Part 1
monkeys1 = deepcopy(monkeys)
runrounds(monkeys1, 20; relax=true)
part1 = prod(partialsort!([m.inspected for m in monkeys1], 1:2, rev=true))
println("Part 1: monkey business level is $(part1)")

# Part 2
monkeys2 = deepcopy(monkeys)
runrounds(monkeys2, 10_000; relax=false)
part2 = prod(partialsort!([m.inspected for m in monkeys2], 1:2, rev=true))
println("Part 2: monkey business level is $(part2)")