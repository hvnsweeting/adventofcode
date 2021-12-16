use regex::Regex;
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
pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let map = make_map(mapped.clone());
    print_table(&map);

    let mut prev: HashMap<(i64, i64), (i64, i64)> = HashMap::new();
    let mut queue: Vec<(i64, i64)> = Vec::new();
    let mut dist: HashMap<(i64, i64), i64> = HashMap::new();
    for ((x, y), _) in map.clone() {
        dist.insert((x, y), 100000); // ((x, y)).or_insert(100000) += 0;
        if (x, y) == (0, 0) {
            dist.insert((x, y), 0); // ((x, y)).or_insert(100000) += 0;
        } else {
            queue.push((x, y));
        }
    }
    queue.push((0, 0));

    let maxx = (mapped[0].len() as i64) - 1;
    let maxy = mapped.len() as i64 - 1;
    let mut counter = 0;
    while !queue.is_empty() {
        let &(x, y) = &queue
            .iter()
            .cloned()
            .min_by(|p1, p2| dist.get(&p1).unwrap().cmp(dist.get(&p2).unwrap()))
            .unwrap();
        let idx = queue.iter().position(|&i| i == (x, y)).unwrap();
        queue.remove(idx);

        let unvisited_around = vec![(x - 1, y), (x, y - 1), (x + 1, y), (x, y + 1)]
            .iter()
            .cloned()
            .filter(|&(xi, yi)| {
                !(xi < 0 || xi > maxx || yi < 0 || yi > maxy) && queue.contains(&(xi, yi))
            })
            .collect::<Vec<(i64, i64)>>();

        //println!("Pop: {:?} around: {:?}", (x, y), &unvisited_around);
        for v in &unvisited_around {
            let alt = map[&v] + dist[&(x, y)];
            if alt < dist[&v] {
                *dist.entry(*v).or_insert(alt) = alt;
                prev.insert(*v, (x, y));
            }
        }
        //if counter == 10 {
        //    break;
        //}
    }
    print_table(&dist);
    dist[&(maxx, maxy)]
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
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    1
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
    //#[test]
    fn test_82() {
        let s = "";
        //let s = fs::read_to_string("src/input15").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}
