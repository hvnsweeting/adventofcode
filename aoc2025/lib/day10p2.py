from z3 import Solver, Ints, sat, Or, Int

# [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
# [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
# [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}

#b0, b1, b2, b3 = Ints('b0 b1 b2 b3')

line = '[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}'
line = ' [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}'
line = '[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}'

def find_fewest_button_presses(line):
    rhs = line.split('] ')[1]
    converted_to_tuple_expr =f'({rhs.replace(" ", ",").replace("{", "[").replace("}", "]")})'
    *buttons, jolts = eval(converted_to_tuple_expr)
    buttons = [(i,) if isinstance(i, int) else i for i in buttons]
    print(buttons, jolts)
    xs = []
    s = Solver()
    for idx, b in enumerate(buttons):
        v = Int(f'x{idx}')
        xs.append(v)
        s.add(v >= 0)
    #print(xs)
    #x0, x1, x2, x3, x4, x5 = Ints('x0 x1 x2 x3 x4 x5')

    for vidx, v in enumerate(jolts):
        lhs = []
        for bidx, b in enumerate(buttons):
            if vidx in b:
                lhs.append(f"xs[{bidx}]")
        s.add(eval(" + ".join(lhs) + f' == {v}'))

    #s.add(x4 + x5 == 3)
    #s.add(x1 + x5 == 5)
    #s.add(x2 + x3 + x4 == 4)
    #s.add(x0 + x1 + x3 == 7)
    #s.add(x0 >= 0)
    #s.add(x1 >= 0)
    #s.add(x2 >= 0)
    #s.add(x3 >= 0)
    #s.add(x4 >= 0)
    #s.add(x5 >= 0)
    all_sums = []
    while s.check() == sat:
        m = (s.model())
        #print(m)

        block = []
        subsum = 0

        for var in m:
            v = var()
            subsum += m[var].as_long()
            block.append(v != m[var])
        s.add(Or(block))
        all_sums.append(subsum)

    return (min(all_sums))


res = 0
for line in open("../test/input10"):
    res += find_fewest_button_presses(line)
print(res)
