fn part1(xs: Vec<&str>) -> i32 {
    0
}
fn part2(xs: Vec<&str>) -> i32 {
    -1
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_p1() {
        //let s = fs::read_to_string("src/input03").expect("Cannot read file");
        let s = " ";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, -1);
    }

    #[test]
    fn test_p2() {
        //let s = fs::read_to_string("src/input03").expect("Cannot read file");
        let s = " ";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, -1);
    }
}
