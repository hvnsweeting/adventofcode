import sys
lines = open(sys.argv[1]).readlines()

with open("newinput09", 'w') as f:
    for line in lines:
        s, n = line.split()
        for i in range(int(n)):
            f.write(f"{s} 1\n")
