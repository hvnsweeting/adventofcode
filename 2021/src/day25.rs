use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> Vec<char> {
    line.chars().collect()
}
fn make_map(rows: Vec<Vec<char>>) -> HashMap<(i64, i64), char> {
    let mut d: HashMap<(i64, i64), char> = HashMap::new();
    for y in 0..rows.len() {
        for x in 0..rows[y].len() {
            if rows[y][x] != '.' {
                d.insert((x as i64, y as i64), rows[y][x]);
            }
        }
    }
    return d;
}
fn print_table(map: &HashMap<(i64, i64), char>) {
    let &maxx = map.keys().map(|(x, y)| x).max().unwrap();
    let &maxy = map.keys().map(|(x, y)| y).max().unwrap();

    for y in 0..=maxy {
        for x in 0..=maxx {
            print!("{}|", map.get(&(x, y)).or(Some(&'.')).unwrap());
        }
        print!("\n");
    }
    println!("====");
}

pub fn part1(xs: Vec<&str>) -> i64 {
    //println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let mut m = make_map(mapped.clone());
    //println!("mapped[0..3]: {:?}", &mapped[0..3]);
    dbg!(&m);
    print_table(&m);

    let maxy: i64 = (&mapped.iter().len() - 1) as i64;
    let maxx: i64 = (&mapped[0].iter().len() - 1) as i64;
    dbg!(&maxx, &maxy);

    let mut counter = 0;
    loop {
        //for n in 1..=60 {
        let mut changed = 0;
        //dbg!(&n);
        let mut xs: Vec<(i64, i64)> = m.keys().cloned().collect();
        xs.sort();

        let mut newm = m.clone();
        for ((x, y)) in xs.clone() {
            if m[&(x, y)] == '>' {
                if x == maxx {
                    if !m.contains_key(&(0, y)) {
                        newm.remove_entry(&(x, y));
                        *newm.entry((0, y)).or_insert('>') = '>';
                        changed += 1;
                    }
                    continue;
                }
                if !m.contains_key(&(x + 1, y)) {
                    newm.remove_entry(&(x, y));
                    *newm.entry((x + 1, y)).or_insert('>') = '>';
                    changed += 1;
                }
            }
        }
        m = newm;
        let mut xs: Vec<(i64, i64)> = m.keys().cloned().collect();
        xs.sort_by(|(x1, y1), (x2, y2)| y2.cmp(y1));
        //dbg!(&xs);
        let mut newm = m.clone();
        for ((x, y)) in xs.clone() {
            if m[&(x, y)] == 'v' {
                if y == maxy {
                    if !m.contains_key(&(x, 0)) {
                        newm.remove_entry(&(x, y));
                        *newm.entry((x, 0)).or_insert('v') = 'v';
                        changed += 1;
                    }
                    continue;
                }
                if y != maxy && !m.contains_key(&(x, y + 1)) {
                    newm.remove_entry(&(x, y));
                    *newm.entry((x, y + 1)).or_insert('v') = 'v';
                    changed += 1;
                    continue;
                }
            }
        }
        m = newm;

        print_table(&m);
        dbg!(&changed);

        counter = counter + 1;
        if changed == 0 {
            return counter;
        }
    }

    1
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
    fn test_251() {
        let s = "...>...
.......
......>
v.....>
......>
.......
..vvv..";
        let s = "v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>";
        let s = fs::read_to_string("src/input25").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 492);
    }
}
