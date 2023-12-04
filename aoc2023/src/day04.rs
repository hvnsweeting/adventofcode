use std::collections::HashSet;
fn parse_line(line: &str) -> u32 {
    let (_, ns) = line.split_once(':').unwrap();
    let (win, hand) = ns.split_once(" | ").unwrap();
    let vs = win.split_whitespace().map(|x| x.parse::<i32>().unwrap());

    let w_set: HashSet<i32> = HashSet::from_iter(vs);
    let h_set: HashSet<i32> = HashSet::from_iter(hand.split_whitespace().map(|x| x.parse::<i32>().unwrap()));
    w_set.intersection(&h_set).count() as u32

}

pub fn part1(s: &str) -> i32 {
    let mut sum = 0;

    for line in s.trim().lines() {
        let matchn = parse_line(line);
        if matchn != 0 {
            sum += 2i32.pow(matchn-1);

        }

    }
    sum
}

fn parse_line_p2(line: &str) -> i32 {

    0
}

pub fn part2(s: &str) -> u32 {
    let vs: Vec<u32> = s.trim().lines().map(parse_line).collect();
    let mut cards: Vec<u32> = vec![1;vs.len()];
    for idx in 0..vs.len() {
        let copies = cards[idx];
        for j in (idx as u32 +1)..=(idx as u32)+vs[idx] {
            cards[j as usize] += copies;
        }
    }
    dbg!(&cards);
    cards.iter().sum()
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    const S: &str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
";
    #[test]
    fn p1() {
        assert_eq!(part1(S), 13);
        let s2 = fs::read_to_string("./src/input04.txt").unwrap();
        assert_eq!(part1(s2.as_str()), 20107);
    }

   #[test]
   fn p2() {
       assert_eq!(part2(S), 30);
       let s2 = fs::read_to_string("./src/input04.txt").unwrap();
       assert_eq!(part2(s2.as_str()), 8172507);
   }
}
