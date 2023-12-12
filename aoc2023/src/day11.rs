use std::collections::HashMap;
use std::collections::HashSet;

fn path_len(p1: (usize, usize), p2: (usize, usize)) -> i64 {
    let (x1, y1) = p1;
    let (x2, y2) = p2;
    ((x1).abs_diff(x2) + (y1).abs_diff(y2)) as i64
}

fn expand(s: &str, times: usize) -> HashSet<(usize, usize)> {
    let mut res = String::new();
    let mut vs = s.trim().lines();
    let mut hm: HashMap<(usize, usize), char> = HashMap::new();
    for (y, line) in vs.clone().enumerate() {
        for (x, c) in line.chars().enumerate() {
            if c == '#' {
                hm.insert((x, y), c);
            }
        }
    }
    let mut xs: HashSet<usize> = HashSet::new();
    let mut ys: HashSet<usize> = HashSet::new();
    for &(x, y) in hm.keys() {
        xs.insert(x);
        ys.insert(y);
    }
    let mut ehm: HashSet<(usize, usize)> = HashSet::new();

    let mut ygaps = 0;
    for (y, line) in vs.enumerate() {
        let mut xgaps = 0;
        if !ys.contains(&y) {
            ygaps += 1;
        }
        for (x, c) in line.chars().enumerate() {
            if !xs.contains(&x) {
                xgaps += 1;
            }
            if c == '#' {
                ehm.insert((x - xgaps + xgaps * times, y - ygaps + ygaps * times));
            }
        }
    }

    ehm
}

fn pairs(galaxies: HashSet<(usize, usize)>) -> HashSet<((usize, usize), (usize, usize))> {
    let mut pairs: HashSet<((usize, usize), (usize, usize))> = HashSet::new();
    for (idx, &v) in galaxies.iter().enumerate() {
        for &key2 in galaxies.iter().skip(idx + 1) {
            pairs.insert((v, key2));
        }
    }
    pairs
}

pub fn part1(s: &str) -> i64 {
    let galaxies: HashSet<(usize, usize)> = expand(s, 2);
    let pairs = pairs(galaxies);
    pairs.iter().map(|(p1, p2)| path_len(*p1, *p2)).sum()
}

pub fn part2(s: &str, times: usize) -> i64 {
    let galaxies = expand(s, times);
    let pairs = pairs(galaxies);
    pairs.iter().map(|(p1, p2)| path_len(*p1, *p2)).sum()
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    const SRAW: &str = "
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....";
    #[test]
    fn p1() {
        assert_eq!(part1(SRAW), 374);
        let s2 = fs::read_to_string("./src/input11.txt").unwrap();
        assert_eq!(part1(s2.as_str()), 9233514);
    }

    #[test]
    fn p2() {
        assert_eq!(part2(SRAW, 10), 1030);
        let s2 = fs::read_to_string("./src/input11.txt").unwrap();
        assert_eq!(part2(s2.as_str(), 1_000_000), 363293506944);
    }
}
