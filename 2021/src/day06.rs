fn line_mapper(line: &str) -> u64 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> u64 {
    println!("xs[0..3] {:?}", &xs[0..3]);

    let mapped: Vec<u64> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);

    let r: Vec<u64> = (1..=80).fold(mapped, |mut acc: Vec<u64>, _| {
        for idx in 0..acc.len() {
            if acc[idx] == 0 {
                acc[idx] = 6;
                acc.push(8);
            } else {
                acc[idx] -= 1;
            }
        }
        acc
    });
    r.iter().cloned().count() as u64
}
pub fn part2(xs: Vec<&str>) -> u64 {
    let mapped: Vec<u64> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let mut counter: [u64; 9] = [0; 9];
    for i in mapped {
        counter[i as usize] += 1;
    }
    dbg!(&counter);

    for _ in 1..=256 {
        let old = counter.clone();
        for n in 0..=8 {
            if n == 8 {
                counter[8] = old[0];
            } else {
                counter[n] = old[n + 1];
            }
            counter[6] = old[7] + old[0];
        }
    }
    counter.iter().sum()
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_61() {
        let s = fs::read_to_string("src/input06").expect("cannot read file");
        let xs = s.trim().split(",").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 377263);
    }
    #[test]
    fn test_62() {
        let s = fs::read_to_string("src/input06").expect("cannot read file");
        let xs = s.trim().split(",").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1695929023803);
    }
}
