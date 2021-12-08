use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> (&str, &str) {
    match line.split(" | ").collect::<Vec<&str>>()[..] {
        [patterns, output] => (patterns, output),
        _ => panic!("bad input"),
    }
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);

    // 0: 6
    // 1
    let mut d: HashMap<i32, i32> = HashMap::new();
    d.insert(0, 6);
    d.insert(1, 2);
    d.insert(2, 5);
    d.insert(3, 5);
    d.insert(4, 4);
    d.insert(5, 5);
    d.insert(6, 6);
    d.insert(7, 3);
    d.insert(8, 7);
    d.insert(9, 6);

    dbg!(&d);

    let mapped: Vec<_> = mapped
        .iter()
        .map(|&(_, s2)| s2.trim().split(" ").collect::<Vec<&str>>())
        .collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);

    let mut counter = 0;
    for row in mapped {
        for c in row {
            let len: i64 = c.len() as i64;
            if vec![2, 4, 7, 3].contains(&len) {
                counter += 1;
            }
        }
    }
    counter
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
        let s =
            "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce";
        let s = fs::read_to_string("src/input08").expect("cannot read file");
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
