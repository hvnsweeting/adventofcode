use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    //x=153..199, y=-114..-75
    let xmax = 199;
    let xmin = 153;
    let ymin = -114;
    let ymax = -75;

    let mut vec: Vec<_> = Vec::new();
    for x in 0..=xmax {
        for y in -2000..=2000 {
            let mut xi = 0;
            let mut yi = 0;
            let mut counter = 0;
            let mut local_vec: Vec<_> = Vec::new();
            while xi <= xmax && yi >= ymin {
                local_vec.push((xi, yi));
                if xmin <= xi && xi <= xmax && yi >= ymin && yi <= ymax {
                    let (xm, ym) = local_vec
                        .iter()
                        .max_by(|(x1, y1), (x2, y2)| y1.cmp(y2))
                        .unwrap();

                    vec.push((*xm, *ym));
                    break;
                }
                let mut vx = x - counter;
                let mut vy = y - counter;
                if vx <= 0 {
                    vx = 0;
                } else {
                    xi = xi + vx;
                }
                yi = yi + vy;
                counter += 1;
            }
        }
    }
    let (x, y) = vec.iter().max_by(|&(x, y), (x2, y2)| y.cmp(y2)).unwrap();
    *y
}
pub fn part2(xs: Vec<&str>) -> i64 {
    //x=153..199, y=-114..-75
    let xmax = 199;
    let xmin = 153;
    let ymin = -114;
    let ymax = -75;

    //let xmax = 30;
    //let xmin = 20;
    //let ymin = -10;
    //let ymax = -5;
    let mut vec: Vec<_> = Vec::new();
    for x in 0..=xmax {
        for y in -2000..=2000 {
            let mut xi = 0;
            let mut yi = 0;
            let mut counter = 0;
            let mut local_vec: Vec<_> = Vec::new();
            while xi <= xmax && yi >= ymin {
                local_vec.push((xi, yi));
                if xmin <= xi && xi <= xmax && yi >= ymin && yi <= ymax {
                    let (xm, ym) = local_vec
                        .iter()
                        .max_by(|(x1, y1), (x2, y2)| y1.cmp(y2))
                        .unwrap();
                    vec.push((xi, yi));
                    break;
                }
                let mut vx = x - counter;
                let mut vy = y - counter;
                if vx <= 0 {
                    vx = 0;
                } else {
                    xi = xi + vx;
                }
                yi = yi + vy;
                counter += 1;
            }
        }
    }
    vec.iter().count() as i64
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_171() {
        let s = "1\n2\n3";
        //let s = fs::read_to_string("src/input17").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 6441);
    }
    #[test]
    fn test_172() {
        let s = "";
        //let s = fs::read_to_string("src/input17").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 3186);
    }
}
