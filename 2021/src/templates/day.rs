use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> u32 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> u32 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    1
}
pub fn part2(xs: Vec<&str>) -> u32 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    1
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_61() {
        //let s = fs::read_to_string("src/input04").expect("cannot read file");
        let s = "";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test_62() {
        //let s = fs::read_to_string("src/input04").expect("Cannot read file");
        let s = "";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}