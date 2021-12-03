use regex::Regex;

// TODO: how to write function return only ("forward", n)
fn parse_line(r: &Regex, s: &str) -> (i32, i32) {
    let caps = r.captures(s).unwrap();

    match (caps["n"].parse::<i32>().unwrap(), &caps["action"]) {
        (n, "forward") => (n, 0),
        (n, "down") => (0, n),
        (n, "up") => (0, -n),
        _ => panic!("bad pattern"),
    }
}

fn part1(xs: Vec<&str>) -> i32 {
    let r = Regex::new(r"(?P<action>\w+) (?P<n>\d+)").unwrap();
    let (x, y): (i32, i32) = xs
        .iter()
        .map(|line| parse_line(&r, line))
        .fold((0, 0), |(accx, accy), (x, y)| (x + accx, y + accy));
    x * y
}

fn part2(xs: Vec<&str>) -> i32 {
    let (x, y, _aim): (i32, i32, i32) =
        xs.iter().fold((0, 0, 0), |(accx, accy, acca), s| {
            match s.trim().split(" ").collect::<Vec<&str>>()[..] {
                ["forward", n] => (
                    accx + n.parse::<i32>().unwrap(),
                    accy + acca * n.parse::<i32>().unwrap(),
                    acca,
                ),
                ["down", n] => (accx, accy, acca + n.parse::<i32>().unwrap()),
                ["up", n] => (accx, accy, acca - n.parse::<i32>().unwrap()),

                _ => panic!("bad pattern"),
            }
        });
    x * y
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_p1() {
        let _s = "forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2";
        let s = fs::read_to_string("src/input02").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();

        let r = part1(xs);
        assert_eq!(r, 2322630);
    }

    #[test]
    fn test_p2() {
        let _s = "forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2";
        let s = fs::read_to_string("src/input02").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 2105273490);
    }

    #[test]
    fn test_regex() {
        use regex::Regex;
        let r = Regex::new(r"(?P<action>\w+) (?P<n>\d+)").unwrap();
        let caps = r.captures("down 5").unwrap();
        println!("{:?}", caps);
        assert_eq!(&caps["action"], "down");
        assert_eq!(&caps["n"], "5");
    }
}
