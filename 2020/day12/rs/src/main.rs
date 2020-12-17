use regex::Regex;
use std::{collections::HashMap, fs, thread::current};

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");

    //     let contents = "F10
    // N3
    // F7
    // R90
    // F11";

    //     let contents = "F10
    // L180
    // F10";

    // N:3 E:1 S:0 W:2

    let re = Regex::new(r"([A-Z]{1})(\d+)").unwrap();
    let actions: Vec<(&str, i32)> = contents
        .trim()
        .split("\n")
        .map(|action| {
            let cap = re.captures(action).unwrap();
            return (
                cap.get(1).unwrap().as_str(),
                cap.get(2).unwrap().as_str().parse().expect("Not a number"),
            );
        })
        .collect();

    println!("{}", actions_two(&actions));
}

fn actions_one(actions: &Vec<(&str, i32)>) -> i32 {
    let mut distances = HashMap::new();
    distances.insert("N", 0);
    distances.insert("S", 0);
    distances.insert("E", 0);
    distances.insert("W", 0);
    let mut current_state = String::from("E");
    for action in actions.iter() {
        let (action, distance) = action;
        match action.clone() {
            "F" => move_distance(&mut distances, &current_state, distance),
            "L" => current_state = turn(action, &current_state, distance),
            "R" => current_state = turn(action, &current_state, distance),
            _ => move_distance(&mut distances, action, distance),
        }
        println!("======================");
        println!("action: {} {}", action, distance);
        println!("current_state: {}", current_state);
        print!("Ship ");
        for (k, v) in distances.iter() {
            print!("{}: {} ", k, v);
        }
        println!();
    }
    return distances.values().fold(0, |mut acc, distance| {
        acc += distance;
        acc
    });
}

fn turn(action: &str, direction: &str, degrees: &i32) -> String {
    let directions = ["N", "E", "S", "W"];
    let degree_turns = degrees / 90;
    let direction_index = directions.iter().position(|&s| s == direction).unwrap();
    if action == "L" {
        let sum = direction_index as i32 - degree_turns;
        let new_direction_index = if sum < 0 {
            directions.len() as i32 + sum
        } else {
            sum
        };
        String::from(&directions[new_direction_index as usize][..])
    } else {
        let new_direction_index = (direction_index as i32 + degree_turns) % 4;
        String::from(&directions[new_direction_index as usize][..])
    }
}

fn move_distance(distances: &mut HashMap<&str, i32>, direction: &str, distance: &i32) {
    let directions = ["N", "E", "S", "W"];
    let direction_index = directions.iter().position(|&s| s == direction).unwrap();
    let inverse_direction_index = (direction_index + 2) % 4;
    let inverse_direction = directions[inverse_direction_index];
    if *(distances.get(&inverse_direction).unwrap()) > 0 {
        let inverse_direction_distance = *distances.get(&inverse_direction[..]).unwrap();
        if inverse_direction_distance >= *distance {
            distances.insert(
                inverse_direction.clone(),
                inverse_direction_distance - distance,
            );
        } else {
            distances.insert(inverse_direction.clone(), 0);
            distances.insert(
                directions[direction_index].clone(),
                (inverse_direction_distance - distance).abs(),
            );
        }
    } else {
        let new_distance: i32 = distances.get(&direction[..]).unwrap() + distance;
        distances.insert(directions[direction_index].clone(), new_distance);
    }
}

fn actions_two(actions: &Vec<(&str, i32)>) -> i32 {
    let mut distances = HashMap::new();
    distances.insert("N", 0);
    distances.insert("S", 0);
    distances.insert("E", 0);
    distances.insert("W", 0);
    let mut waypoint = HashMap::new();
    waypoint.insert("N", 1);
    waypoint.insert("S", 0);
    waypoint.insert("E", 10);
    waypoint.insert("W", 0);
    let current_state = String::from("E");
    for action in actions.iter() {
        let (action, distance) = action;
        match action.clone() {
            "F" => move_distance_using_waypoint(&mut distances, &waypoint, distance),
            "L" => turn_matrix(action, distance, &mut waypoint),
            "R" => turn_matrix(action, distance, &mut waypoint),
            _ => move_distance(&mut waypoint, action, distance),
        }
        println!("======================");
        println!("action: {} {}", action, distance);
        println!("current_state: {}", current_state);
        print!("Ship ");
        for (k, v) in distances.iter() {
            print!("{}: {} ", k, v);
        }
        println!();
        print!("Waypoint ");
        for (k, v) in waypoint.iter() {
            print!("{}: {} ", k, v);
        }
        println!();
    }
    return distances.values().fold(0, |mut acc, distance| {
        acc += distance;
        acc
    });
}

fn move_distance_using_waypoint(
    distances: &mut HashMap<&str, i32>,
    waypoint: &HashMap<&str, i32>,
    distance: &i32,
) {
    for (key, val) in waypoint.iter() {
        if *val > 0 {
            let new_distance = val * distance;
            move_distance(distances, key, &new_distance);
        }
    }
}

fn turn_matrix(action: &str, degrees: &i32, waypoint: &mut HashMap<&str, i32>) {
    let mut processed_degrees = degrees.clone();
    if action == "L" {
        processed_degrees *= -1;
    }
    let radians = (std::f32::consts::PI / 180.0) * processed_degrees as f32;
    let cos = radians.cos();
    let sin = radians.sin();
    let mut x: f32 = 0.0;
    let mut y: f32 = 0.0;
    for x_direction in ["E", "W"].iter() {
        if waypoint.get(&x_direction[..]).unwrap() > &0 {
            x = *waypoint.get(&x_direction[..]).unwrap() as f32;
            if x_direction.to_string() == "W" {
                x *= -1.0;
            }
        }
    }
    for y_direction in ["N", "S"].iter() {
        if waypoint.get(&y_direction[..]).unwrap() > &0 {
            y = *waypoint.get(&y_direction[..]).unwrap() as f32;
            if y_direction.to_string() == "S" {
                y *= -1.0;
            }
        }
    }
    let nx = (cos * x + sin * y).round();
    let ny = (cos * y - sin * x).round();
    if nx as i32 > 0 {
        waypoint.insert(&"E"[..], nx as i32);
        waypoint.insert(&"W"[..], 0);
    } else {
        waypoint.insert(&"E"[..], 0);
        waypoint.insert(&"W"[..], (nx * -1.0) as i32);
    }
    if ny as i32 > 0 {
        waypoint.insert(&"N"[..], ny as i32);
        waypoint.insert(&"S"[..], 0);
    } else {
        waypoint.insert(&"N"[..], 0);
        waypoint.insert(&"S"[..], (ny * -1.0) as i32);
    }
}
