use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    let dots_str = xs[0];
    let instructions_str = xs[1];
    let instructions_lines = instructions_str.trim().split("\n").collect::<Vec<&str>>();

    let re = Regex::new(r"fold along (?P<fold>\w+)=(?P<n>\d+)").unwrap();
    let mut instructions: Vec<(&str, i64)> = vec![];
    for line in instructions_lines {
        let caps = re.captures(line).unwrap();
        instructions.push((caps.get(1).unwrap().as_str(), caps["n"].parse().unwrap()));
    }
    println!("{:?}", &instructions);

    let dots = dots_str.trim().split("\n").collect::<Vec<&str>>();
    dbg!(&dots);

    let mapped: Vec<_> = dots
        .iter()
        .map(|&line| match line.split(",").collect::<Vec<&str>>()[..] {
            [x, y] => (x.parse::<i64>().unwrap(), y.parse::<i64>().unwrap()),
            _ => panic!("Not reach here"),
        })
        .collect();

    let mut new_dots: Vec<_> = Vec::new();
    // fold y= 7
    let instruction = instructions[0];
    let (axis, fold) = instruction;
    if axis == "y" {
        let yfold = fold;
        for (x, y) in mapped {
            if y == yfold {
                continue;
            }
            if y > yfold {
                let new_y = yfold * 2 - y;
                if !new_dots.contains(&(x, new_y)) {
                    new_dots.push((x, new_y));
                }
            } else {
                if !new_dots.contains(&(x, y)) {
                    new_dots.push((x, y));
                }
            }
        }
    } else {
        for (x, y) in mapped {
            let xfold = fold;
            if x == xfold {
                continue;
            }
            if x > xfold {
                let new_x = xfold * 2 - x;
                if !new_dots.contains(&(new_x, y)) {
                    new_dots.push((new_x, y));
                }
            } else {
                if !new_dots.contains(&(x, y)) {
                    new_dots.push((x, y));
                }
            }
        }
    }
    println!("{:?}", &new_dots);
    new_dots.iter().len() as i64
}
pub fn part2(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    1
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_131() {
        let s = "6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5";
        let s = fs::read_to_string("src/input13").expect("cannot read file");
        let xs = s.trim().split("\n\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test_82() {
        let s = "";
        //let s = fs::read_to_string("src/input08").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}
