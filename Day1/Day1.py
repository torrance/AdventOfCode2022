from itertools import takewhile

rations = []
with open("input.txt") as f:
    while True:
        chunk = takewhile(lambda x: x != "\n", f)
        if calories := sum(map(lambda x: int(x.strip()), chunk)):
            rations.append(calories)
        else:
            break

print("Max calories:", max(rations))
print("Sum of three a largest:", sum(sorted(rations, reverse=True)[:3]))