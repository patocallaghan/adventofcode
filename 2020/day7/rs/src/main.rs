use regex::Regex;
use std::collections::HashMap;

fn main() {
    // let contents =
    //     fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    let contents = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";

    let output: HashMap<String, Vec<String>> =
        contents.split("\n").fold(HashMap::new(), |mut acc, l| {
            let re = Regex::new(r"^\d+ ([\w\s]+)+ bag$").unwrap();
            let mut colors: Vec<String> = l
                .to_string()
                .replace(".", "")
                .split(" bags contain ")
                .map(|s| s.to_string())
                .collect();
            let color = colors.remove(0).to_string();
            for c in colors.remove(0).split(", ").collect::<Vec<&str>>() {
                for cap in re.captures_iter(c) {
                    let key = cap[0].to_string();
                    if acc.get_mut(&key).is_none() {
                        acc.insert(key, vec![color.clone()]);
                    } else {
                        acc.get_mut(&key).unwrap().push(color.clone());
                        acc.insert(key, vec![]);
                    }
                }
            }
            acc
        });

    println!("output: {}", "tes");
}
