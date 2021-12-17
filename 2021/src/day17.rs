use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

pub fn part1(xs: Vec<&str>) -> i64 {
    // println!("xs[0..3] {:?}", &xs[0..3]);
    //x=20..30, y=-10..-5
    //x=153..199, y=-114..-75
    let xmax = 199;
    let xmin = 153;
    let ymin = -114;
    let ymax = -75;

    let xmax = 30;
    let xmin = 20;
    let ymin = -10;
    let ymax = -5;
    let mut vec: Vec<_> = Vec::new();
    for x in 0..=6 {
        for y in 0..=9 {
            println!("init {:?} {:?}", x, y);
            let mut xi = 0;
            let mut yi = 0;
            let mut counter = 0;
            let mut local_vec: Vec<_> = Vec::new();
            while xi < xmax && yi > ymin {
                local_vec.push((xi, yi));
                dbg!(&xi, &yi);
                if xmin <= xi && xi <= xmax && yi >= ymin && yi <= ymax {
                    let (xm, ym) = local_vec
                        .iter()
                        .max_by(|(x1, y1), (x2, y2)| y1.cmp(y2))
                        .unwrap();
                    dbg!("max", &xm, &ym);

                    vec.push((*xm, *ym));
                    break;
                    //return xi * yi;
                }
                xi = xi + x - counter;
                yi = yi + y - counter;
                counter += 1;
            }
        }
    }
    let (x, y) = vec.iter().max_by(|&(x, y), (x2, y2)| y.cmp(y2)).unwrap();
    *y
    //dbg!(&(x, y));

    //x * y
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
    fn test_81() {
        let s = "1\n2\n3";
        //let s = fs::read_to_string("src/input17").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 0);
    }
    //#[test]
    fn test_82() {
        let s = "";
        //let s = fs::read_to_string("src/input17").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 0);
    }
}
