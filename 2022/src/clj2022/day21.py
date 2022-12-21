from z3 import *

s = Solver()

lines = open("2022/src/clj2022/input21").readlines()

for line in lines:
    varname = line.split(':')[0]
    # metaprogramming hahahaha
    locals()[varname] = Real(varname)

for line in lines:
    if line.startswith('humn:'):
         continue
    if line.startswith('root:'):
         print("ROOT", line)
         #root: dbcq + zmvq
         _root, one, _ops, two = line.split()
         s.add(locals()[one] == locals()[two])

    s.add(eval(line.replace(':', '==')))

print(s.check())
m =(s.model())

print("humn", m.eval(humn))
