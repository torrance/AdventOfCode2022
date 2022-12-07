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
Traverse the filesystem tree and calculate the total file size for each folder.
Call function f() after summing each directory.
"""
function calculatesize(f, dir)
    dirsize = 0
    for (key, val) in dir
        if typeof(val) == FILE
            dirsize += val
        else
            dirsize += calculatesize(f, dir[key])
        end
    end

    f(dirsize)
    return dirsize
end

# Construct our filesystem tree
root = DIR()
lines = eachline("input.txt")
iterate(lines)  # skip "cd /"
parseinput(root, lines)

# Part 1
part1 = Ref{Int}(0)
used = calculatesize(root) do dirsize
    if dirsize <= 100_000
        part1[] += dirsize
    end
end
println("Part 1 sum: ", part1[])

# Part 2
tofree = 30000000 - (70000000 - used)

part2 = Ref{Int}(70000000)  # Initialize to total system filesize
calculatesize(root) do dirsize
    if tofree < dirsize < part2[]
        part2[] = dirsize
    end
end
println("Part 2 directory size to delete: ", part2[])