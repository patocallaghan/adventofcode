use std::fs;

fn main() {
    let contents =
        fs::read_to_string("../input.txt").expect("Something went wrong reading the file");
    //     let contents = "BFFFBBFRRR
    // FFFBBBFRRR
    // BBFFBBFRLL";

    // BFFFBBFRRR: row 70, column 7, seat ID 567.
    // FFFBBBFRRR: row 14, column 7, seat ID 119.
    // BBFFBBFRLL: row 102, column 4, seat ID 820

    let boarding_passes: Vec<&str> = contents.split('\n').collect();

    // println!("Seat number: {}", find_max_seat_id(boarding_passes));
    println!("Seat number: {}", find_your_seat(boarding_passes));
}

fn find_max_seat_id(boarding_passes: Vec<&str>) -> i32 {
    let ids: Vec<i32> = boarding_passes
        .into_iter()
        .map(|boarding_pass: &str| seat_id(boarding_pass))
        .collect();
    match ids.iter().max() {
        Some(x) => *x,
        _ => -1,
    }
}

fn find_your_seat(boarding_passes: Vec<&str>) -> i32 {
    let mut ids: Vec<i32> = boarding_passes
        .into_iter()
        .map(|boarding_pass: &str| seat_id(boarding_pass))
        .collect();
    ids.sort();

    let mut your_seat = -1;
    for (index, value) in ids.iter().enumerate() {
        if value + 2 == ids[index + 1] {
            your_seat = value + 1;
            break;
        }
    }
    your_seat
}

fn seat_id(boarding_pass: &str) -> i32 {
    let (row_coordinates, seat_coordinates) = boarding_pass.split_at(7);

    let row_arr = [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
        71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93,
        94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112,
        113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
    ];
    let row = get_value(row_coordinates, &row_arr, "F");
    let column_arr = [0, 1, 2, 3, 4, 5, 6, 7];
    let column = get_value(seat_coordinates, &column_arr, "L");
    return row * 8 + column;
}

fn get_value(boarding_pass: &str, mut seat_array: &[i32], left_symbol: &str) -> i32 {
    if boarding_pass == "" {
        return seat_array[0];
    }
    let (first, remainder) = boarding_pass.split_at(1);
    let (left, right) = seat_array.split_at(seat_array.len() / 2);
    if first == left_symbol {
        seat_array = left;
    } else {
        seat_array = right;
    }
    get_value(remainder, seat_array, left_symbol)
}
