fn first_last_to_number(ds: Vec<char>) -> i32 {
    let first = ds.first().unwrap();
    let last = ds.last().unwrap();
    let n = format!("{}{}", first, last);
    n.as_str().parse::<i32>().unwrap()
}
pub fn part1(s: &str) -> i32 {
    let mut sum = 0;
    for line in s.trim().split('\n') {
        let ds = line.chars().filter(|x| x.is_ascii_digit()).collect();
        sum += first_last_to_number(ds);
    }
    sum
}

pub fn part2(s: &str) -> i32 {
    let mut sum = 0;
    for line in s.trim().split('\n') {
        let s = line.chars();
        let mut checked: String = "".to_owned();
        let mut ns: Vec<char> = vec![];
        for c in s {
            checked.push(c);
            if c.is_ascii_digit() {
                ns.push(c);
                continue;
            }
            if checked.ends_with("one") {
                ns.push('1');
            } else if checked.ends_with("two") {
                ns.push('2');
            } else if checked.ends_with("three") {
                ns.push('3');
            } else if checked.ends_with("four") {
                ns.push('4');
            } else if checked.ends_with("five") {
                ns.push('5');
            } else if checked.ends_with("six") {
                ns.push('6');
            } else if checked.ends_with("seven") {
                ns.push('7');
            } else if checked.ends_with("eight") {
                ns.push('8');
            } else if checked.ends_with("nine") {
                ns.push('9');
            }
        }
        sum += first_last_to_number(ns);
    }
    sum
}

#[cfg(test)]
mod tests {
    use super::*;
    //use std::fs;
    #[test]
    fn p1() {
        let s = "
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet";
        assert_eq!(part1(s), 142);
        //let s = fs::read_to_string("./src/input01").unwrap();
        //assert_eq!(part1(s.as_str()), 53386);
    }

    #[test]
    fn p2() {
        let s = "
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen";
        assert_eq!(part2(s), 281);
        //let s = fs::read_to_string("./src/input01").unwrap();
        //assert_eq!(part2(s.as_str()), 53312);
    }
}
