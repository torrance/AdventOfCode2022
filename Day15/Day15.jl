using StaticArrays

const XY = SVector{2, Int}

struct Sensor
    pos::XY
    radius::Int
end

dist(pos1::XY, pos2::XY) = abs(pos1[1] - pos2[1]) + abs(pos1[2] - pos2[2])

function merge!(xs::Vector{UnitRange{Int}})
    # We require xs to be sorted by UnitRange.start for this to work
    sort!(filter!(!isempty, xs), by=first)

    # In-place merge of UnitRanges
    N, y = 1, first(xs)
    for x in xs
        # Check for overlap
        if x.start <= y.start <= x.stop || y.start <= x.start <= y.stop
            y = min(x.start, y.start):max(x.stop, y.stop)  # resize y
            xs[N] = y
        else
            # No overlap: start a new y seeded by this round's x
            N += 1
            y = x
        end
    end

    return resize!(xs, N)
end

function scanrow(sensors, y; xmin=typemin(Int), xmax=typemax(Int))
    # Find all points along row y that are inside the radius of each sensor
    xs = map(sensors) do sensor
        xwidth = sensor.radius - abs(sensor.pos[2] - y)
        return max(xmin, sensor.pos[1] - xwidth):min(xmax, sensor.pos[1] + xwidth)
    end::Vector{UnitRange{Int}}

    return merge!(xs)
end

# Load data from input.txt
const beacons = XY[]
const sensors = Sensor[]

for line in eachline("input.txt")
    words = split(line)
    sensor = XY(
        parse(Int, words[3][3:end-1]),
        parse(Int, words[4][3:end-1])
    )
    beacon = XY(
        parse(Int, words[9][3:end-1]),
        parse(Int, words[10][3:end])
    )
    radius = dist(sensor, beacon)

    push!(beacons, beacon)
    push!(sensors, Sensor(sensor, radius))
end

unique!(beacons)  # the same beacon may be detected by multiple sensors

# Part 1
part1 = sum(length, scanrow(sensors, 2000000)) - count(b -> b[2] == 2000000, beacons)
println("Part 1: In row 2000000, $(part1) positions cannot contain a beacon")

# Part 2
for y in 0:4000000
    row = scanrow(sensors, y, xmin=0, xmax=4000000)
    if length(row) != 1
        freq = y + (row[1].stop + 1) * 4000000
        println("Part 2: The tuning frequency is $(freq)")
        break
    end
end