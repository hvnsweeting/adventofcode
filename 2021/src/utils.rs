pub fn read_input(s: String) -> Vec<i32> {
    s.trim()
        .split("\n")
        .collect::<Vec<&str>>()
        .iter()
        .map(|x| x.parse().unwrap())
        .collect()
}

pub fn bin_to_int(v: Vec<u32>) -> u32 {
    v.iter()
        .enumerate()
        .map(|(idx, i)| i * 2u32.pow((v.len() - idx - 1) as u32))
        .sum()
}
