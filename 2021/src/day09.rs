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

fn find_low_points(d: &HashMap<(i64, i64), i64>) -> HashMap<(i64, i64), i64> {
    let mut low: HashMap<(i64, i64), i64> = HashMap::new();
    for (k, v) in d {
        let (x, y) = k.clone();
        let arounds = vec![
            (x - 1, y - 1),
            (x, y - 1),
            (x + 1, y - 1),
            (x - 1, y),
            (x + 1, y),
            (x - 1, y + 1),
            (x, y + 1),
            (x + 1, y + 1),
        ];
        let is_low = arounds
            .iter()
            .map(|&p| d.get(&p).or(Some(&10000)).unwrap())
            .all(|t| t > &v);

        if is_low {
            low.insert(*k, *v);
        }
    }
    low
}
pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let d = make_map(mapped);

    find_low_points(&d).values().map(|&x| x + 1).sum()
}
pub fn part2(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);

    let d = make_map(mapped);

    let mut basins: Vec<i64> = vec![];
    let low = find_low_points(&d);

    for (point, _) in low {
        // for each point, we find 4 around points , if ok, add to "next" queue
        // continue until queue empty
        let mut basin: HashSet<(i64, i64)> = HashSet::new();
        let mut queue: Vec<(i64, i64)> = vec![];
        queue.push(point);

        while !queue.is_empty() {
            let (x, y) = queue.pop().unwrap();
            basin.insert((x, y));
            for (xi, yi) in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)] {
                if d.contains_key(&(xi, yi)) && !basin.contains(&(xi, yi)) {
                    if d[&(xi, yi)] != 9 {
                        queue.push((xi, yi));
                    }
                }
            }
        }

        basins.push(basin.iter().len() as i64);
    }
    basins.sort();
    basins[basins.len() - 3..basins.len()]
        .iter()
        .fold(1, |acc, x| acc * x)
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_91() {
        let _s = "2199943210
3987894921
9856789892
8767896789
9899965678
";
        let s = fs::read_to_string("src/input09").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 537);
    }
    #[test]
    fn test_92() {
        let _s = "2199943210
3987894921
9856789892
8767896789
9899965678
";
        let s = fs::read_to_string("src/input09").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1142757);
    }
}
