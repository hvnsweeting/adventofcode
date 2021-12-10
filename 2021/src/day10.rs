use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> Vec<char> {
    //line.parse().unwrap()
    line.chars().collect()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);

    let full: Vec<_> = mapped.iter().filter(|&x| x.len() % 2 == 0).collect();
    dbg!(&full.len());
    for line in &full {
        println!("{:?}", line);
    }
    let mut stack: Vec<char> = vec![];
    let mut pairs: HashMap<char, char> = HashMap::new();
    pairs.insert('{', '}');
    pairs.insert('(', ')');
    pairs.insert('[', ']');
    pairs.insert('<', '>');

    let mut scores: HashMap<char, i64> = HashMap::new();
    scores.insert(')', 3);
    scores.insert(']', 57);
    scores.insert('}', 1197);
    scores.insert('>', 25137);

    let mut errors: Vec<char> = vec![];

    for line in &mapped {
        //for c in "{([(<{}[<>[]}>{[]{[(<()>".chars() {
        for c in line {
            if ['{', '(', '[', '<'].contains(&c) {
                stack.push(*c);
            } else {
                let top = stack.pop().unwrap();
                if c != &pairs[&top] {
                    println!("expected {} got {}", pairs[&top], c);
                    //panic!("Invalid");
                    errors.push(*c);
                    break;
                }
            }
        }
    }

    errors.iter().map(|&c| scores[&c]).sum()
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
    static S: &str = "[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]";

    #[test]
    fn test101() {
        let s = fs::read_to_string("src/input10").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test102() {
        //let s = fs::read_to_string("src/input10").expect("Cannot read file");
        let xs = S.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}
