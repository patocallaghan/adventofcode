use std::collections::HashSet;
use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "abc

    // a
    // b
    // c

    // ab
    // ac

    // a
    // a
    // a
    // a

    // b";

    println!("output: {}", custom_two(&contents[..]));
}

fn custom_two(questions: &str) -> usize {
    let groups: Vec<Vec<Vec<char>>> = questions
        .trim()
        .split("\n\n")
        .map(|g| {
            let split_groups: Vec<&str> = g.split("\n").collect();
            return split_groups.iter().map(|&s| s.chars().collect()).collect();
        })
        .collect();

    let mapped_groups: Vec<usize> = groups
        .iter()
        .map(|g| {
            return g
                .iter()
                .fold(
                    "abcdefghijklmnopqrstuvwxyz".chars().collect(),
                    |acc: Vec<char>, inner_g| {
                        let a: HashSet<char> = acc.into_iter().collect();
                        let b: HashSet<char> = inner_g.into_iter().map(|s| *s).collect();
                        a.intersection(&b).map(|s| *s).collect()
                    },
                )
                .len();
        })
        .collect();

    return mapped_groups.iter().fold(0, |acc, g| acc + g);
}

fn custom_one(questions: &str) -> usize {
    let groups: Vec<Vec<char>> = questions
        .trim()
        .split("\n\n")
        .map(|g| {
            let mut chars: Vec<char> = g.replace("\n", "").chars().collect();
            chars.sort();
            chars.dedup();
            return chars;
        })
        .collect();

    return groups.iter().fold(0, |acc, g| acc + g.len());
}
