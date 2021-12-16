use regex::Regex;
use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> Vec<i64> {
    line.chars()
        .map(|c| c.to_digit(10).unwrap() as i64)
        .collect()
}
fn make_map(rows: Vec<Vec<i64>>) -> HashMap<(i64, i64), i64> {
    let mut d: HashMap<(i64, i64), i64> = HashMap::new();
    for y in 0..rows.len() {
        for x in 0..rows[y].len() {
            d.insert((x as i64, y as i64), rows[y][x]);
        }
    }
    return d;
}

fn print_table(map: &HashMap<(i64, i64), i64>) {
    let &maxx = map.keys().map(|(x, y)| x).max().unwrap();
    let &maxy = map.keys().map(|(x, y)| y).max().unwrap();

    for y in 0..=maxy {
        for x in 0..=maxx {
            print!("{}|", map[&(x, y)]);
        }
        print!("\n");
    }
}

fn solve(map: HashMap<(i64, i64), i64>) -> i64 {
    let mut prev: HashMap<(i64, i64), (i64, i64)> = HashMap::new();
    let mut pqueue = BinaryHeap::new();
    let mut dist: HashMap<(i64, i64), i64> = HashMap::new();
    for ((x, y), _) in map.clone() {
        dist.insert((x, y), 100000); // ((x, y)).or_insert(100000) += 0;
        if (x, y) == (0, 0) {
            dist.insert((x, y), 0); // ((x, y)).or_insert(100000) += 0;
        }
    }
    pqueue.push(Reverse((0, 0, 0)));

    let maxx = map.keys().map(|(x, y)| x).max().unwrap().clone();
    let maxy = map.keys().map(|(x, y)| y).max().unwrap().clone();
    let mut counter = 0;
    while !pqueue.is_empty() {
        let Reverse((risk, x, y)) = pqueue.pop().unwrap();
        let unvisited_around = vec![(x - 1, y), (x, y - 1), (x + 1, y), (x, y + 1)]
            .iter()
            .cloned()
            .filter(|&(xi, yi)| {
                !(xi < 0 || xi > maxx || yi < 0 || yi > maxy) && dist[&(xi, yi)] == 100000
            })
            .collect::<Vec<(i64, i64)>>();

        //println!("Pop: {:?} around: {:?}", (x, y), &unvisited_around);
        for &(xi, yi) in &unvisited_around {
            let alt = map[&(xi, yi)] + risk;
            *dist.entry((xi, yi)).or_insert(alt) = alt;
            pqueue.push(Reverse((alt, xi, yi)));
            //prev.insert(*v, (x, y));
        }
        //if counter == 10 {
        //    break;
        //}
    }
    print_table(&dist);
    dist[&(maxx, maxy)]
}
pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let map = make_map(mapped.clone());
    solve(map)

    //println!("{:?}", &dist);
    //println!("{:?}", &prev);
    //let mut current = (maxx, maxy);
    //let mut risk = 0;
    //while prev.contains_key(&current) {
    //    let p = prev[&current];
    //    risk += map[&p];
    //    //dbg!(&p);
    //    current = p;
    //}
    //risk;
    //1
}
pub fn part2(xs: Vec<&str>) -> i64 {
    let mut mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let mut map = make_map(mapped.clone());
    let origin_map = map.clone();

    let maxx = (mapped[0].len() as i64);
    let maxy = mapped.len() as i64;
    dbg!(&maxx, &maxy);

    for i in 2..=5 {
        for ((x, y), v) in origin_map.clone() {
            let newv = if (v + i - 1 > 9) {
                (v + i - 1) % 9
            } else {
                v + i - 1
            };
            map.insert((x + (i - 1) * maxx, y), newv);
        }
    }

    print_table(&map);
    println!("==========");
    let origin_map2 = map.clone();
    for i in 2..=5 {
        for ((x, y), v) in origin_map2.clone() {
            let newv = if (v + i - 1 > 9) {
                (v + i - 1) % 9
            } else {
                v + i - 1
            };
            map.insert((x, y + (i - 1) * maxy), newv);
        }
    }

    print_table(&map);
    solve(map)
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_81() {
        let s = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581";
        let s = fs::read_to_string("src/input15").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 739);
    }
    #[test]
    fn test_82() {
        let s = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581";
        let s = fs::read_to_string("src/input15").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 3040);
    }
}
