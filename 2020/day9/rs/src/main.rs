use std::{collections::HashMap, fs};

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");

    let inputs: Vec<i64> = contents
        .split("\n")
        .map(|i| i.parse().expect("Not a number!"))
        .collect();

    let mut preamble: HashMap<i64, bool> =
        inputs[0..25].iter().fold(HashMap::new(), |mut acc, i| {
            acc.insert(*i, true);
            acc
        });

    // let number = not_sum_of_pairs(inputs, &mut preamble, 25 as usize, 0);
    let number = find_weakness(inputs, 1398413738);

    println!("{}", number.unwrap_or(-1));
}

fn not_sum_of_pairs(
    inputs: Vec<i64>,
    preamble: &mut HashMap<i64, bool>,
    mut index: usize,
    mut cursor: usize,
) -> Option<i64> {
    for (i, number) in inputs.iter().skip(index).enumerate() {
        match find_non_pair(preamble, number) {
            Some(i) => return Some(i),
            _ => {}
        }
        preamble.remove(&inputs[cursor]);
        preamble.insert(inputs[index], true);
        index = index + 1;
        cursor = cursor + 1;
    }
    None
}

fn find_non_pair(preamble: &mut HashMap<i64, bool>, target: &i64) -> Option<i64> {
    for item in preamble.keys() {
        let key = i64::abs(target - item);
        if key / 2 == key {
            return None;
        }
        if preamble.contains_key(&key) {
            return None;
        }
    }
    Some(target.clone())
}

fn find_weakness(inputs: Vec<i64>, target: i64) -> Option<i64> {
    for (i, _) in inputs.iter().enumerate() {
        let mut accumulators = vec![];
        let clones = inputs.clone();
        for item in clones.iter().skip(i) {
            accumulators.push(item);
            let sum = accumulators.iter().fold(0, |mut acc, &a| {
                acc += a;
                acc
            });
            if sum > target {
                break;
            } else if sum == target {
                return Some(
                    *accumulators.iter().min().unwrap() + *accumulators.iter().max().unwrap(),
                );
            }
        }
    }
    None
}
