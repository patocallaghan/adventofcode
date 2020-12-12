use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "nop +0
    // acc +1
    // jmp +4
    // acc +3
    // jmp -3
    // acc -99
    // acc +1
    // jmp -4
    // acc +6";

    let instructions: Vec<(String, i32)> = contents
        .split("\n")
        .map(|i: &str| {
            let commands: Vec<&str> = i.split(" ").collect();
            (
                commands[0].to_string(),
                commands[1].parse().expect("Not a number"),
            )
        })
        .collect();
    // let accum = accum_one(&instructions, 0, 0, &mut commands);
    let accum = change_instructions(&instructions, 0, 0);
    println!("accum: {}", accum)
}

fn accum_one(
    instructions: &Vec<(String, i32)>,
    index: i32,
    mut accum: i32,
    commands: &mut Vec<i32>,
) -> i32 {
    let (instruction, pos) = &instructions[index as usize];
    if commands.contains(&index) {
        return accum;
    }
    commands.push(index);
    match instruction.as_str() {
        "nop" => return accum_one(instructions, index + 1, accum, commands),
        "acc" => {
            accum = accum + pos;
            return accum_one(instructions, index + 1, accum, commands);
        }
        "jmp" => return accum_one(instructions, index + pos, accum, commands),
        _ => accum,
    }
}

fn change_instructions(instructions: &Vec<(String, i32)>, index: i32, accum: i32) -> i32 {
    let mut total = -1;
    for (i, (instruction, pos)) in instructions.iter().enumerate() {
        if instruction != "acc" {
            let mut commands: Vec<i32> = vec![];
            let mut cloned_instructions = instructions.clone();
            match instruction.as_str() {
                "jmp" => {
                    cloned_instructions[i] = (String::from("nop"), *pos);
                }
                "nop" => {
                    cloned_instructions[i] = (String::from("jmp"), *pos);
                }
                _ => {}
            }
            total = accum_two(&cloned_instructions, index, accum, &mut commands);
            if total != -1 {
                break;
            }
        }
    }
    return total;
}

fn accum_two(
    instructions: &Vec<(String, i32)>,
    index: i32,
    mut accum: i32,
    commands: &mut Vec<i32>,
) -> i32 {
    if commands.contains(&index) {
        return -1;
    }
    if index == instructions.len() as i32 {
        return accum;
    }
    let (instruction, pos) = &instructions[index as usize];
    commands.push(index);
    match instruction.as_str() {
        "nop" => return accum_two(instructions, index + 1, accum, commands),
        "acc" => {
            accum = accum + pos;
            return accum_two(instructions, index + 1, accum, commands);
        }
        "jmp" => return accum_two(instructions, index + pos, accum, commands),
        _ => accum,
    }
}
