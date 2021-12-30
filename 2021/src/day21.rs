use std::collections::HashMap;

fn line_mapper(line: &str) -> i64 {
    line.parse().unwrap()
}

fn play(dice_counter: i64, dice: i64, position: i64, score: i64) -> (i64, i64, i64, i64) {
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
            let (dc, d, position, score) = play(dice_counter, dice, position, score);
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

fn universe_win(
    player: bool,
    scores: &mut [i64; 2],
    positions: &mut [i64; 2],
    dice: i64,
    level: i32,
) -> i64 {
    println!(
        "{}.{:?} {:?} {:?} {:?}",
        level, player, dice, positions, scores
    );
    let n = if player == true { 0 } else { 1 };
    let mut score = scores[n];
    let mut pos = positions[n];

    if score >= 21 {
        return 1;
    }
    pos = (pos + dice);
    pos = if pos > 10 {
        let r = pos % 10;
        if r == 0 {
            10
        } else {
            r
        }
    } else {
        pos
    };
    score += pos;
    scores[n] = score;
    positions[n] = pos;

    return universe_win(!player, scores, positions, 1, level + 1)
        + universe_win(!player, scores, positions, 2, level + 1)
        + universe_win(!player, scores, positions, 3, level + 1)
        + universe_win(!player, scores, positions, 1, level + 1)
        + universe_win(!player, scores, positions, 2, level + 1)
        + universe_win(!player, scores, positions, 3, level + 1)
        + universe_win(!player, scores, positions, 1, level + 1)
        + universe_win(!player, scores, positions, 2, level + 1)
        + universe_win(!player, scores, positions, 3, level + 1);
}
pub fn part2(xs: Vec<&str>) -> i64 {
    universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 1, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 2, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 3, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 1, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 2, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 3, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 1, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 2, 0)
        + universe_win(false, &mut [0i64, 0i64], &mut [4i64, 8i64], 3, 0)
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
    //#[test]
    fn test_212() {
        let r = part2(vec![]);
        assert_eq!(r, 0);
    }
}
