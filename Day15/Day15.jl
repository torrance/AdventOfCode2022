using StaticArrays

const XY = SVector{2, Int}

struct Sensor
    pos::XY
    radius::Int
end

dist(pos1::XY, pos2::XY) = abs(pos1[1] - pos2[1]) + abs(pos1[2] - pos2[2])

function scanrow(sensors, beacons, y)
    # Find all points along row y that are inside the radius of each sensor
    xs = union(map(sensors) do sensor
        xwidth = sensor.radius - abs(sensor.pos[2] - y)
        return (sensor.pos[1] - xwidth):(sensor.pos[1] + xwidth)
    end...)

    # Subtract from this list the beacons
    for beacon in beacons
        if beacon[2] == y
            deleteat!(xs, findfirst(==(beacon[1]), xs))
        end
    end

    return xs
end

function getedges(sensor; xmin, xmax, ymin, ymax)
    xmin = max(xmin, sensor.pos[1] - sensor.radius - 1)
    xmax = min(xmax, sensor.pos[1] + sensor.radius + 1)

    edges = XY[]
    for x in xmin:xmax
        yheight = sensor.radius - abs(x - sensor.pos[1]) + 1

        if sensor.pos[2] + yheight <= ymax
            push!(edges, XY(x, sensor.pos[2] + yheight))
        end
        if sensor.pos[2] - yheight >= ymin
            push!(edges, XY(x, sensor.pos[2] - yheight))
        end
    end

    return edges
end

function sensed(sensors, pos)
    for sensor in sensors
        if dist(sensor.pos, pos) <= sensor.radius
            return true
        end
    end
    return false
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
part1 = length(scanrow(sensors, beacons, 2000000))
println("Part 1: In row 2000000, $(part1) positions cannot contain a beacon")

# Part 2
# Since there's only one empty square, we only need bother searching the periphery
# of sensor areas
edges = union(map(sensors) do sensor
    getedges(sensor; xmin=0, xmax=4000000, ymin=0, ymax=4000000)
end...)

for edge in edges
    if !sensed(sensors, edge)
        println("Part 2: Position $(edge) was not sensed; giving a tuning frequency of ", edge[1] * 4000000 + edge[2])
        break
    end
end