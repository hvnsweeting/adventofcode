pub fn read_input(s: String) -> Vec<i32> {
    s.trim()
        .split("\n")
        .collect::<Vec<&str>>()
        .iter()
        .map(|x| x.parse().unwrap())
        .collect()
}
