use std::collections::HashMap;

fn line_mapper(line: &str) -> Vec<char> {
    line.chars().collect()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();

    let mut pairs = HashMap::new();
    pairs.insert('{', '}');
    pairs.insert('(', ')');
    pairs.insert('[', ']');
    pairs.insert('<', '>');

    let mut scores = HashMap::new();
    scores.insert(')', 3);
    scores.insert(']', 57);
    scores.insert('}', 1197);
    scores.insert('>', 25137);

    let mut errors: Vec<char> = vec![];
    for line in &mapped {
        //for c in "{([(<{}[<>[]}>{[]{[(<()>".chars() {
        let mut stack: Vec<char> = vec![];
        for c in line {
            if ['{', '(', '[', '<'].contains(&c) {
                stack.push(*c);
            } else {
                let top = stack.pop().unwrap();
                if c != &pairs[&top] {
                    println!("expected {} got {}", pairs[&top], c);
                    errors.push(*c);
                    break;
                }
            }
        }
    }

    errors.iter().map(|&c| scores[&c]).sum()
}
pub fn part2(xs: Vec<&str>) -> i64 {
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let mut stack: Vec<char> = vec![];
    let mut pairs = HashMap::new();
    pairs.insert('{', '}');
    pairs.insert('(', ')');
    pairs.insert('[', ']');
    pairs.insert('<', '>');

    let mut incomplete: Vec<Vec<char>> = vec![];

    for line in &mapped {
        let mut corrupt = false;
        for c in line {
            if ['{', '(', '[', '<'].contains(&c) {
                stack.push(*c);
            } else {
                let top = stack.pop().unwrap();
                if c != &pairs[&top] {
                    corrupt = true;
                    break;
                }
            }
        }
        if !corrupt {
            incomplete.push(line.to_vec());
        }
    }
    dbg!(&incomplete.len());

    let mut scores = HashMap::new();
    scores.insert(')', 1);
    scores.insert(']', 2);
    scores.insert('}', 3);
    scores.insert('>', 4);

    let mut remain: Vec<i64> = vec![];
    //for c in "[({(<(())[]>[[{[]{<()<>>".chars() {
    for line in incomplete {
        let mut stack: Vec<char> = vec![];
        let mut sum = 0;
        for c in line {
            if ['{', '(', '[', '<'].contains(&c) {
                stack.push(c);
            } else {
                println!("{:?}", &stack);
                stack.pop();
            }
        }
        let t: Vec<char> = stack.iter().rev().cloned().collect();
        let mapped: Vec<_> = t.iter().map(|&c| pairs[&c]).collect();
        for c in mapped {
            sum = sum * 5 + scores[&c];
        }
        remain.push(sum);
    }
    remain.sort();
    *remain.get(remain.len() / 2).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    static _S: &str = "[({(<(())[]>[[{[]{<()<>>
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
        assert_eq!(r, 315693);
    }
    #[test]
    fn test102() {
        let s = fs::read_to_string("src/input10").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1870887234);
    }
}
