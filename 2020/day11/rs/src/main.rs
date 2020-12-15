use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "L.LL.LL.LL
    // LLLLLLL.LL
    // L.L.L..L..
    // LLLL.LL.LL
    // L.LL.LL.LL
    // L.LLLLL.LL
    // ..L.L.....
    // LLLLLLLLLL
    // L.LLLLLL.L
    // L.LLLLL.LL";

    let mut seat_map: Vec<Vec<char>> = contents
        .trim()
        .split("\n")
        .map(|row| row.chars().collect())
        .collect();

    // println!("Seats taken: {}", seat_map_one(&mut seat_map))
    println!("Seats taken: {}", seat_map_two(&mut seat_map))
}

fn seat_map_one(seat_map: &mut Vec<Vec<char>>) -> u32 {
    let mut is_same = false;
    let mut iteration = 1;
    while !is_same {
        let seat_map_copy = seat_map.clone();
        for (x, row) in seat_map.clone().iter().enumerate() {
            for (y, seat) in row.iter().enumerate() {
                match seat {
                    '.' => continue,
                    _ => {
                        let mut seats_taken = 0;
                        let row_x = x as i32;
                        let seat_y = y as i32;
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x - 1, seat_y);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x + 1, seat_y);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x - 1, seat_y - 1);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x, seat_y - 1);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x + 1, seat_y - 1);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x - 1, seat_y + 1);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x, seat_y + 1);
                        seats_taken += adjacent_seat_check(&seat_map_copy, row_x + 1, seat_y + 1);
                        match seat {
                            'L' => {
                                if seats_taken == 0 {
                                    seat_map[x][y] = '#';
                                }
                            }
                            '#' => {
                                if seats_taken >= 4 {
                                    seat_map[x][y] = 'L';
                                }
                            }
                            _ => (),
                        }
                    }
                }
            }
        }
        iteration += 1;
        let after = seat_map_state(&seat_map);
        let before = seat_map_state(&seat_map_copy);
        if before == after {
            is_same = true;
        }

        // for (x, row) in seat_map.clone().iter().enumerate() {
        //     for (y, seat) in row.iter().enumerate() {
        //         print!("{}", seat_map[x][y]);
        //     }
        //     println!();
        // }
    }
    seat_map.iter().fold(0, |mut acc, row| {
        for seat in row {
            match seat {
                '#' => acc += 1,
                _ => {}
            }
        }
        acc
    })
}

fn adjacent_seat_check(seat_map: &Vec<Vec<char>>, row: i32, seat: i32) -> i32 {
    if row == -1
        || row == seat_map.len() as i32
        || seat == -1
        || seat == seat_map[row as usize].len() as i32
    {
        return 0;
    }

    if seat_map[row as usize][seat as usize] == '#' {
        return 1;
    }

    return 0;
}

fn seat_map_two(seat_map: &mut Vec<Vec<char>>) -> u32 {
    let mut is_same = false;
    let mut iteration = 1;
    while !is_same {
        let seat_map_copy = seat_map.clone();
        for (x, row) in seat_map.clone().iter().enumerate() {
            for (y, seat) in row.iter().enumerate() {
                match seat {
                    '.' => continue,
                    _ => {
                        let mut seats_taken = 0;
                        let row_x = x as i32;
                        let seat_y = y as i32;
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x - 1,
                            seat_y - 1,
                            String::from("left-up"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x - 1,
                            seat_y,
                            String::from("up"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x - 1,
                            seat_y + 1,
                            String::from("right-up"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x,
                            seat_y - 1,
                            String::from("left"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x,
                            seat_y + 1,
                            String::from("right"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x + 1,
                            seat_y - 1,
                            String::from("left-down"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x + 1,
                            seat_y,
                            String::from("down"),
                        );
                        seats_taken += adjacent_seat_check_with_direction(
                            &seat_map_copy,
                            row_x + 1,
                            seat_y + 1,
                            String::from("right-down"),
                        );
                        match seat {
                            'L' => {
                                if seats_taken == 0 {
                                    seat_map[x][y] = '#';
                                }
                            }
                            '#' => {
                                if seats_taken >= 5 {
                                    seat_map[x][y] = 'L';
                                }
                            }
                            _ => (),
                        }
                    }
                }
            }
        }
        iteration += 1;
        let after = seat_map_state(&seat_map);
        let before = seat_map_state(&seat_map_copy);
        if before == after {
            is_same = true;
        }

        // for (x, row) in seat_map.clone().iter().enumerate() {
        //     for (y, seat) in row.iter().enumerate() {
        //         print!("{}", seat_map[x][y]);
        //     }
        //     println!();
        // }
    }
    seat_map.iter().fold(0, |mut acc, row| {
        for seat in row {
            match seat {
                '#' => acc += 1,
                _ => {}
            }
        }
        acc
    })
}

fn adjacent_seat_check_with_direction(
    seat_map: &Vec<Vec<char>>,
    row: i32,
    seat: i32,
    direction: String,
) -> i32 {
    let mut seat_state = 0;
    match &direction[..] {
        "up" => {
            let y = seat;
            for x in (0..=row).rev() {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
            }
            return 0;
        }
        "down" => {
            let y = seat;
            for x in row..seat_map.len() as i32 {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
            }
            return 0;
        }
        "left" => {
            let x = row;
            for y in (0..=seat).rev() {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
            }
            return 0;
        }
        "right" => {
            let x = row;
            for y in seat..seat_map[0].len() as i32 {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
            }
            return 0;
        }
        "left-down" => {
            let mut y = seat;
            for x in row..seat_map.len() as i32 {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
                y -= 1;
            }
            return 0;
        }
        "right-down" => {
            let mut y = seat;
            for x in row..seat_map.len() as i32 {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
                y += 1;
            }
            return 0;
        }
        "left-up" => {
            let mut y = seat;
            for x in (0..=row).rev() {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
                y -= 1;
            }
            return 0;
        }
        "right-up" => {
            let mut y = seat;
            for x in (0..=row).rev() {
                seat_state = check_seat(seat_map, x, y);
                if seat_state != -1 {
                    return seat_state;
                }
                y += 1;
            }
            return 0;
        }
        _ => {}
    }
    seat_state
}

fn check_seat(seat_map: &Vec<Vec<char>>, row: i32, seat: i32) -> i32 {
    if row == -1
        || row >= seat_map.len() as i32
        || seat == -1
        || seat >= seat_map[row as usize].len() as i32
    {
        return 0;
    }

    if seat_map[row as usize][seat as usize] == '#' {
        return 1;
    }

    if seat_map[row as usize][seat as usize] == 'L' {
        return 0;
    }

    return -1;
}

fn seat_map_state(seat_map: &Vec<Vec<char>>) -> String {
    String::from(seat_map.iter().fold(String::new(), |mut acc, row| {
        for seat in row {
            acc.push(*seat);
        }
        acc.push('\n');
        acc
    }))
}
