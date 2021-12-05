pub fn part1(xs: Vec<&str>) -> u32 {
    1
}
pub fn part2(xs: Vec<&str>) -> u32 {
    1
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_61() {
        //let s = fs::read_to_string("src/input04").expect("cannot read file");
        let s = "";
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test_62() {
        //let s = fs::read_to_string("src/input04").expect("Cannot read file");
        let s = "";
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1);
    }
}
