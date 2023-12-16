use std::collections::HashMap;
use std::collections::HashSet;

const UP: (i64, i64) = (0, -1);
const DOWN: (i64, i64) = (0, 1);
const RIGHT: (i64, i64) = (1, 0);
const LEFT: (i64, i64) = (-1, 0);

fn build_map(s: &str) -> (HashMap<(i64, i64), char>, (i64, i64)) {
    let mut vs = s.trim().lines();
    let mut height: i64 = 0;
    let mut width: i64 = 0;
    let mut hm: HashMap<(i64, i64), char> = HashMap::new();
    for (y, line) in vs.clone().enumerate() {
        height += 1;
        width = line.chars().count() as i64;
        for (x, c) in line.chars().enumerate() {
            hm.insert((x as i64, y as i64), c);
        }
    }
    (hm, (width, height))
}

fn print_map(m: HashMap<(i64, i64), char>, w: &i64, h: &i64) {
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

type Contraption = HashMap<(i64, i64), char>;

fn count_energized_tiles(
    start: (i64, i64),
    direction: (i64, i64),
    contraption: &Contraption,
) -> i64 {
    let mut ms: Vec<_> = vec![];
    ms.push((start, direction, contraption));
    let mut res: HashMap<(i64, i64), char> = HashMap::new();
    let mut visitted: HashSet<((i64, i64), (i64, i64))> = HashSet::new();
    while !ms.is_empty() {
        let (mut curr, mut dir, mut cm) = ms.pop().unwrap();
        loop {
            dbg!(curr, dir);
            if visitted.contains(&(curr, dir)) {
                break;
            }
            visitted.insert((curr, dir));
            let next = (curr.0 + dir.0, curr.1 + dir.1);
            if !cm.contains_key(&next) {
                break;
            }
            let cell = cm.get(&next).unwrap();
            res.insert(next, '#');
            curr = next;
            match *cell {
                '.' => {}
                '/' => {
                    dir = match dir {
                        RIGHT => UP,
                        LEFT => DOWN,
                        DOWN => LEFT,
                        UP => RIGHT,
                        _ => panic!("bad dir /"),
                    }
                }
                '\\' => {
                    dir = match dir {
                        // -->
                        RIGHT => DOWN,
                        LEFT => UP,
                        DOWN => RIGHT,
                        UP => LEFT,
                        _ => panic!("bad dir \\"),
                    }
                }
                '-' => {
                    dir = match dir {
                        // -->
                        RIGHT => RIGHT,
                        LEFT => LEFT,
                        DOWN => {
                            ms.push((next, RIGHT, contraption));
                            LEFT
                        }
                        UP => {
                            ms.push((next, RIGHT, contraption));
                            LEFT
                        }
                        _ => panic!("bad dir -"),
                    }
                }
                '|' => {
                    dir = match dir {
                        // -->
                        RIGHT => {
                            ms.push((next, DOWN, contraption));
                            UP
                        }
                        LEFT => {
                            ms.push((next, DOWN, contraption));
                            UP
                        }
                        DOWN => DOWN,
                        UP => UP,
                        _ => panic!("bad dir |"),
                    }
                }
                _ => panic!("Bad pattern"),
            }
        }
    }
    //print_map(res.clone(), w, h);
    res.keys().len() as i64
}

pub fn part1(s: &str) -> i64 {
    let (m, (w, h)) = build_map(s);
    dbg!(&(w, h));
    print_map(m.clone(), &w, &h);
    count_energized_tiles(LEFT, RIGHT, &m)
}

pub fn part2(s: &str) -> i64 {
    let (m, (w, h)) = build_map(s);
    print_map(m.clone(), &w, &h);

    let top_edge: Vec<_> = (0..w).map(|x| ((x, -1), DOWN)).collect();
    let bottom_edge: Vec<_> = (0..w).map(|x| ((x, h), UP)).collect();
    let left_edge: Vec<_> = (0..h).map(|y| ((-1, y), RIGHT)).collect();
    let right_edge: Vec<_> = (0..h).map(|y| ((w, y), LEFT)).collect();
    top_edge
        .iter()
        .chain(bottom_edge.iter())
        .chain(left_edge.iter())
        .chain(right_edge.iter())
        .map(|&(start, dir)| count_energized_tiles(start, dir, &m))
        .max()
        .unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    const S: &str = r#"
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"#;
    #[test]
    fn p1() {
        assert_eq!(part1(S), 46);
        let s2 = fs::read_to_string("./src/input16.txt").unwrap();
        assert_eq!(part1(s2.as_str()), 7788);
    }

    #[test]
    fn p2() {
        assert_eq!(part2(S), 51);
        let s2 = fs::read_to_string("./src/input16.txt").unwrap();
        assert_eq!(part2(s2.as_str()), 7987);
    }
}
