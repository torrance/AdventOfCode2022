# Collate the input.txt into Vector of summed calories per elf
const rations::Vector{Int} = Int[]

lines = eachline(joinpath(@__DIR__, "input.txt"))
while !isempty(lines)
    push!(
        rations,
        sum(parse.(Int, Iterators.takewhile(!isempty, lines)))
    )
end

calories, elfid = findmax(rations)
println("Elf $(elfid) has the most rations with $(calories) calories.");

top3 = partialsort!(rations, 1:3, rev=true)
println("The top 3 elves have a total of $(sum(top3)) calories amongst them.")