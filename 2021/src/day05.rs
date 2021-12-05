use regex::Regex;
use std::collections::HashSet;

fn parse_a_line(s: &str, r: &Regex) -> ((u32, u32), (u32, u32)) {
    let caps = r.captures(s).unwrap();
    (
        (caps["x1"].parse().unwrap(), caps["y1"].parse().unwrap()),
        (caps["x2"].parse().unwrap(), caps["y2"].parse().unwrap()),
    )
}

fn line_to_points(((x1, y1), (x2, y2)): ((u32, u32), (u32, u32))) -> HashSet<(u32, u32)> {
    if x1 == x2 {
        let maxi = y1.max(y2);
        let mini = y1.min(y2);
        return (mini..(maxi + 1u32)).map(|y| (x1, y)).collect();
    } else if y1 == y2 {
        let maxi = x1.max(x2);
        let mini = x1.min(x2);
        return (mini..(maxi + 1u32)).map(|x| (x, y1)).collect();
    } else {
        let diff = if y1 > y2 { y1 - y2 } else { y2 - y1 };
        return (0..=diff)
            .map(|i| {
                (
                    if x1 < x2 { x1 + i } else { x1 - i },
                    if y1 < y2 { y1 + i } else { y1 - i },
                )
            })
            .collect();
    }
}

fn count_overlap_points(points: Vec<HashSet<(u32, u32)>>) -> u32 {
    let mut result: HashSet<(u32, u32)> = HashSet::new();
    for line in &points {
        for line2 in &points {
            if line2 == line {
                break;
            }
            let ps: HashSet<(u32, u32)> = line.intersection(&line2).cloned().collect();
            // BETTER WAY?  more functional?
            for p in ps {
                result.insert(p);
            }
        }
    }
    result.len() as u32
}
pub fn part1(xs: Vec<&str>) -> u32 {
    let r = Regex::new(r"(?P<x1>\d+),(?P<y1>\d+) -> (?P<x2>\d+),(?P<y2>\d+)").unwrap();

    let vec: Vec<((u32, u32), (_, _))> = xs.iter().map(|line| parse_a_line(line, &r)).collect();

    let h_or_v_lines: Vec<((u32, u32), (_, _))> = vec
        .iter()
        .cloned()
        .filter(|((x1, y1), (x2, y2))| x1 == x2 || y1 == y2)
        .collect();

    let points: Vec<_> = h_or_v_lines
        .iter()
        .map(|line| line_to_points(*line))
        .collect();

    count_overlap_points(points)
}
pub fn part2(xs: Vec<&str>) -> u32 {
    let r = Regex::new(r"(?P<x1>\d+),(?P<y1>\d+) -> (?P<x2>\d+),(?P<y2>\d+)").unwrap();

    let vec: Vec<((u32, u32), (_, _))> = xs.iter().map(|line| parse_a_line(line, &r)).collect();
    let points: Vec<_> = vec.iter().map(|line| line_to_points(*line)).collect();

    count_overlap_points(points)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_51() {
        let s = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2";
        let xs = s.trim().lines().collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 5);
        let s = fs::read_to_string("src/input05").expect("cannot read file");
        let xs = s.trim().lines().collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 5442);
    }
    #[test]
    fn test_52() {
        let s = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2";
        let xs = s.trim().lines().collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 12);
        let s = fs::read_to_string("src/input05").expect("cannot read file");
        let xs = s.trim().lines().collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 19571);
    }
}
