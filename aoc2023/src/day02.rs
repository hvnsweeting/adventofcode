fn parse_line(line: &str) -> i32 {
    const RED: i32 = 12;
    const GREEN: i32 = 13;
    const BLUE: i32 = 14;
    let Some((game, sets)) = line.split_once(':') else {
        panic!("Bad input: {}", line);
    };
    for set in sets.split(';') {
        for c in set.split(',') {
            if c.ends_with("blue") {
                let v: i32 = c.trim().split(' ').next().unwrap().parse().unwrap();
                if v > BLUE {
                    return 0;
                }
            }
            if c.ends_with("red") {
                let v: i32 = c.trim().split(' ').next().unwrap().parse().unwrap();
                if v > RED {
                    return 0;
                }
            }
            if c.ends_with("green") {
                let v: i32 = c.trim().split(' ').next().unwrap().parse().unwrap();
                if v > GREEN {
                    return 0;
                }
            }
        }
    }
    let Some((_game, game_id)) = game.split_once(' ') else {
        panic!("Bad game: {}", game);
    };
    return game_id.parse::<i32>().unwrap();
}

pub fn part1(s: &str) -> i32 {
    s.trim().lines().map(parse_line).sum()
}

fn parse_line_p2(line: &str) -> i32 {
    let mut red = 1;
    let mut green = 1;
    let mut blue = 1;
    let Some((_game, sets)) = line.split_once(':') else {
        panic!("Bad input: {}", line);
    };
    for set in sets.split(';') {
        for c in set.split(',') {
            let Some((v, color)) = c.trim().split_once(' ') else {
                panic!("Bad : {}", c);
            };
            let v = v.parse::<i32>().unwrap();

            match (v, color) {
                (v, "blue") => {
                    if v > blue {
                        blue = v;
                    }
                }
                (v, "green") => {
                    if v > green {
                        green = v;
                    }
                }
                (v, "red") => {
                    if v > red {
                        red = v;
                    }
                }
                _ => {
                    panic!("Bad {:?} {:?}", v, color);
                }
            }
        }
    }
    red * green * blue
}

pub fn part2(s: &str) -> i32 {
    s.trim().lines().map(parse_line_p2).sum()
}

#[cfg(test)]
mod tests {
    use super::*;
    //use std::fs;
    const S: &str = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
";
    #[test]
    fn p1() {
        assert_eq!(part1(S), 8);
        //let s2 = fs::read_to_string("./src/input02.txt").unwrap();
        //assert_eq!(part1(s2.as_str()), 2720);
    }

    #[test]
    fn p2() {
        assert_eq!(part2(S), 2286);
        //let s2 = fs::read_to_string("./src/input02.txt").unwrap();
        //assert_eq!(part2(s2.as_str()), 71535);
    }
}
