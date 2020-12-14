use std::{collections::HashMap, fs};

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "16
    // 10
    // 15
    // 5
    // 1
    // 11
    // 7
    // 19
    // 6
    // 12
    // 4";
    //     let contents = "28
    // 33
    // 18
    // 42
    // 31
    // 14
    // 46
    // 20
    // 48
    // 47
    // 24
    // 23
    // 49
    // 45
    // 19
    // 38
    // 39
    // 11
    // 1
    // 32
    // 25
    // 35
    // 8
    // 17
    // 7
    // 9
    // 4
    // 2
    // 34
    // 10
    // 3";

    let mut inputs: Vec<i32> = contents
        .trim()
        .split("\n")
        .map(|i| i.parse().expect("Not a number!"))
        .collect();

    let max = inputs.iter().max().unwrap().clone();
    // inputs.push(0);
    inputs.push(max + 3);
    inputs.sort();

    // adapters_array_one(inputs);

    adapters_array_two(inputs);
}

fn adapters_array_one(inputs: Vec<i32>) {
    let mut counts: HashMap<i32, i32> = HashMap::new();

    for adapters in inputs.windows(2) {
        let current = adapters[0];
        let next = adapters[1];
        let difference = next - current;
        let value = counts.get(&difference).unwrap_or(&0);
        counts.insert(difference, value + 1);
    }

    println!(
        "{}",
        counts.values().fold(1, |mut acc, i| {
            acc *= i;
            acc
        })
    );
}

fn adapters_array_two(inputs: Vec<i32>) {
    let mut paths: HashMap<i32, i64> = HashMap::new();
    paths.insert(0, 1);
    for input in inputs.iter() {
        let mut total = 0;
        for i in 1..4 {
            total += paths.get(&(input - i)).unwrap_or(&0);
        }
        paths.insert(input.clone(), total);
    }
    println!("Output: {}", paths.get(&inputs.last().unwrap()).unwrap())
}
