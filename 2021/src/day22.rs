use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> (&str, ((i64, i64), (i64, i64), (i64, i64))) {
    let re = Regex::new(r"(?P<state>\w+) x=(?P<xs>-?\d+)..(?P<xe>-?\d+),y=(?P<ys>-?\d+)..(?P<ye>-?\d+),z=(?P<zs>-?\d+)..(?P<ze>-?\d+)").unwrap();

    let caps = re.captures(line).unwrap();
    let state = if &caps["state"] == "on" { "on" } else { "off" };

    (
        state,
        (
            (caps["xs"].parse().unwrap(), caps["xe"].parse().unwrap()),
            (caps["ys"].parse().unwrap(), caps["ye"].parse().unwrap()),
            (caps["zs"].parse().unwrap(), caps["ze"].parse().unwrap()),
        ),
    )
}

pub fn part1(xs: Vec<&str>) -> i64 {
    println!("xs[0..3] {:?}", &xs[0..3]);
    let mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();
    dbg!(&mapped);

    let mut set: HashSet<(i64, i64, i64)> = HashSet::new();
    for (state, ((xs, xe), (ys, ye), (zs, ze))) in mapped {
        if [xe, ye, ze].iter().any(|x| x < &-50) {
            continue;
        }
        if [xs, ys, zs].iter().any(|x| x > &50) {
            continue;
        }

        let xs = if xs < -50 { -50 } else { xs };
        let ys = if ys < -50 { -50 } else { ys };
        let zs = if zs < -50 { -50 } else { zs };
        let xe = if xe > 50 { 50 } else { xe };
        let ye = if ye > 50 { 50 } else { ye };
        let ze = if ze > 50 { 50 } else { ze };
        for x in xs..=xe {
            for y in ys..=ye {
                for z in zs..=ze {
                    if state == "off" {
                        set.remove(&(x, y, z));
                    } else {
                        set.extend([(x, y, z)]);
                    }
                }
            }
        }
    }

    set.len() as i64
}
pub fn part2(xs: Vec<&str>) -> i64 {
    let mut mapped: Vec<_> = xs.iter().map(|&line| line_mapper(line)).collect();

    fn disjoint((s1, e1): (i64, i64), (s2, e2): (i64, i64)) -> bool {
        e1 < s2 || e2 < s1
    }

    fn non_overlap(
        ((x1start, x1end), (y1start, y1end), (z1start, z1end)): (
            (i64, i64),
            (i64, i64),
            (i64, i64),
        ),
        ((x2start, x2end), (y2start, y2end), (z2start, z2end)): (
            (i64, i64),
            (i64, i64),
            (i64, i64),
        ),
    ) -> Vec<((i64, i64), (i64, i64), (i64, i64))> {
        if disjoint((x1start, x1end), (x2start, x2end))
            || disjoint((y1start, y1end), (y2start, y2end))
            || disjoint((z1start, z1end), (z2start, z2end))
        {
            return vec![((x1start, x1end), (y1start, y1end), (z1start, z1end))];
        }

        return vec![
            ((x1start, x1end), (y1start, y1end), (z1start, z2start - 1)),
            ((x1start, x1end), (y1start, y1end), (z2end + 1, z1end)),
            (
                (x1start, x2start - 1),
                (y1start, y1end),
                (z1start.max(z2start), z1end.min(z2end)),
            ),
            (
                (x2end + 1, x1end),
                (y1start, y1end),
                (z1start.max(z2start), z1end.min(z2end)),
            ),
            (
                (x1start.max(x2start), x1end.min(x2end)),
                (y1start, y2start - 1),
                (z1start.max(z2start), z1end.min(z2end)),
            ),
            (
                (x1start.max(x2start), x1end.min(x2end)),
                (y2end + 1, y1end),
                (z1start.max(z2start), z1end.min(z2end)),
            ),
        ]
        .iter()
        .filter(|(x, y, z)| [x, y, z].iter().all(|(s, e)| s <= e))
        .cloned()
        .collect();
    }

    let mut cuboids: Vec<_> = Vec::new();
    while mapped.len() > 0 {
        let (on_off, coordinate) = mapped.remove(0);
        let mut parts: Vec<_> = Vec::new();
        for c in cuboids {
            let mut ns = non_overlap(c, coordinate);
            parts.append(&mut ns);
        }
        if on_off == "on" {
            parts.push(coordinate);
        }

        cuboids = parts;
    }

    //for i in &cuboids {
    //    println!("{:?}", i);
    //}

    cuboids
        .iter()
        .map(|((x1start, x1end), (y1start, y1end), (z1start, z1end))| {
            (x1end - x1start + 1) * (y1end - y1start + 1) * (z1end - z1start + 1)
        })
        .sum()
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    static S: &str = "on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10";

    #[test]
    fn test_221() {
        let s = fs::read_to_string("src/input22").expect("cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part1(xs);
        assert_eq!(r, 611378);
    }
    #[test]
    fn test_222() {
        let s = fs::read_to_string("src/input22").expect("Cannot read file");
        let xs = s.trim().split("\n").collect::<Vec<&str>>();
        let r = part2(xs);
        assert_eq!(r, 1214313344725528);
    }
}
