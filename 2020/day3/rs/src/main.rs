use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "..##.......
    // #...#...#..
    // .#....#..#.
    // ..#.#...#.#
    // .#...##..#.
    // ..#.##.....
    // .#.#.#....#
    // .#........#
    // #.##...#...
    // #...##....#
    // .#..#...#.#";

    let slopes: Vec<Vec<char>> = contents
        .split('\n')
        .map(|slope| slope.chars().collect())
        .collect();

    // let (right, down) = (3, 1);
    // let count = count_trees_one(&slopes, right, down);

    let count = count_trees_two(&slopes);

    println!("Tree count: {}", count);
}

fn count_trees_one(slopes: &Vec<Vec<char>>, right: i32, down: i32) -> u32 {
    let mut count = 0;
    let mut start_right = 0;
    let mut start_down = 0;
    const TREE: char = '#';
    let mut done = false;
    let width: i32 = slopes[0].len() as i32;
    while !done {
        start_right = (start_right + right) % width;
        start_down = start_down + down;
        if start_down as usize >= slopes.len() {
            done = true;
        } else {
            let square = slopes[start_down as usize][start_right as usize];
            // println!("square: {} {} {}", square, start_down, start_right);
            if square == TREE {
                count = count + 1;
            }
        }
    }
    println!("count: {}", count);
    return count;
}

fn count_trees_two(slopes: &Vec<Vec<char>>) -> u64 {
    let mut total: u64 = 1;
    for (right, down) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)].iter() {
        let trees = count_trees_one(slopes, *right, *down);
        println!("trees: {}", trees);
        total = total * trees as u64;
    }
    return total;
}
