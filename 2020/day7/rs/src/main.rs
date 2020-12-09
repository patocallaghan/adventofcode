use regex::Regex;
use std::{collections::HashMap, fs};

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    // let contents = "light red bags contain 1 bright white bag, 2 muted yellow bags.
    // dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    // bright white bags contain 1 shiny gold bag.
    // muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    // shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    // dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    // vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    // faded blue bags contain no other bags.
    // dotted black bags contain no other bags.";
    bags_two(&contents);
}

fn bags_one(contents: &str) {
    let output: HashMap<String, Vec<String>> =
        contents.split("\n").fold(HashMap::new(), |mut acc, l| {
            let re = Regex::new(r"^(\d+ ([\w\s]+)+ bag(s)?|no other bags)$").unwrap();
            let mut colors: Vec<String> = l
                .to_string()
                .replace(".", "")
                .split(" bags contain ")
                .map(|s| s.to_string())
                .collect();
            let color = colors.remove(0).to_string();
            for c in colors.remove(0).split(", ").collect::<Vec<&str>>() {
                if !c.contains("no other bags") {
                    let cap = re.captures(c).unwrap();
                    let key = cap.get(2).unwrap().as_str();
                    if acc.get_mut(key).is_none() {
                        acc.insert(key.to_string(), vec![color.clone()]);
                    } else {
                        acc.get_mut(key).unwrap().push(color.clone());
                    }
                }
            }
            acc
        });

    let mut number_of_bags: Vec<String> = vec![];
    get_bags(&output, &"shiny gold"[..], &mut number_of_bags);

    number_of_bags.sort();
    number_of_bags.dedup();
    println!("output: {}", number_of_bags.len());
}

fn get_bags(bags: &HashMap<String, Vec<String>>, bag_color: &str, results: &mut Vec<String>) {
    if bags.contains_key(bag_color) {
        let colors = bags.get(bag_color).unwrap();
        for color in colors {
            results.push(color.clone());
            get_bags(bags, color, results);
        }
    }
}

fn bags_two(contents: &str) {
    let output: HashMap<String, HashMap<String, u32>> =
        contents.split("\n").fold(HashMap::new(), |mut acc, l| {
            let re = Regex::new(r"^((\d+) ([\w\s]+)+ bag(s)?|no other bags)$").unwrap();
            let mut colors: Vec<String> = l
                .to_string()
                .replace(".", "")
                .split(" bags contain ")
                .map(|s| s.to_string())
                .collect();
            let key = colors.remove(0).trim().to_string();
            for c in colors.remove(0).split(", ").collect::<Vec<&str>>() {
                if !c.contains("no other bags") {
                    let cap = re.captures(c).unwrap();
                    let color = cap.get(3).unwrap().as_str().trim();
                    let count = cap.get(2).unwrap().as_str();
                    if acc.get_mut(&key).is_none() {
                        let mut map = HashMap::new();
                        map.insert(color.to_string(), count.parse().expect("Not a number"));
                        acc.insert(key.to_string(), map);
                    } else {
                        let map = acc.get_mut(&key).unwrap();
                        map.insert(color.to_string(), count.parse().expect("Not a number"));
                    }
                }
            }
            acc
        });

    let count = count_bags(&output, &"shiny gold"[..]);

    println!("output: {}", count);
}

fn count_bags(bags: &HashMap<String, HashMap<String, u32>>, bag_color: &str) -> u32 {
    let mut total = 1;
    if bags.contains_key(bag_color) {
        let colors = bags.get(bag_color).unwrap();
        for (key, val) in colors.iter() {
            total = total + (val * count_bags(bags, key))
        }
    }
    total
}
