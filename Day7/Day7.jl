const FILE = Int
const DIR = Dict{String, Union{FILE, Dict}}

"""
Convert the input into a tree structure with DIR and FILE nodes
"""
function parseinput(dir, lines)
    for line in lines
        if line == "\$ ls"
            # pass
        elseif line == "\$ cd .."
            return
        elseif line[1:4] == "\$ cd"
            fname = line[6:end]
            parseinput(dir[fname], lines)
        elseif line[1:3] == "dir"
            fname = line[5:end]
            dir[fname] = DIR()
        else
            # Otherwise we assume it's a file listing
            size, name = split(line)
            dir[name] = parse(Int, size)
        end
    end
end

"""
Traverse the filesystem tree and enter each directory size into a flat listing
"""
function dirsizes!(dirsizes, current)
    dirsize = 0
    for child in values(current)
        if typeof(child) == FILE
            dirsize += child
        else
            dirsize += dirsizes!(dirsizes, child)
        end
    end

    push!(dirsizes, dirsize)
    return dirsize
end

# Construct our filesystem tree
root = DIR()
lines = eachline("input.txt")
iterate(lines)  # skip "cd /"
parseinput(root, lines)

# Next, find sizes of all directories flattened into a vector
dirsizes = Int[]
used = dirsizes!(dirsizes, root)

# Part 1
part1 = filter(<=(100_000), dirsizes) |> sum
println("Part 1 sum: ", part1)

# Part 2
tofree = 30000000 - (70000000 - used)
part2 = filter(>=(tofree), dirsizes) |> minimum
println("Part 2 directory size to delete: ", part2)