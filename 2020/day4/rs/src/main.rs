use regex::Regex;
use std::collections::HashMap;
use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    // byr:1937 iyr:2017 cid:147 hgt:183cm

    // iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    // hcl:#cfa07d byr:1929

    // hcl:#ae17e1 iyr:2013
    // eyr:2024
    // ecl:brn pid:760753108 byr:1931
    // hgt:179cm

    // hcl:#cfa07d eyr:2025 pid:166559648
    // iyr:2011 ecl:brn hgt:59in";

    let passports: Vec<HashMap<String, String>> = contents
        .split("\n\n")
        .map(|passport| {
            let mut passports_hash = HashMap::new();
            for (_, single_trait) in passport.replace("\n", " ").split(' ').enumerate() {
                let traits: Vec<&str> = single_trait.split(':').collect();
                passports_hash.insert(traits[0].to_string(), traits[1].to_string());
            }
            return passports_hash;
        })
        .collect();

    println!("Valid count: {}", valid_passports_two(passports));
}

fn valid_passports_one(passports: Vec<HashMap<String, String>>) -> u32 {
    let mut count = 0;
    for passport in passports {
        let traits: Vec<_> = passport.keys().collect();
        let size = traits.len();
        if size == 8 || (size == 7 && traits.iter().find(|&&t| t == "cid") == None) {
            count = count + 1
        }
    }
    count
}

fn valid_passports_two(passports: Vec<HashMap<String, String>>) -> u32 {
    let mut count = 0;
    for passport in passports {
        let size = passport.len();
        if size == 8 || (size == 7 && passport.keys().clone().find(|&t| t == "cid") == None) {
            if passport.iter().all(|(key, value)| match key.as_ref() {
                "byr" => validate_byr(value.to_string()),
                "iyr" => validate_iyr(value.to_string()),
                "eyr" => validate_eyr(value.to_string()),
                "hgt" => validate_hgt(value.to_string()),
                "hcl" => validate_hcl(value.to_string()),
                "ecl" => validate_ecl(value.to_string()),
                "pid" => validate_pid(value.to_string()),
                "cid" => true,
                _ => false,
            }) {
                count = count + 1
            }
        }
    }
    count
}

fn validate_byr(year: String) -> bool {
    if year.len() != 4 {
        return false;
    }
    let year_int: u32 = year.parse().expect("Not integer");
    if year_int >= 1920 && year_int <= 2020 {
        return true;
    }
    return false;
}

fn validate_iyr(year: String) -> bool {
    if year.len() != 4 {
        return false;
    }
    let year_int: u32 = year.parse().expect("Not integer");
    if year_int >= 2010 && year_int <= 2020 {
        return true;
    }
    return false;
}

fn validate_eyr(year: String) -> bool {
    if year.len() != 4 {
        return false;
    }
    let year_int: u32 = year.parse().expect("Not integer");
    if year_int >= 2020 && year_int <= 2030 {
        return true;
    }
    return false;
}

fn validate_hgt(height: String) -> bool {
    let (min, max) = if height.contains("in") {
        (59, 76)
    } else {
        (150, 193)
    };

    let number: i32 = height
        .replace("in", "")
        .replace("cm", "")
        .parse()
        .expect("Not a number");
    if number >= min || number <= max {
        return true;
    }
    return false;
}

fn validate_hcl(hair_color: String) -> bool {
    let re = Regex::new(r"^#\w{6}$").unwrap();
    return re.is_match(&hair_color);
}

fn validate_ecl(eye_color: String) -> bool {
    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        .iter()
        .any(|c| c == &eye_color)
}

fn validate_pid(passport_id: String) -> bool {
    let re = Regex::new(r"^\d{9}$").unwrap();
    return re.is_match(&passport_id);
}
