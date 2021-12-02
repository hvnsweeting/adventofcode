fn part1(xs: Vec<&str>) -> i32 {
    let (x, y): (i32, i32) = xs
        .iter()
        .map(|s| match s.split(" ").collect::<Vec<&str>>()[..] {
            ["forward", n] => (n.parse().unwrap(), 0),
            ["down", n] => (0, n.parse().unwrap()),
            ["up", n] => (0, -(n.parse::<i32>().unwrap())),
            _ => panic!("bad pattern"),
        })
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
}
