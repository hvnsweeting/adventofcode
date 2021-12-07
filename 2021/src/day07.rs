fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped);
    let min = mapped.iter().min().unwrap().clone();
    let max = mapped.iter().max().unwrap().clone();
    (min..=max)
        .map(|i| mapped.iter().map(|&x| (x - i).abs()).sum())
        .min()
        .unwrap()
}
pub fn part2(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped);
    let min = mapped.iter().min().unwrap().clone();
    let max = mapped.iter().max().unwrap().clone();
    (min..=max)
        .map(|i| {
            mapped
                .iter()
                .map(|&x| (1..=(x - i).abs()).sum::<i64>())
                .sum()
        })
        .min()
        .unwrap()
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_71() {
        let s = fs::read_to_string("src/input07").expect("cannot read file");
        let xs = s.trim().split(",").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 352331);
    }
    #[test]
    fn test_72() {
        let s = "";
        let s = fs::read_to_string("src/input07").expect("cannot read file");
        let xs = s.trim().split(",").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 99266250);
    }
}
