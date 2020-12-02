use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "1-3 a: abcde
    // 1-3 b: cdefg
    // 2-9 c: ccccccccc";

    // let count = password_policy_one(contents);
    let count = password_policy_two(contents);
    println!("Valid passwords: {}", count);
}

fn password_policy_one(contents: String) -> u32 {
    let mut count = 0;
    let input: Vec<&str> = contents.trim().split('\n').collect();
    for password_policy in input {
        let tokens: Vec<&str> = password_policy.split(' ').collect();
        let range: Vec<&str> = tokens[0].split('-').collect();
        let (min, max) = (
            range[0].parse().expect("Not a number"),
            range[1].parse().expect("Not a number"),
        );
        let character: char = tokens[1].chars().nth(0).unwrap();
        let password = tokens[2];
        let character_count = password.matches(character).count();
        if character_count >= min && character_count <= max {
            count = count + 1;
        }
    }
    return count;
}

fn password_policy_two(contents: String) -> u32 {
    let mut count = 0;
    let input: Vec<&str> = contents.trim().split('\n').collect();
    for password_policy in input {
        let tokens: Vec<&str> = password_policy.split(' ').collect();
        let range: Vec<&str> = tokens[0].split('-').collect();
        let (mut first, mut second): (i32, i32) = (
            range[0].parse().expect("Not a number"),
            range[1].parse().expect("Not a number"),
        );
        first = first - 1;
        second = second - 1;
        let character: char = tokens[1].chars().nth(0).unwrap();
        let password = tokens[2];
        let mut policy_count = 0;
        for index in [first as usize, second as usize].iter() {
            if password.chars().nth(*index).unwrap() == character {
                policy_count = policy_count + 1;
            }
        }
        if policy_count == 1 {
            count = count + 1;
        }
    }
    return count;
}
