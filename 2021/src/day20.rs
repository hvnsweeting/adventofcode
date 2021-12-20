use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}
fn make_map(rows: Vec<Vec<char>>) -> HashMap<(i64, i64), char> {
    let mut d: HashMap<(i64, i64), char> = HashMap::new();
    for y in 0..rows.len() {
        for x in 0..rows[y].len() {
            d.insert((x as i64, y as i64), rows[y][x]);
        }
    }
    return d;
}

fn neighbors(
    m: &HashMap<(i64, i64), char>,
    (x, y): (i64, i64),
    bg_char: char,
) -> Vec<((i64, i64), char)> {
    vec![
        (x - 1, y - 1),
        (x, y - 1),
        (x + 1, y - 1),
        (x - 1, y),
        (x, y),
        (x + 1, y),
        (x - 1, y + 1),
        (x, y + 1),
        (x + 1, y + 1),
    ]
    .iter()
    .map(|c| (c.clone(), m.get(c).or(Some(&bg_char)).unwrap().clone()))
    //.cloned()
    .collect()
}

pub fn part1(xs: Vec<&str>, times: usize) -> i64 {
    let algorithm = xs[0];
    let image = xs[1];
    assert_eq!(algorithm.len(), 512);
    let algorithm: Vec<char> = algorithm.chars().collect();
    dbg!(&image);
    let chs: Vec<_> = image.lines().map(|line| line.chars().collect()).collect();
    let mut m = make_map(chs);

    //dbg!(&m);
    for i in 0..times {
        let mut newm = m.clone();

        let bg_char = if i % 2 == 0 { '.' } else { '#' };
        for ((x, y), _) in m.clone() {
            let n = neighbors(&m, (x, y), bg_char);

            for (p, v) in n {
                if !newm.contains_key(&p) {
                    newm.insert(p, bg_char);
                }
            }
        }

        let newmclone = newm.clone();
        for (&(x, y), _) in &newmclone {
            let n = neighbors(&newmclone, (x, y), bg_char);

            let mut vec: Vec<_> = Vec::new();
            for (i, v) in n {
                //newm.entry(i).or_insert(v);
                vec.push(v);
            }
            *newm.entry((x, y)).or_insert(bg_char) = transform(vec, &algorithm);
        }

        m = newm;
        let v = m.values().filter(|&x| x == &'#').count() as i64;
    }
    //print_table(&m);
    m.values().filter(|&x| x == &'#').count() as i64
}
fn print_table(map: &HashMap<(i64, i64), char>) {
    let &maxx = map.keys().map(|(x, y)| x).max().unwrap();
    let &minx = map.keys().map(|(x, y)| x).min().unwrap();
    let &maxy = map.keys().map(|(x, y)| y).max().unwrap();
    let &miny = map.keys().map(|(x, y)| y).min().unwrap();

    for y in miny - 3..=maxy + 3 {
        for x in minx - 3..=maxx + 3 {
            print!("{}", map.get(&(x, y)).or(Some(&' ')).unwrap());
        }
        print!("\n");
    }
}

fn transform(pixels: Vec<char>, algorithm: &Vec<char>) -> char {
    let bin: Vec<_> = pixels
        .iter()
        .map(|c| match c {
            '.' => '0',
            '#' => '1',
            _ => panic!("not here"),
        })
        .collect();
    let s: String = bin.into_iter().collect();

    let n = usize::from_str_radix(s.as_str(), 2).unwrap();
    //dbg!(&n, algorithm[n]);
    //pixels
    algorithm[n]
}

pub fn part2(xs: Vec<&str>) -> i64 {
    part1(xs, 50)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_201() {
        let s = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##\
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###\
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.\
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....\
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..\
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....\
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###";
        let s = fs::read_to_string("src/input20").expect("cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs, 2);
        assert_eq!(r, 5097);
    }
    #[test]
    fn test_202() {
        let s = fs::read_to_string("src/input20").expect("Cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 17987);
    }
}
