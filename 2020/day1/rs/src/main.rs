use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents =
    //         String::from("1721
    // 979
    // 366
    // 299
    // 675
    // 1456");

    let input: Vec<i32> = contents
        .trim()
        .split('\n')
        .map(|s| s.parse::<i32>())
        .filter_map(Result::ok)
        .collect();

    // assert_eq!(find_pair(input), 514579);
    println!("result: {}", find_pair(&input));
    println!("result: {}", find_triplet(&input));
}

fn find_pair(numbers: &Vec<i32>) -> i32 {
    let target = 2020;
    for x in 0..numbers.len() - 1 {
        for y in x..numbers.len() {
            if numbers[x] + numbers[y] == target {
                return numbers[x] * numbers[y];
            }
        }
    }
    return -1;
}

fn find_triplet(numbers: &Vec<i32>) -> i32 {
    let target = 2020;
    for x in 0..numbers.len() - 2 {
        for y in x..numbers.len() - 1 {
            for z in y..numbers.len() {
                if numbers[x] + numbers[y] + numbers[z] == target {
                    return numbers[x] * numbers[y] * numbers[z];
                }
            }
        }
    }
    return -1;
}
