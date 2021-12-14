use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> (&str, &str) {
    match line.split(" -> ").collect::<Vec<&str>>()[..] {
        [from, to] => (from, to),
        _ => panic!("Not here"),
    }
}

fn count_elements(start: &str, rules: &HashMap<&str, &str>) -> HashMap<char, i64> {
    let mut sc: Vec<_> = Vec::new();
    sc = start.chars().collect::<Vec<char>>();
    dbg!(&sc);

    for i in 1..=20 {
        let mut vec: Vec<_> = Vec::new();
        for idx in 0..(sc.len()) {
            if idx == sc.len() - 1 {
                vec.push(sc[idx]);
                break;
            }
            let two: String = vec![sc[idx], sc[idx + 1]].iter().collect();
            let between = rules.get(two.as_str());
            vec.push(sc[idx]);
            match between {
                Some(c) => vec.push(c.chars().collect::<Vec<char>>()[0]),
                None => (),
            }
        }
        sc = vec.clone();
    }

    let mut d: HashMap<char, i64> = HashMap::new();
    for c in sc {
        *d.entry(c).or_insert(0) += 1;
    }
    d
}

pub fn part1(xs: Vec<&str>) -> i64 {
    let start = xs[0];
    let rules_lines = xs[1];
    let rules: HashMap<&str, &str> = rules_lines
        .split("\n")
        .map(|line| line_mapper(line))
        .collect();
    println!("rules[0..3]: {:?}", &rules);

    let d = count_elements(start, &rules);
    dbg!(&d);
    let vs = d.values().cloned().collect::<Vec<i64>>();
    let &min = vs.iter().min().unwrap();
    let &max = vs.iter().max().unwrap();
    max - min
}

pub fn part2(xs: Vec<&str>) -> i64 {
    let start = xs[0];
    let rules_lines = xs[1];
    let rules: HashMap<&str, &str> = rules_lines
        .split("\n")
        .map(|line| line_mapper(line))
        .collect();
    println!("rules[0..3]: {:?}", &rules);
    // Observe: starts with NNCB becomes ....
    // we can simulate from NN after n step, we got result X
    // from NC after n step got result Y
    // from CB after n step got resutl Z
    // we only have 10 elements, so 10 * 10 == 100 pairs
    // so instead of calculate 40 steps, we calculate only 20 steps, then
    // observe and deduce what is the result after next 20 steps

    // calculate all combinations after 20 steps
    // dbg!(&rules);
    // dbg!(&rules.len());
    let mut pairs_scores: HashMap<&str, HashMap<char, i64>> = HashMap::new();
    for (pair, _) in &rules {
        pairs_scores.insert(pair, count_elements(pair, &rules));
    }
    dbg!(&pairs_scores);
    // calculate

    let mut sc = start.chars().collect::<Vec<char>>();
    dbg!(&sc);

    for i in 1..=20 {
        let mut vec: Vec<_> = Vec::new();
        for idx in 0..(sc.len()) {
            if idx == sc.len() - 1 {
                vec.push(sc[idx]);
                break;
            }
            let two: String = vec![sc[idx], sc[idx + 1]].iter().collect();
            let between = rules.get(two.as_str());
            vec.push(sc[idx]);
            match between {
                Some(c) => vec.push(c.chars().collect::<Vec<char>>()[0]),
                None => (),
            }
        }
        sc = vec.clone();
    }

    let mut result: HashMap<char, i64> = HashMap::new();

    for idx in 0..(sc.len() - 1) {
        let two: String = vec![sc[idx], sc[idx + 1]].iter().collect();

        for (chr, count) in &pairs_scores[two.as_str()] {
            *result.entry(*chr).or_insert(0) += count;
        }
        // NN expands to N...N
        // NC expands to N...C
        // N is counted twice, thus -1
        *result.entry(sc[idx + 1]).or_insert(0) -= 1;
    }
    // except the last char is not counted twice, thus +1 back.
    *result.entry(sc[sc.len() - 1]).or_insert(0) += 1;
    dbg!(&result);

    let min = result.values().cloned().min().unwrap();
    let max = result.values().cloned().max().unwrap();
    max - min
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    static S: &str = "NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C";

    #[test]
    fn test_141() {
        let s = fs::read_to_string("src/input14").expect("cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 2602);
    }
    // skip, take ~ 7 mins
    // #[test]
    fn test_142() {
        let s = fs::read_to_string("src/input14").expect("cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 2942885922173);
    }
}
