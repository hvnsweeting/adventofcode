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
    // get list of number
    // deduce the position
    // map position to char
    //
    //let mapped: Vec<_> = mapped
    //    .iter()
    //    .map(|&(_, s2)| s2.trim().split(" ").collect::<Vec<&str>>())
    //    .collect();
    //println!("mapped[0..3]: {:?}", &mapped[0..3]);
    //calculate char map form 10 signal
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    //println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let signals: Vec<_> = mapped
        .iter()
        .map(|&(s1, s2)| {
            (
                s1.trim().split(" ").collect::<Vec<&str>>(),
                s2.trim().split(" ").collect::<Vec<&str>>(),
            )
        })
        .clone()
        .collect();
    //println!("mapped[0..3]: {:?}", &signals[0..3]);

    let mut sum = 0;
    for signal in signals {
        let mut zero: HashSet<char> = HashSet::new();
        let mut one: HashSet<char> = HashSet::new();
        let mut two: HashSet<char> = HashSet::new();
        let mut three: HashSet<char> = HashSet::new();
        let mut four: HashSet<char> = HashSet::new();
        let mut five: HashSet<char> = HashSet::new();
        let mut six: HashSet<char> = HashSet::new();
        let mut seven: HashSet<char> = HashSet::new();
        let mut eight: HashSet<char> = HashSet::new();
        let mut nine: HashSet<char> = HashSet::new();
        let (ss, output) = signal;
        for s in &ss {
            let h: HashSet<char> = s
                .clone()
                .chars()
                //.collect::<Vec<i64>>()
                //.iter()
                .collect();
            if h.len() == 2 {
                one = h.clone();
                continue;
            } else if h.len() == 3 {
                seven = h.clone();
                continue;
            } else if h.len() == 4 {
                four = h.clone();
                continue;
            } else if h.len() == 7 {
                eight = h.clone();
                continue;
            }
        }
        for s in &ss {
            let h: HashSet<char> = s
                .clone()
                .chars()
                //.collect::<Vec<i64>>()
                //.iter()
                .collect();
            let mut subcounter = 0;
            for s2 in &ss {
                let h2: HashSet<char> = s2
                    .clone()
                    .chars()
                    //.collect::<Vec<i64>>()
                    //.iter()
                    .collect();
                if h.len() == 5 && h != h2 && h.is_subset(&h2) {
                    subcounter += 1;
                }
                if h.len() == 5 && one.is_subset(&h) {
                    three = h.clone();
                }
            }
            if subcounter == 3 {
                five = h;
            }
        }
        println!("one: {:?}", one);
        println!("four: {:?}", four);
        println!("three: {:?}", three);
        println!("Five: {:?}", five);
        println!("sev: {:?}", seven);

        let mut charmap: Vec<char> = vec![' '; 7];
        charmap[5] = five.intersection(&one).cloned().collect::<Vec<char>>()[0];
        charmap[0] = seven.difference(&one).cloned().collect::<Vec<char>>()[0];
        charmap[1] = four.difference(&three).cloned().collect::<Vec<char>>()[0];

        //charmap[2] = one.difference(&five).cloned().collect::<Vec<char>>()[0];
        charmap[2] = four.difference(&five).cloned().collect::<Vec<char>>()[0];
        charmap[3] = four
            .intersection(&three)
            .cloned()
            .collect::<HashSet<char>>()
            .difference(&one)
            .cloned()
            .collect::<Vec<char>>()[0];

        charmap[6] = five
            .difference(&four)
            .cloned()
            .collect::<HashSet<char>>()
            .difference(&(seven.difference(&one).cloned().collect::<HashSet<char>>()))
            .cloned()
            .collect::<Vec<char>>()[0];
        charmap[4] = eight
            .difference(&five)
            .cloned()
            .collect::<HashSet<char>>()
            .difference(&one)
            .cloned()
            .collect::<Vec<char>>()[0];

        dbg!(&charmap);

        let s = charmap.iter().collect::<String>();
        let order: &str = s.as_str().clone();
        let mut d: HashMap<Vec<i64>, i64> = HashMap::new();
        d.insert(vec![2, 5], 1);
        d.insert(vec![1, 2, 3, 5], 4);
        d.insert(vec![0, 2, 5], 7);
        d.insert(vec![0, 1, 2, 3, 4, 5, 6], 8);

        d.insert(vec![0, 2, 3, 4, 6], 2);
        d.insert(vec![0, 2, 3, 5, 6], 3);
        d.insert(vec![0, 1, 3, 5, 6], 5);

        d.insert(vec![0, 1, 3, 4, 5, 6], 6);
        d.insert(vec![0, 1, 2, 4, 5, 6], 0);
        d.insert(vec![0, 1, 2, 3, 5, 6], 9);

        fn char_to_num(charmap: &str, s: &str, map: &HashMap<Vec<i64>, i64>) -> i64 {
            let p: HashSet<i64> = s
                .chars()
                .map(|c| charmap.find(c).unwrap() as i64)
                //.collect::<Vec<i64>>()
                //.iter()
                .collect();
            for (k, v) in map {
                let khs: HashSet<i64> = k.iter().cloned().collect();
                if khs == p {
                    return *v;
                }
            }
            dbg!(&charmap, s);

            panic!("NOT REACH HERR");
        }

        dbg!(&output);

        let r: Vec<i64> = output
            .iter()
            .map(|&s| char_to_num(&order, s, &d))
            .zip((0..(output.len() as u32)).rev())
            .map(|(n, p)| n * 10_i64.pow(p))
            .collect();
        sum += r.iter().sum::<i64>();
    }
    sum
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_81() {
        let _s =
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
        assert_eq!(r, 530);
    }
    #[test]
    fn test_82() {
        let _s =
            "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
";
        let s = fs::read_to_string("src/input08").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1051087);
    }
}
