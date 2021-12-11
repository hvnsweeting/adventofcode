use std::collections::HashMap;

fn line_mapper(line: &str) -> Vec<i64> {
    line.chars()
        .map(|c| c.to_digit(10).unwrap() as i64)
        .collect()
}
fn make_map(rows: Vec<Vec<i64>>) -> HashMap<(i64, i64), i64> {
    let mut d: HashMap<(i64, i64), i64> = HashMap::new();
    for y in 0..rows.len() {
        for x in 0..rows[y].len() {
            d.insert((x as i64, y as i64), rows[y][x]);
        }
    }
    return d;
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    println!("mapped[0..3]: {:?}", &mapped[0..3]);
    let mut d = make_map(mapped);
    dbg!(&d);

    let mut flash_count = 0;
    for step in 1..=100 {
        dbg!(&step);
        let mut flash = Vec::new();
        for (k, _) in d.clone() {
            *d.entry(k).or_insert(0) += 1;
            if d.get(&k).unwrap() > &9 {
                flash.push(k);
            }
        }
        // do flash
        let mut stack = flash.clone();
        while stack.len() > 0 {
            let (x, y) = stack.pop().unwrap();
            let arounds = vec![
                (x - 1, y - 1),
                (x, y - 1),
                (x + 1, y - 1),
                (x - 1, y),
                (x + 1, y),
                (x - 1, y + 1),
                (x, y + 1),
                (x + 1, y + 1),
            ];
            for (xi, yi) in arounds {
                if d.contains_key(&(xi, yi)) {
                    *d.entry((xi, yi)).or_insert(0) += 1;
                    if d.get(&(xi, yi)).unwrap() > &9 && !flash.contains(&(xi, yi)) {
                        flash.push((xi, yi));
                        stack.push((xi, yi));
                    }
                }
            }
        }

        // to do reset 0
        let mut this_flash = 0;
        let keys = flash.clone();
        for k in keys {
            *d.entry(k).or_insert(0) = 0;
            this_flash += 1;
        }
        flash_count += this_flash;
    }
    flash_count as i64
}
pub fn part2(xs: Vec<&str>) -> i64 {
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    let mut d = make_map(mapped);

    let mut sync_step = 0;
    for step in 1..=100000 {
        dbg!(&step);
        let mut flash = Vec::new();
        let keys = d.clone();
        for (k, _) in keys {
            *d.entry(k).or_insert(0) += 1;
            if d.get(&k).unwrap() > &9 {
                flash.push(k);
            }
        }
        // do flash
        let mut stack = flash.clone();
        while stack.len() > 0 {
            let (x, y) = stack.pop().unwrap();
            let arounds = vec![
                (x - 1, y - 1),
                (x, y - 1),
                (x + 1, y - 1),
                (x - 1, y),
                (x + 1, y),
                (x - 1, y + 1),
                (x, y + 1),
                (x + 1, y + 1),
            ];
            for (xi, yi) in arounds {
                if d.contains_key(&(xi, yi)) {
                    *d.entry((xi, yi)).or_insert(0) += 1;
                    if d.get(&(xi, yi)).unwrap() > &9 && !flash.contains(&(xi, yi)) {
                        flash.push((xi, yi));
                        stack.push((xi, yi));
                    }
                }
            }
        }

        // to do reset 0
        let keys = flash.clone();
        let mut this_flash = 0;
        for k in keys {
            *d.entry(k).or_insert(0) = 0;
            this_flash += 1;
        }
        println!("{:?}", &d);
        if this_flash == 100 {
            sync_step = step;

            break;
        }
    }
    sync_step as i64
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    static _S: &str = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526";

    #[test]
    fn test_111() {
        let s = fs::read_to_string("src/input11").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 1594);
    }
    #[test]
    fn test_112() {
        let s = fs::read_to_string("src/input11").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 437);
    }
}
