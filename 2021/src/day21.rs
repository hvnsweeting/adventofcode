/// Questions before solve, to review after solved
/// On p2
/// while can play a game, how to count all game?
/// what data structure used for that? passing something along recursive?
///
use std::collections::HashMap;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

fn play_turn(dice_counter: i64, dice: i64, position: i64, score: i64) -> (i64, i64, i64, i64) {
    let mut dice_counter = dice_counter;
    let mut dice = dice;
    let mut position = position;
    for _ in 0..3 {
        dice_counter = dice_counter + 1;
        dice = dice + 1;
        dice = if dice > 100 { 1 } else { dice };
        position = position + dice;
    }

    position = if position > 10 {
        let r = position % 10;
        if r == 0 {
            10
        } else {
            r
        }
    } else {
        position
    };
    let score = score + position;
    return (dice_counter, dice, position, score);
}

pub fn part1(xs: Vec<&str>) -> i64 {
    let start1 = 10;
    let start2 = 8;

    let mut dice_counter = 0;
    let mut dice = 0;

    let mut game: HashMap<i64, (i64, i64)> = HashMap::from([(0, (start1, 0)), (1, (start2, 0))]);

    loop {
        for p in [0, 1] {
            let (position, score) = game[&p];
            let (dc, d, position, score) = play_turn(dice_counter, dice, position, score);
            dice_counter = dc;
            dice = d;
            *game.entry(p).or_insert((position, score)) = (position, score);
            dbg!(&game, dice_counter);
            if score >= 1000 {
                let (_, lose_score) = game[&(p - 1).abs()];
                return lose_score * dice_counter;
            }
        }
    }
}

pub fn part2(xs: Vec<&str>) -> i64 {
    fn count_win(
        memoiz: &mut HashMap<(i64, i64, i64, i64), (i64, i64)>,
        p1: i64,
        p2: i64,
        score1: i64,
        score2: i64,
    ) -> (i64, i64) {
        if score1 >= 21 {
            return (1, 0);
        }
        if score2 >= 21 {
            return (0, 1);
        }

        if memoiz.contains_key(&(p1, p2, score1, score2)) {
            return memoiz[&(p1, p2, score1, score2)];
        }

        let mut answer = (0, 0);
        for d1 in 1..=3 {
            for d2 in 1..=3 {
                for d3 in 1..=3 {
                    let new_p1 = (p1 + d1 + d2 + d3) % 10;
                    let new_score1 = score1 + new_p1 + 1;

                    let (c2, c1) = count_win(memoiz, p2, new_p1, score2, new_score1);
                    answer = (answer.0 + c1, answer.1 + c2);
                }
            }
        }
        *memoiz.entry((p1, p2, score1, score2)).or_insert((0, 0)) = answer;
        return answer;
    }
    let start1 = 10 - 1;
    let start2 = 8 - 1;
    let mut memoiz: HashMap<(i64, i64, i64, i64), (i64, i64)> = HashMap::new();
    let (w1, w2) = count_win(&mut memoiz, start1, start2, 0, 0);
    w1.max(w2)
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_211() {
        let r = part1(vec![]);
        assert_eq!(r, 752247);
    }
    #[test]
    fn test_212() {
        let r = part2(vec![]);
        assert_eq!(r, 221109915584112);
    }
}
