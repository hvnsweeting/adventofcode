use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> Vec<i64> {
    line.chars()
        .map(|c| c.to_digit(10).unwrap() as i64)
        .collect()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let mut d: HashMap<(i64, i64), i64> = HashMap::new();
    for i in 0..mapped.len() {
        for j in 0..mapped[i].len() {
            d.insert((i as i64, j as i64), mapped[i][j]);
        }
    }

    // find low points
    let mut sum = 0;
    for (k, v) in &d {
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
            .all(|x| x > &v);

        if is_low {
            sum += 1 + v;
        }
    }
    //dbg!(&d);
    sum
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
        let s = "2199943210
3987894921
9856789892
8767896789
9899965678
";
        //let s = fs::read_to_string("src/input08").expect("cannot read file");
        let s = fs::read_to_string("src/input09").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test_82() {
        let s = "";
        //let s = fs::read_to_string("src/input08").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}
