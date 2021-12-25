use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;

//struct <'a Instruction {
//    ops: &str,
//    arg1: i64,
//    arg2: Option<i64>,
//}

fn line_mapper(line: &str) -> i64 {
    //line.parse().unwrap()//;
    // The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:

    // inp a - Read an input value and write it to variable a.
    // add a b - Add the value of a to the value of b, then store the result in variable a.
    // mul a b - Multiply the value of a by the value of b, then store the result in variable a.
    // div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
    // mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
    // eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
    //let xs: Vec<_> = line.split(" ").collect();
    //match &xs[..] {
    //    ["inp", var] => ("inp", var),
    //    ["inp", var] => ("inp", var),
    //    ["inp", var] => ("inp", var),
    //    ["inp", var] => ("inp", var),
    //    ["inp", var] => ("inp", var),
    //}
    1
}
fn run<'a>(xs: &'a Vec<&str>, mut model: VecDeque<i64>) -> HashMap<&'a str, i64> {
    let mut d: HashMap<&str, i64> = HashMap::from([("x", 0), ("y", 0), ("z", 0), ("w", 0)]);
    let mut vec: VecDeque<_> = VecDeque::from([
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    ]);
    let mut v: char = ' ';
    for line in xs {
        let xs: Vec<_> = line.split(" ").collect();
        println!("{:?} x: {} y: {} z: {}", v, &d["x"], &d["y"], &d["z"]);
        dbg!(&line);

        match &xs[..] {
            ["inp", var] => {
                let k = model.pop_front().unwrap();
                dbg!("after a inp", k, &d);
                v = vec.pop_front().unwrap();
                d.insert(var, k);
            }
            ["add", a, b] => {
                let bval = if d.contains_key(b) {
                    d[b]
                } else {
                    //dbg!("WTF", &xs);

                    b.parse::<i64>().unwrap()
                };
                *d.entry(a).or_insert(0) += bval;
            }
            //["mul", a, b] => ("inp", var),
            ["mul", a, b] => {
                let bval = if d.contains_key(b) {
                    d[b]
                } else {
                    b.parse::<i64>().unwrap()
                };
                *d.entry(a).or_insert(0) *= bval;
            }
            //["div", a, b] => ("inp", var),
            ["div", a, b] => {
                let bval = if d.contains_key(b) {
                    d[b]
                } else {
                    b.parse::<i64>().unwrap()
                };
                *d.entry(a).or_insert(0) /= bval;
            }
            ["mod", a, b] => {
                let bval = if d.contains_key(b) {
                    d[b]
                } else {
                    b.parse::<i64>().unwrap()
                };
                *d.entry(a).or_insert(0) %= bval;
            }
            ["eql", a, b] => {
                let bval = if d.contains_key(b) {
                    d[b]
                } else {
                    b.parse::<i64>().unwrap()
                };
                if d[a] == bval {
                    dbg!("Equal", &bval);

                    *d.entry(a).or_insert(0) = 1
                } else {
                    *d.entry(a).or_insert(0) = 0
                }
            } //["eql", a, b] => ("inp", var),
            _ => panic!("Not here"),
        }
        //dbg!(&d);
    }

    return d;
}

fn find_model(
    intructions: &[(i64, i64, i64)],
    z: i64,
    mut result: Vec<i64>,
    rev: bool,
) -> Vec<i64> {
    let len = intructions.len();
    if len == 0 {
        if z == 0 {
            return result.clone();
        } else {
            return vec![];
        }
    }

    let (div, x, y) = intructions[0];
    if div == 26 {
        if !(0 < z % 26 + x && z % 26 + x < 10) {
            return vec![];
        }
        result.push(z % 26 + x);
        return find_model(&intructions[1..len], z / div, result, rev);
    } else {
        let range: Vec<i64> = if rev {
            (1..10).rev().collect()
        } else {
            (1..10).collect()
        };
        for i in range {
            let mut nr = result.clone();
            nr.push(i);
            let r = find_model(&intructions[1..len], z / div * 26 + y + i, nr, rev);
            if r.len() != 0 {
                return r;
            }
        }
        return vec![];
    }
}
fn get_number(s: &str) -> i64 {
    let v = s.split(" ").collect::<Vec<&str>>();
    match &v[..] {
        [_, _, n] => n.parse::<i64>().unwrap(),
        _ => panic!("NOT HERE"),
    }
}

pub fn part1(xs: Vec<&str>) -> i64 {
    let mut vec: Vec<(i64, i64, i64)> = Vec::new();
    let mut idx = 0;
    while idx + 18 <= xs.len() {
        let trunk = &xs[idx..idx + 18];
        idx += 18;
        let div = get_number(trunk[4]);
        let x = get_number(trunk[5]);
        let y = get_number(trunk[15]);
        vec.push((div, x, y));
    }

    let ds = find_model(&vec, 0, vec![], true);
    dbg!(&ds);
    ds.iter()
        .zip((0..ds.len()).rev())
        .fold(0, |acc, (d, pow)| acc + d * 10_i64.pow(pow as u32))
}
pub fn part2(xs: Vec<&str>) -> i64 {
    let mut vec: Vec<(i64, i64, i64)> = Vec::new();
    let mut idx = 0;
    while idx + 18 <= xs.len() {
        let trunk = &xs[idx..idx + 18];
        idx += 18;
        let div = get_number(trunk[4]);
        let x = get_number(trunk[5]);
        let y = get_number(trunk[15]);
        vec.push((div, x, y));
    }

    let ds = find_model(&vec, 0, vec![], false);
    dbg!(&ds);
    ds.iter()
        .zip((0..ds.len()).rev())
        .fold(0, |acc, (d, pow)| acc + d * 10_i64.pow(pow as u32))
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_240() {
        let s = "inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2";
        let xs = s.trim().split("\n").collect::<Vec<&str>>();

        let r = run(&xs, VecDeque::from([15]));
        //let r = part1(xs);
        assert_eq!(r["z"], 1);
    }
    #[test]
    fn test_241() {
        let s = fs::read_to_string("src/input24").expect("cannot read file");
        for (part, c) in s.trim().split("inp w").collect::<Vec<&str>>().iter().zip(
            [
                'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
            ]
            .iter(),
        ) {
            let lines = part.trim().lines().collect::<Vec<&str>>();
            if lines.len() > 0 {
                //for line in part.trim().lines() {
                println!("{}", c);
                println!("{:?}", lines[3]);
                println!("{:?}", lines[4]);
                println!("{:?}", lines[14]);
                println!("===");
            }
        }
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 29989297949519);
    }
    #[test]
    fn test_242() {
        let s = fs::read_to_string("src/input24").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 19518121316118);
    }
}
