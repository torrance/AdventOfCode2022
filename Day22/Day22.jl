struct Moves
    data::Iterators.Stateful{Vector{Char}}
    Moves(data::Vector{Char}) = new(Iterators.Stateful(data))
end

function Base.popfirst!(m::Moves)
    char = popfirst!(m.data)
    if !isdigit(char)
        return char
    end

    number = string(char)
    while(!isempty(m.data) && isdigit(peek(m.data)))
        number *= popfirst!(m.data)
    end
    return parse(Int, number)
end

Base.isempty(m::Moves) = isempty(m.data)

const Right = CartesianIndex(1, 0)
const Left = CartesianIndex(-1, 0)
const Up = CartesianIndex(0, -1)
const Down = CartesianIndex(0, 1)

const points = Dict(
    Right => 0,
    Down => 1,
    Left => 2,
    Up => 3,
)

function walk(grid, moves)
    # Initialize starting state
    idx = CartesianIndex(findfirst(!=(' '), grid[:, 1]), 1)
    delta = CartesianIndex(1, 0)

    # Read through and apply each move
    while (!isempty(moves))
        move = popfirst!(moves)

        if typeof(move) == Int
            idx, delta = nextindex(grid, idx, delta, move)
        elseif typeof(move) == Char
            delta = nextdelta(delta, move)
        end
    end

    return idx, delta
end

function nextdelta(current::CartesianIndex, turn::Char)
    turnmatrix = Dict(
        'L' => [0 -1; 1 0],
        'R' => [0 1; -1 0]
    )

    return CartesianIndex(
        (turnmatrix[turn] * ([Tuple(current)...] .* [1, -1])) .* [1, -1]...
    )
end

# Load data
lines = eachline("input.txt")
gridlines = collect(Iterators.takewhile(!isempty, lines))
moves = Moves(collect(Char, first(iterate(lines))))

grid = fill(' ', maximum(length, gridlines), length(gridlines))
for (i, gridline) in enumerate(gridlines)
    grid[begin:length(gridline), i] .= collect(Char, gridline)
end

# Part 1
function nextindex(grid, idx, delta, N)
    x, y = Tuple(idx)
    xnext, ynext = x, y
    dx, dy = Tuple(delta)

    n = 0
    while n < N
        xnext = mod1(xnext + dx, size(grid, 1))
        ynext = mod1(ynext + dy, size(grid, 2))

        if grid[xnext, ynext] == '#'
            break
        end

        if grid[xnext, ynext] == '.'
            x, y = xnext, ynext
            n += 1
        end
    end
    return CartesianIndex(x, y), delta
end

idx, delta = walk(grid, deepcopy(moves))
println("Part 1: ", sum(Tuple(idx) .* (4, 1000)) + points[delta])

# Part 2
function nextindex(grid, idx, delta, N)
    for _ in 1:N
        nextidx, nextdelta = normalize(idx + delta, delta)
        @assert grid[nextidx] != ' ' "Out of bounds! $(nextidx)"

        if grid[nextidx] == '#'
            break
        end

        idx, delta = nextidx, nextdelta
    end
    return idx, delta
end

# TODO: don't do this :)
function normalize(idx, delta)
    x, y = Tuple(idx)

    if x == 0 && 101 <= y <= 150 && delta == Left
        return CartesianIndex(51, 50 - (y - 101)), Right
    elseif x == 0 && 151 <= y <= 200 && delta == Left
        return CartesianIndex(y - 100, 1), Down
    elseif 1 <= x <= 50 && y == 100 && delta == Up
        return CartesianIndex(51, x + 50), Right
    elseif 1 <= x <= 50 && y == 201 && delta == Down
        return CartesianIndex(x + 100, 1), Down
    elseif x == 50 && 1 <= y <= 50 && delta == Left
        return CartesianIndex(1, 151 - y), Right
    elseif x == 50 && 51 <= y <= 100 && delta == Left
        return CartesianIndex(y - 50, 101), Down
    elseif x == 51 && 151 <= y <= 200 && delta == Right
        return CartesianIndex(y - 100, 150), Up
    elseif 51 <= x <= 100 && y == 0 && delta == Up
        return CartesianIndex(1, x + 100), Right
    elseif 51 <= x <= 100 && y == 151 && delta == Down
        return CartesianIndex(50, x + 100), Left
    elseif x == 101 && 51 <= y <= 100 && delta == Right
        return CartesianIndex(y + 50, 50), Up
    elseif x == 101 && 101 <= y <= 150 && delta == Right
        return CartesianIndex(150, 50 - (y - 101)), Left
    elseif 101 <= x <= 150 && y == 0 && delta == Up
        return CartesianIndex(x - 100, 200), Up
    elseif 101 <= x <= 150 && y == 51 && delta == Down
        return CartesianIndex(100, x - 50), Left
    elseif x == 151 && 1 <= y <= 50 && delta == Right
        return CartesianIndex(100, 150 - (y - 1)), Left
    else
        return idx, delta
    end
end

idx, delta = walk(grid, deepcopy(moves))
println("Part 2: ", sum(Tuple(idx) .* (4, 1000)) + points[delta])