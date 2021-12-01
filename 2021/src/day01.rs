pub fn part1(xs: Vec<i32>) -> i32 {
    return xs
        .iter()
        .zip(&xs[1..])
        .map(|(x1, x2)| if x2 > x1 { 1 } else { 0 })
        .sum();
}

pub fn part2(xs: Vec<i32>) -> i32 {
    let sum3: Vec<i32> = xs
        .iter()
        .zip(&xs[1..])
        .zip(&xs[2..])
        .map(|((x1, x2), x3)| x1 + x2 + x3)
        .collect();

    part1(sum3)
}
