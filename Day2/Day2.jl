using DelimitedFiles

@enum Move Rock=1 Paper=2 Scissors=3

# e.g. given m::Move, wins[m] will produce a winning move against m
# or loses[m] will produce a losing move against m
const wins = Dict(Rock => Paper, Paper => Scissors, Scissors => Rock)
const draws = Dict(Rock => Rock, Paper => Paper, Scissors => Scissors)
const loses = Dict(Rock => Scissors, Paper => Rock, Scissors => Paper)

function getpoints(me::Move, them::Move)
    if me == wins[them]
        return 6 + Int(me)
    elseif me == draws[them]
        return 3 + Int(me)
    elseif me == loses[them]
        return 0 + Int(me)
    end
    @assert false "Unreachable"
end

strategy = DelimitedFiles.readdlm(joinpath(@__DIR__, "input.txt"), Char)

# Part 1
const decode1 = Dict(
    'A' => Rock,
    'B' => Paper,
    'C' => Scissors,
    'X' => Rock,
    'Y' => Paper,
    'Z' => Scissors,
)

points = sum(eachrow(strategy)) do (char1, char2)
    them, me = decode1[char1], decode1[char2]
    return getpoints(me, them)
end

println("Part 1 total points: ", points)

# Part 2
const decode2 = Dict('X' => loses, 'Y' => draws, 'Z' => wins)

points = sum(eachrow(strategy)) do (char1, char2)
    them = decode1[char1]
    me = decode2[char2][them]
    return getpoints(me, them)
end

println("Part 2 total points: ", points)