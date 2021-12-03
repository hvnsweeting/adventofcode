use crate::utils::bin_to_int;

fn to_digits(row: &str) -> Vec<u32> {
    row.chars().map(|c| c.to_digit(10).unwrap()).collect()
}

// TODO: refactor out the code that parse a line
// TODO: refactor out the code that process matrix by columns
pub fn part1(xs: Vec<&str>) -> u32 {
    let ones = xs
        .iter()
        .map(|&row| to_digits(row))
        .fold(vec![0; xs[0].len()], |acc, cells| {
            // process (+) each line with the accumulator
            acc.iter()
                .zip(cells)
                .map(|(a, b)| a + b)
                .collect::<Vec<u32>>()
        });

    let total_lines = xs.len() as u32;
    let binary_gamma: Vec<u32> = ones
        .iter()
        .map(|&i| if i >= (total_lines - i) { 1 } else { 0 })
        .collect();
    let binary_epsilon: Vec<u32> = ones
        .iter()
        .map(|&i| if i < (total_lines - i) { 1 } else { 0 })
        .collect();

    bin_to_int(binary_gamma) * bin_to_int(binary_epsilon)
}

pub fn part2(xs: Vec<&str>) -> u32 {
    let first = xs[0];
    let mut ys: Vec<Vec<u32>> = xs
        .clone()
        .iter()
        .map(|&row| to_digits(row))
        //.map(|&line| line.chars().collect::<Vec<char>>()[i])
        .collect();

    let mut oxy: Vec<u32> = vec![];
    for i in 0..first.len() {
        let ichars = &ys.iter().map(|row| row[i]).collect::<Vec<u32>>();
        let onec = ichars.iter().filter(|&x| *x == 1).count();
        let zeroc = ichars.iter().filter(|&x| *x == 0).count();
        let max = onec.max(zeroc);
        let maxc = if max == onec { 1 } else { 0 };

        ys = ys.iter().filter(|line| line[i] == maxc).cloned().collect();
        println!("Filter with {} {:?}", maxc, ys);
        if ys.len() == 1 {
            oxy = ys.get(0).unwrap().clone();
            break;
        }
    }

    let mut ys: Vec<Vec<u32>> = xs
        .clone()
        .iter()
        .map(|&row| to_digits(row))
        //.map(|&line| line.chars().collect::<Vec<char>>()[i])
        .collect();

    let mut co2: Vec<u32> = vec![];
    for i in 0..first.len() {
        let ichars = &ys.iter().map(|row| row[i]).collect::<Vec<u32>>();
        let onec = ichars.iter().filter(|&x| *x == 1).count();
        let zeroc = ichars.iter().filter(|&x| *x == 0).count();
        let max = onec.max(zeroc);
        let minc = if max == onec { 0 } else { 1 };

        ys = ys.iter().filter(|line| line[i] == minc).cloned().collect();
        if ys.len() == 1 {
            co2 = ys.get(0).unwrap().clone();
            break;
        }
    }
    bin_to_int(oxy) * bin_to_int(co2)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_p1() {
        let s = fs::read_to_string("src/input03").expect("Cannot read file");
        let _s = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 2954600);
    }

    #[test]
    fn test_p2() {
        let s = fs::read_to_string("src/input03").expect("Cannot read file");
        let _s = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1662846);
    }

    #[test]
    fn test_binary() {
        let r = vec![1, 0, 0, 1];
        assert_eq!(bin_to_int(r), 9);
    }
}
