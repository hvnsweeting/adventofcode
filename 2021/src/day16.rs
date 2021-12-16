use crate::utils::bin_to_int;
use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}
fn read_packet(xs: &str) -> usize {
    let mut i = 0;
    loop {
        let version = &xs[i..i + 3];
        i = i + 3;
        println!(
            "version {} {}",
            &version,
            i64::from_str_radix(&version, 2).unwrap()
        );

        let type_id = i64::from_str_radix(&xs[i..i + 3], 2).unwrap();
        //println!("{} type_id {}", &xs[i..i + 3], type_id);
        i = i + 3;
        if type_id == 4 {
            // literal value
            let mut number_parts = vec![];
            loop {
                if i > xs.len() {
                    break;
                }

                if &xs[i..i + 1] == "1" {
                    number_parts.push(&xs[i + 1..i + 5]);
                    //      dbg!(&number_parts);
                    i = i + 5;
                } else if &xs[i..i + 1] == "0" {
                    number_parts.push(&xs[i + 1..i + 5]);
                    i = i + 5;
                    //       dbg!(&number_parts);
                    break;
                }
            }
            let s = number_parts.join("");
            let n = i64::from_str_radix(s.as_str(), 2).unwrap();
            //dbg!(&n);
            print!(" {} ", n);
            //println!("i:{} n:{}", i, n);
            return i;
        } else {
            let operator = match type_id {
                0 => "+",
                1 => "*",
                2 => "min",
                3 => "max",
                5 => ">",
                6 => "<",
                7 => "=",
                _ => panic!("Bad operator"),
            };
            print!("({} ", operator);
            let length_type_id = &xs[i..i + 1];
            i = i + 1;
            if length_type_id == "0" {
                let total_len_in_bits = usize::from_str_radix(&xs[i..i + 15], 2).unwrap();
                //dbg!("sub of len", &total_len_in_bits);

                i = i + 15;

                let mut j = 0;
                //dbg!(&i);

                while j < total_len_in_bits {
                    let v = read_packet(&xs[i..xs.len()]);
                    //dbg!(&v);

                    i += v;
                    j += v;
                }
                //dbg!("after", &i);
                //

                print!(" )");
                return i;
            } else if length_type_id == "1" {
                let number_of_subpackets = usize::from_str_radix(&xs[i..i + 11], 2).unwrap();
                i = i + 11;
                //dbg!("subpacket", &number_of_subpackets);

                for j in 0..number_of_subpackets {
                    let mut r = &xs[i..xs.len()];

                    i += read_packet(r);
                }
                print!(")");
                return i;
            }
        }
        if i >= xs.len() {
            return 0;
        }
    }
}

pub fn part1(xs: &str) -> i64 {
    println!("xs[0..3] {:?}", &xs);
    read_packet(xs);
    // this outputs in stdout "versions", use grep to grep the result, use
    // cut and bc to calculate sum, got
    886
}
pub fn part2(xs: &str) -> i64 {
    println!("xs[0..3] {:?}", &xs);
    read_packet(xs);
    // comment out verions printing code
    // this outputs expressions like + a b, as it looks and behave like
    // LISP code, so add `(` and `)` where needed and print out the S-expression
    // put it into a LISP program, here use Clojure, and run
    // replace > with larger, < with smaller, = with equal
    // (defn larger [a b]
    //  (if (> a b) 1 0))
    //(defn smaller [a b]
    //  (if (< a b) 1 0))
    //(defn equal [a b]
    //  (if (= a b) 1 0))
    //
    //(defn -main
    //  "I don't do a whole lot ... yet."
    //  [& args]
    //  (time (reduce + (range 1 100000000)))
    //  (def r
    //(+ (*  425542 (smaller  247  247 ))(+  121  21236  )(* (larger  (+  11  12  11  )(+  7  10  7 )) 32566  )(* (smaller (+  8  7  15  )(+  6  11  10  ) ) 4507180  )(min (* (* (+ (* (max (* (min (* (min (* (max (+ (+ (max (+ (+ (min (* (*  130 )) ))))) )) )))))) ) )) )) 139930778832 (* (larger   52  667118 ) 10  ) 602147 (max  62199 )(*  14849899 (smaller  11716  26963  ))(*  4083 (larger   135  135  ) )(*  135  217  224  ) 73 (* (+  13  4  9  )(+  12  15  7  )(+  13  10  9 ) )(min  194 )(*  182  197  136  2  242 )(*  226  142  34  124  )(max  4025  186042  )(min  30059  126119002  )(min  9  260  162 )(* (smaller  4  4 ) 28699  )(*  1945 (equal  1714  1714  ) )(*  7 (smaller  1545  108  ))(+  12 )(*  200 (larger   31050  655605  )) 3154 (*  3 (smaller  64896  116 )) 3055 (*  13 )(min  48082  226938  1175  68077774919 )(+  66  15  181  1380642642  11831587  )(*  241  59  )(*  150 (larger   2742  113  )) 37007908601 (max  52444  11  13008816  2935 ) 20723  8 (*  5 (larger   6241732  759708  ) )(+ (*  15  7  4 )(*  14  2  12 )(*  13  6  6  ))(+  2877  229333  655820  1020971 )(+  39581  2  14 )(max  982557  44  31  ) 68 (* (equal  11530  3492 ) 41177  )(* (equal  236  918711093  ) 3937 )(max  903466  228  6  25989131  4028  ) 229 (min  299875  10969849  11481  2281  13 )(*  55300721 (larger   63  63  ))(*  244 (larger  (+  7  13  7  )(+  12  5  14 )) )(*  4494263 (equal (+  4  15  4  )(+  3  3  14 )) )(* (smaller  45  3307915 ) 58514  )(*  3596530693 (smaller (+  3  12  4 )(+  9  11  2 )) ) )
    //)
    //  (println r))
    //
    184487454837
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    fn hex_to_bin(hex: &str) -> Vec<&str> {
        hex.chars()
            .map(|c| match c {
                '0' => "0000",
                '1' => "0001",
                '2' => "0010",
                '3' => "0011",
                '4' => "0100",
                '5' => "0101",
                '6' => "0110",
                '7' => "0111",
                '8' => "1000",
                '9' => "1001",
                'A' => "1010",
                'B' => "1011",
                'C' => "1100",
                'D' => "1101",
                'E' => "1110",
                'F' => "1111",
                _ => panic!("Not reach here"),
            })
            .collect()
    }

    #[test]
    fn test_161() {
        let s = fs::read_to_string("src/input16").expect("cannot read file");
        let joined = hex_to_bin(s.trim()).join("");
        let xs = joined.as_str();
        let r = part1(xs);
        assert_eq!(r, 886);
    }
    #[test]
    fn test_162() {
        let s = fs::read_to_string("src/input16").expect("Cannot read file");
        let joined = hex_to_bin(s.trim()).join("");
        let xs = joined.as_str();
        let r = part2(xs);
        assert_eq!(r, 184487454837);
    }
}
