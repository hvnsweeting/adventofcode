from z3 import Int, solve, BitVec

def part1():
    s = open("src/input24").read()

    s1, s2 = s.split("\n\n")
    ns1 = (s1.replace(": ", "=="))
    ns2 = (s2.replace("AND", "&").replace("XOR", "^").replace("OR", "|").replace("->", "=="))


    import re
    allvars = (', '.join(re.findall("[0-9a-z]+", s2)))
    av = (' '.join(re.findall("[0-9a-z]+", s2)))
    out = []
    prefix = """
    from z3 import BitVecs, Solver

    s = Solver()"""

    out.append(prefix)
    out.append("{} = BitVecs('{}', 64)".format(allvars, av))

    for line in ns1.splitlines():
        out.append(f"s.add({line})")
    for line in ns2.splitlines():
        out.append(f"s.add({line})")

    out.append("""

    print(s.check())
    m = s.model()
    r = []
    for v in m:
        sym = v()
        val = m[v]
        if str(sym).startswith("z"):
            r.append((str(sym), str(val)))
        print(sym, val)
    r.sort(reverse=True)
    print(r)
    print(int("".join([i[1] for i in r]), 2))
        """)

    print(exec("\n".join(out), {}))

s = open("src/input24").read()

s1, s2 = s.split("\n\n")
ns1 = (s1.replace(": ", "=="))
ns2 = (s2.replace("AND", "&").replace("XOR", "^").replace("OR", "|").replace("->", "=="))


import re
rfa = re.findall("[0-9a-z]+", s2)
print("all vars", len(rfa))
allvars = (', '.join(rfa))
av = (' '.join(re.findall("[0-9a-z]+", s2)))
out = []
prefix = """
from z3 import BitVecs, Solver

s = Solver()"""

out.append(prefix)
out.append("{} = BitVecs('{}', 64)".format(allvars, av))

for line in ns1.splitlines():
    out.append(f"s.add({line})")
for line in ns2.splitlines():
    out.append(f"s.add({line})")

out.append("""

print(s.check())
m = s.model()
r = []
xs = []
ys = []
for v in m:
    sym = v()
    val = m[v]
    if str(sym).startswith("z"):
        r.append((str(sym), str(val)))
    if str(sym).startswith("x"):
        xs.append((str(sym),str(val)))
    if str(sym).startswith("y"):
        ys.append((str(sym),str(val)))

    #print(sym, val)
xs.sort(reverse=True)
ys.sort(reverse=True)
r.sort(reverse=True)
print(xs)
x = (int("".join([i[1] for i in xs]), 2))
print(x)
print(ys)
y = (int("".join([i[1] for i in ys]), 2))
print(y)
print("x+y", x+y, bin(x+y))
nr = (int("".join([i[1] for i in r]), 2))
print(r)
print(bin(x+y))
print(bin(nr))
    """)

print(exec("\n".join(out), {}))

