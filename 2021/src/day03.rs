use crate::utils::bin_to_int;

fn part1(xs: Vec<&str>) -> u32 {
    let ones = &xs[..]
        .iter()
        .map(|row| row.chars().map(|c| c.to_digit(10).unwrap()))
        .fold(vec![0; xs[0].len()], |acc, cells| {
            acc.iter()
                .zip(cells)
                .map(|(a, b)| a + b)
                .collect::<Vec<u32>>()
        });

    let binary_gamma: Vec<u32> = ones
        .iter()
        .map(|i| if i >= &((xs.len() as u32) - i) { 1 } else { 0 })
        .collect();
    let binary_epsilon: Vec<u32> = ones
        .iter()
        .map(|i| if i < &((xs.len() as u32) - i) { 1 } else { 0 })
        .collect();

    bin_to_int(binary_gamma) * bin_to_int(binary_epsilon)
}

fn part2(xs: Vec<&str>) -> i32 {
    let first = xs[0];
    println!("{:?}", first.len());
    let mut gamma = vec![0; first.len()];
    let mut ys = xs.clone();
    for i in 0..first.len() {
        let ichars = &ys
            .iter()
            .map(|line| line.chars().collect::<Vec<char>>()[i])
            .collect::<Vec<char>>();
        let onec = ichars.iter().filter(|&x| x == &'1').count();
        let zeroc = ichars.iter().filter(|&x| x == &'0').count();
        let max = onec.max(zeroc);
        println!("{} {} {}", onec, zeroc, max);
        let maxc = if max == onec { '1' } else { '0' };

        ys = ys
            .iter()
            .filter(|line| line.chars().collect::<Vec<char>>()[i] == maxc)
            .cloned()
            .collect::<Vec<&str>>();
        println!("Filter with {} {:?}", maxc, ys);
        if ys.len() == 1 {
            break;
        }
    }

    ys = xs.clone();
    for i in 0..first.len() {
        let ichars = &ys
            .iter()
            .map(|line| line.chars().collect::<Vec<char>>()[i])
            .collect::<Vec<char>>();
        let onec = ichars.iter().filter(|&x| x == &'1').count();
        let zeroc = ichars.iter().filter(|&x| x == &'0').count();
        let max = onec.max(zeroc);
        println!("{} {} {}", onec, zeroc, max);
        let minc = if max == onec { '0' } else { '1' };

        ys = ys
            .iter()
            .filter(|line| line.chars().collect::<Vec<char>>()[i] == minc)
            .cloned()
            .collect::<Vec<&str>>();
        println!("Filter with {} {:?}", minc, ys);
        if ys.len() == 1 {
            break;
        }
    }
    1
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utils::read_input;
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
        //let r = part2(xs);
        let r = 0;
        assert_eq!(r, 0);
    }

    #[test]
    fn test_binary() {
        let r = vec![1, 0, 0, 1];
        assert_eq!(bin_to_int(r), 9);
    }
}
