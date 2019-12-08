#!/usr/bin/env python
# https://adventofcode.com/2019/day/6

import networkx as nx


def make_tree(s, directed=True):
    if directed:
        dg = nx.DiGraph()
    else:
        dg = nx.Graph()

    for line in s.splitlines():
        dst, src = line.strip().split(")")

        dg.add_edge(src, dst)
    return dg


def spath(test):
    return [
        max(v.values(), key=lambda i: len(i))
        for (_, v) in list(nx.all_pairs_shortest_path(test))
    ]


def main():
    test = make_tree(
        """COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L""".strip()
    )
    print(sum([len(i) - 1 for i in spath(test)]))

    p2 = make_tree(
        """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN""".strip(),
        directed=False,
    )
    print(len(nx.shortest_path(p2, "YOU", "SAN")) - 3)

    s = open("input").read().strip()
    paths = spath(make_tree(s))
    print(sum([len(i) - 1 for i in paths]))

    p2 = make_tree(s, directed=False)
    print(len(nx.shortest_path(p2, "YOU", "SAN")) - 3)


if __name__ == "__main__":
    main()
