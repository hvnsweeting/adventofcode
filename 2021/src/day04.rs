use crate::utils::bin_to_int;
use std::collections::HashSet;

fn to_digits(row: &str) -> Vec<u32> {
    row.chars().map(|c| c.to_digit(10).unwrap()).collect()
}

fn win(v: Vec<u32>, board: Vec<Vec<u32>>) -> bool {
    let s: HashSet<u32> = v.clone().into_iter().collect();
    // check row
    for row in board.clone() {
        let rSet: HashSet<u32> = row.into_iter().collect();
        if rSet.is_subset(&s) {
            return true;
        }
    }
    for i in 0..board[0].len() {
        let col: Vec<u32> = board.iter().map(|row| row[i]).collect();
        let rSet: HashSet<u32> = col.into_iter().collect();
        if rSet.is_subset(&s) {
            return true;
        }
    }
    // check coll
    false
}

fn score(v: Vec<u32>, board: Vec<Vec<u32>>) -> u32 {
    let S: HashSet<u32> = v.clone().into_iter().collect();
    let mut rSet = HashSet::<u32>::new();
    for row in board {
        let ss: HashSet<u32> = row.into_iter().collect();
        rSet = rSet.union(&ss).map(|&x| x).collect();
    }
    let s: u32 = rSet.difference(&S).into_iter().sum();
    v[&v.len() - 1] * s
}

pub fn part1(xs: Vec<&str>) -> u32 {
    dbg!(&xs);
    let draws = xs[0];
    let boards = &xs[1..];
    let ns: Vec<u32> = draws
        .split(",")
        .map(|n| n.parse::<u32>().unwrap())
        .collect();

    let S: Vec<_> = "7,4,9,5,11,17,23,2,0,14,21,24"
        .split(",")
        .map(|x| x.parse::<u32>().unwrap())
        .collect();
    let mut S = vec![];

    for n in ns {
        S.push(n);
        for board in boards {
            let bs: Vec<Vec<u32>> = board
                .split("\n")
                .map(
                    // each line
                    |line| {
                        line.split(" ")
                            .filter(|x| x != &"")
                            .map(|x| x.parse::<u32>().unwrap())
                            .collect::<Vec<u32>>()
                    },
                )
                .collect();
            // todo how to replace string
            //dbg!(bs);
            if win(S.clone(), bs.clone()) {
                dbg!(score(S.clone(), bs.clone()));
                return score(S.clone(), bs.clone());
            }
        }
    }

    //.map(|n| n.parse::<u32>().unwrap())
    //.collect();
    1
}

pub fn part2(xs: Vec<&str>) -> u32 {
    1
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    //    #[test]
    //    fn test_42() {
    //        //let s = fs::read_to_string("src/input03").expect("Cannot read file");
    //        let s = "
    //            ";
    //        let xs = s.trim().split("\n").collect::<Vec<&str>>();
    //        let r = part2(xs);
    //        assert_eq!(r, 1);
    //    }
    //
    #[test]
    fn test_41() {
        let s = "
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
            ";
        let s = fs::read_to_string("src/input04").expect("Cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
}
