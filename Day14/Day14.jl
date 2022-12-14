const XY = Tuple{Int, Int}

function sandfall(ground; floor=typemax(Int), infinity=typemax(Int), origin=(500, 0))
    sands = Set{XY}()

    while true
        sand = origin

        while true
            # Return early if sand has fallen off to infinity
            sand[2] == infinity && return sands

            # Try to find new position in order of precedence
            for offset in ((0, 1), (-1, 1), (1, 1))
                next = sand .+ offset

                if next[2] != floor && next ∉ ground && next ∉ sands
                    sand = next
                    @goto found  # Yes I'm using a goto
                end
            end

            # We're stuck.
            push!(sands, sand)
            if sand == origin
                return sands
            else
                break
            end

            @label found
        end
    end
end

# Populate ground
const ground::Set{XY} = Set{XY}()

for line in eachline("input.txt")
    line = split.(split(line, " -> "), ',')
    line = map(x -> parse.(Int, x), line)

    for ((x1, y1), (x2, y2)) in zip(line, line[2:end])
        for x in min(x1, x2):max(x1, x2), y in min(y1, y2):max(y1, y2)
            push!(ground, (x, y))
        end
    end
end

const maxheight::Int = maximum(last, ground)

# Part 1
sands = sandfall(ground, infinity=maxheight)
println("There are $(length(sands)) granules of sand piled up before flowing into the abyss")

# Part 2
sands = sandfall(ground, floor=maxheight + 2)
println("There are $(length(sands)) granules of sand piled up on the floor")