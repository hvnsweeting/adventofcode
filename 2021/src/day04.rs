use crate::utils::bin_to_int;
use std::collections::HashSet;

fn to_digits(row: &str) -> Vec<u32> {
    row.chars().map(|c| c.to_digit(10).unwrap()).collect()
}

fn win(v: Vec<u32>, board: Vec<Vec<u32>>) -> bool {
    let s: HashSet<u32> = v.clone().into_iter().collect();
    // check row
    for row in board.clone() {
        let r_set: HashSet<u32> = row.into_iter().collect();
        if r_set.is_subset(&s) {
            return true;
        }
    }
    // check col
    for i in 0..board[0].len() {
        let col: Vec<u32> = board.iter().map(|row| row[i]).collect();
        let r_set: HashSet<u32> = col.into_iter().collect();

        if r_set.is_subset(&s) {
            return true;
        }
    }
    false
}

fn score(v: Vec<u32>, board: Vec<Vec<u32>>) -> u32 {
    let s: HashSet<u32> = v.clone().into_iter().collect();
    let mut r_set = HashSet::<u32>::new();
    for row in board {
        let ss: HashSet<u32> = row.into_iter().collect();
        r_set = r_set.union(&ss).map(|&x| x).collect();
    }
    let sum: u32 = r_set.difference(&s).into_iter().sum();
    v[&v.len() - 1] * sum
}

pub fn part1(xs: Vec<&str>) -> u32 {
    let draws = xs[0];
    let boards = &xs[1..];
    let ns: Vec<u32> = draws
        .split(",")
        .map(|n| n.parse::<u32>().unwrap())
        .collect();

    let mut drawed = vec![];

    for n in ns {
        drawed.push(n);
        for board in boards {
            let bs: Vec<Vec<u32>> = board
                .split("\n")
                .map(
                    // each line
                    |line| {
                        line.split_whitespace()
                            .map(|x| x.parse::<u32>().unwrap())
                            .collect::<Vec<u32>>()
                    },
                )
                .collect();
            // todo how to replace string
            //dbg!(bs);
            if win(drawed.clone(), bs.clone()) {
                return score(drawed.clone(), bs.clone());
            }
        }
    }
    0
}

pub fn part2(xs: Vec<&str>) -> u32 {
    let draws = xs[0];
    let boards = &xs[1..];
    let ns: Vec<u32> = draws
        .split(",")
        .map(|n| n.parse::<u32>().unwrap())
        .collect();

    let mut drawed = vec![];
    let mut won = vec![];

    for n in ns {
        drawed.push(n);

        for (c, board) in boards.iter().enumerate() {
            if won.contains(&c) {
                continue;
            }
            let bs: Vec<Vec<u32>> = board
                .split("\n")
                .map(
                    // each line
                    |line| {
                        line.split_whitespace()
                            .map(|x| x.parse::<u32>().unwrap())
                            .collect::<Vec<u32>>()
                    },
                )
                .collect();
            // todo how to replace string
            //dbg!(bs);
            if win(drawed.clone(), bs.clone()) {
                won.push(c);
                if won.len() == boards.len() {
                    return score(drawed.clone(), bs.clone());
                }
            }
        }
    }
    0
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_41() {
        let s = fs::read_to_string("src/input04").expect("cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 16716);
    }
    #[test]
    fn test_42() {
        let s = fs::read_to_string("src/input04").expect("Cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 4880);
    }
}
