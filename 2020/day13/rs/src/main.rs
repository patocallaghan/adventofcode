use std::fs;

fn main() {
    // let contents =
    //     fs::read_to_string("../input.txt").expect("Something went wrong reading the file");

    let contents = "939
7,13,x,x,59,x,31,19";
    //     let contents = "939
    // 17,x,13,19";
    //     let contents = "939
    // 67,7,59,61";
    //     let contents = "939
    // 67,x,7,59,61";
    //     let contents = "939
    // 67,7,x,59,61";
    //     let contents = "939
    // 1789,37,47,1889";

    let input: Vec<&str> = contents.split("\n").collect();
    println!("min: {}", bus_two(&input));
}

fn bus_one(input: &Vec<&str>) -> i64 {
    let target: i64 = input[0].trim().parse().expect("Target: Not a number");
    let bus_ids: Vec<(i64, i64)> = input[1]
        .split(",")
        .filter(|&id| id != "x")
        .map(|id| id.parse().expect("Not a number"))
        // Stackoverflow: https://math.stackexchange.com/questions/291468/how-to-find-the-nearest-multiple-of-16-to-my-given-number-n#comment7194776_3056363
        .map(|id: i64| {
            (
                id,
                ((target as f32 / id as f32 + 1.0).floor() * id as f32) as i64,
            )
        })
        .collect();

    let (min_id, min_time) = bus_ids
        .iter()
        .min_by(|(_, x_min), (_, y_min)| x_min.cmp(y_min))
        .unwrap();
    min_id * (min_time - target)
}

fn bus_two(input: &Vec<&str>) -> i64 {
    let bus_ids: Vec<(i64, i64)> = input[1]
        .split(",")
        .enumerate()
        .map(|(index, id)| {
            if id == "x" {
                (index as i64, 0)
            } else {
                (index as i64, id.parse().expect("Not a number"))
            }
        })
        .filter(|(_, id)| *id != 0)
        .collect();
    let (_, first_bus_id) = bus_ids.first().unwrap();
    let mut cycle = *first_bus_id;
    let mut timestamp = cycle;
    for (index, bus_id) in bus_ids.iter().skip(1) {
        while ((timestamp + index) % bus_id) != 0 {
            timestamp += cycle;
        }
        cycle = cycle * bus_id;
        println!("cycle: {}", cycle);
    }
    timestamp
}
