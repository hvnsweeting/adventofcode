mod day01;
mod utils;

use std::fs;

fn main() {
    let s = fs::read_to_string("src/input01").expect("Cannot read file");
    let xs = utils::read_input(s);
    let r = day01::part1(xs);
    println!("{:?}", r);

    let s = fs::read_to_string("src/input01").expect("Cannot read file");
    let xs = utils::read_input(s);
    let r = day01::part2(xs);
    println!("{} ", r);
}
