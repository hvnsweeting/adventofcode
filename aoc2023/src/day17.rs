use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::collections::HashMap;

const UP: (i64, i64) = (0, -1);
const DOWN: (i64, i64) = (0, 1);
const RIGHT: (i64, i64) = (1, 0);
const LEFT: (i64, i64) = (-1, 0);

fn build_map(s: &str) -> (HashMap<(i64, i64), i64>, (i64, i64)) {
    let mut vs = s.trim().lines();
    let mut height: i64 = 0;
    let mut width: i64 = 0;
    let mut hm: HashMap<(i64, i64), i64> = HashMap::new();
    for (y, line) in vs.clone().enumerate() {
        height += 1;
        width = line.chars().count() as i64;
        for (x, c) in line.chars().enumerate() {
            hm.insert((x as i64, y as i64), c.to_string().parse().unwrap());
        }
    }
    (hm, (width, height))
}

fn print_map(m: HashMap<(i64, i64), i64>, w: &i64, h: &i64) {
    println!("----------------------");
    for y in 0..*h {
        for x in 0..*w {
            match m.get(&(x, y)) {
                Some(v) => print!("{}", v),
                None => print!("."),
            }
        }
        println!();
    }
    println!("----------------------");
}

fn neighbors(point: (i64, i64), dir: (i64, i64), count: i64) -> Vec<State> {
    let mut res: Vec<State> = vec![];

    if count == 3 {
        match dir {
            UP => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            DOWN => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            LEFT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            RIGHT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            _ => {
                panic!("BAD DIR");
            }
        }
    } else {
        res.push(((point.0 + dir.0, point.1 + dir.1), dir, count + 1));
        match dir {
            UP => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            DOWN => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            LEFT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            RIGHT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            _ => {
                panic!("BAD DIR");
            }
        }
    }
    res
}
pub fn part1(s: &str) -> i64 {
    let (m, (w, h)) = build_map(s);
    dbg!(&(w, h));
    print_map(m.clone(), &w, &h);
    let dest = (w - 1, h - 1);

    let mut q = BinaryHeap::new();
    let mut visitted: HashMap<State, i64> = HashMap::new();

    q.push(Reverse((0, (0, 0), RIGHT, 0)));
    q.push(Reverse((0, (0, 0), DOWN, 0)));
    let mut min: i64 = i64::MAX;

    while !q.is_empty() {
        let Reverse((len, p, dir, count)) = q.pop().unwrap();
        if p == dest {
            if len < min {
                min = len;
                println!("min: {}", min);
            }
        }
        if len > min {
            continue;
        }
        let next = neighbors(p, dir, count);
        println!(
            "{}.{} {} ({}-{}) {}",
            &p.0, &p.1, &count, &dir.0, &dir.1, &len
        );
        //dbg!(&next);

        for (node, d2, c2) in next {
            if m.contains_key(&node) {
                //println!("next {}.{}: val {}", node.0, node.1, m[&node]);
                if visitted.contains_key(&(node, d2, c2)) {
                    if m[&node] + len < visitted[&(node, d2, c2)] {
                        q.push(Reverse((m[&node] + len, node, d2, c2)));
                        visitted.insert((node, d2, c2), m[&node] + len);
                        //println!("UPDATE MIN {}.{}: val {}, current min {}", node.0, node.1, m[&node], visitted[&(node, d2, c2)]);
                    } else {
                        //println!("SKIP {}.{}: val {}, current min {}", node.0, node.1, m[&node], visitted[&(node, d2, c2)]);
                    }
                } else {
                    q.push(Reverse((m[&node] + len, node, d2, c2)));
                    visitted.insert((node, d2, c2), m[&node] + len);
                }
            }
        }
    }

    min
}

fn neighbors2(point: (i64, i64), dir: (i64, i64), count: i64) -> Vec<State> {
    let mut res: Vec<State> = vec![];

    if count == 10 {
        match dir {
            UP => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            DOWN => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            LEFT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            RIGHT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            _ => {
                panic!("BAD DIR");
            }
        }
    } else if count < 4 {
        res.push(((point.0 + dir.0, point.1 + dir.1), dir, count + 1));
    } else {
        res.push(((point.0 + dir.0, point.1 + dir.1), dir, count + 1));
        match dir {
            UP => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            DOWN => {
                res.push(((point.0 + 1, point.1), RIGHT, 1));
                res.push(((point.0 - 1, point.1), LEFT, 1));
            }
            LEFT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            RIGHT => {
                res.push(((point.0, point.1 - 1), UP, 1));
                res.push(((point.0, point.1 + 1), DOWN, 1));
            }
            _ => {
                panic!("BAD DIR");
            }
        }
    }
    res
}

type State = ((i64, i64), (i64, i64), i64);

pub fn part2(s: &str) -> i64 {
    let (m, (w, h)) = build_map(s);
    dbg!(&(w, h));
    print_map(m.clone(), &w, &h);
    let dest = (w - 1, h - 1);

    let mut q = BinaryHeap::new();
    let mut visitted: HashMap<State, i64> = HashMap::new();

    q.push(Reverse((0, (0, 0), RIGHT, 0)));
    q.push(Reverse((0, (0, 0), DOWN, 0)));
    let mut min: i64 = i64::MAX;

    while !q.is_empty() {
        let Reverse((len, p, dir, count)) = q.pop().unwrap();
        if p == dest {
            if len < min {
                min = len;
                println!("min: {}", min);
            }
        }
        if len > min {
            continue;
        }
        let next = neighbors2(p, dir, count);
        //println!("{}.{} {} ({}-{}) {}", &p.0, &p.1, &count, &dir.0, &dir.1, &len);
        //dbg!(&next);

        for (node, d2, c2) in next {
            if m.contains_key(&node) {
                //println!("next {}.{}: val {}", node.0, node.1, m[&node]);
                if visitted.contains_key(&(node, d2, c2)) {
                    if m[&node] + len < visitted[&(node, d2, c2)] {
                        q.push(Reverse((m[&node] + len, node, d2, c2)));
                        visitted.insert((node, d2, c2), m[&node] + len);
                    } else {
                    }
                } else {
                    q.push(Reverse((m[&node] + len, node, d2, c2)));
                    visitted.insert((node, d2, c2), m[&node] + len);
                }
            }
        }
    }

    min
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    const S: &str = r#"
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"#;
    #[test]
    fn p1() {
        assert_eq!(part1(S), 102);
        let s2 = fs::read_to_string("./src/input17.txt").unwrap();
        assert_eq!(part1(s2.as_str()), 1263);
    }

    #[test]
    fn p2() {
        assert_eq!(part2(S), 94);
        let s2 = fs::read_to_string("./src/input17.txt").unwrap();
        assert_eq!(part2(s2.as_str()), 1411);
    }
}
