pub fn part1(xs: Vec<i32>) -> i32 {
    let mut c = 0;
    let mut prev = -1;
    for n in &xs {
        if prev == -1 {
            prev = *n;
            continue;
        }

        if *n > prev {
            c = c + 1;
        }
        prev = *n;
    }
    return c;
}

pub fn part2(xs: Vec<i32>) -> i32 {
    let mut c = 0;
    let mut oldsum = -1;
    for (idx, x) in xs.iter().enumerate() {
        if idx == xs.len() - 2 {
            break;
        }

        let sum3 = x + xs[idx + 1] + xs[idx + 2];
        if oldsum == -1 {
            oldsum = sum3;
            continue;
        }
        if sum3 > oldsum {
            c = c + 1
        }
        oldsum = sum3;
    }
    c
}
