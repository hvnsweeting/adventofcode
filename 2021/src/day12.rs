use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> (&str, &str) {
    match line.split("-").collect::<Vec<&str>>()[..] {
        [from, to] => (from, to),
        _ => panic!("Not reach here"),
    }
}

fn is_lowercase(s: &str) -> bool {
    s.to_uppercase() != s
}
fn count_paths(
    d: &HashMap<&str, Vec<&str>>,
    position: &str,
    visited: HashSet<&str>,
    can_visit_small_case_twice: bool,
) -> i64 {
    let neighbors = &d[position];
    //dbg!(&neighbors);
    if position == "end" {
        return 1;
    }

    neighbors
        .iter()
        .filter(|&n| n != &"start")
        .map(|&n| {
            if is_lowercase(n) && visited.contains(n) && can_visit_small_case_twice == true {
                let mut vs = visited.clone();
                vs.insert(n);
                count_paths(d, n, vs, false)
            } else if is_lowercase(n) && visited.contains(n) {
                0
            } else {
                let mut vs = visited.clone();
                vs.insert(n);
                count_paths(d, n, vs, can_visit_small_case_twice)
            }
        })
        .sum()
}
pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let mut d: HashMap<&str, Vec<&str>> = HashMap::new();
    for (node1, node2) in mapped {
        d.entry(node1).or_insert(vec![]).push(node2);
        d.entry(node2).or_insert(vec![]).push(node1);
    }
    dbg!(&d);
    count_paths(&d, "start", HashSet::new(), false)
}
pub fn part2(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let mut d: HashMap<&str, Vec<&str>> = HashMap::new();
    for (node1, node2) in mapped {
        d.entry(node1).or_insert(vec![]).push(node2);
        d.entry(node2).or_insert(vec![]).push(node1);
    }
    dbg!(&d);
    count_paths(&d, "start", HashSet::new(), true)
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_121() {
        let s = "start-A
start-b
A-c
A-b
b-d
A-end
b-end";
        let s = "dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc";
        let s = fs::read_to_string("src/input12").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 3887);
    }
    #[test]
    fn test_122() {
        let s = "start-A
start-b
A-c
A-b
b-d
A-end
b-end";
        let s = fs::read_to_string("src/input12").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 104834);
    }
}
