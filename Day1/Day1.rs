use std::fs::File;
use std::io::{self, BufRead};

fn main() {
    let f = File::open("input.txt").unwrap();
    let lines = io::BufReader::new(f).lines();

    let mut rations : Vec<i32> = Vec::new();
    let mut counter : i32 = 0;
    for lineres in lines {
        let line = lineres.unwrap();
        if line.is_empty() {
            rations.push(counter);
            counter = 0;
        } else {
            counter += line.parse::<i32>().unwrap();
        }
    }

    // Don't forget the last elf
    if counter != 0 {
        rations.push(counter);
    }

    println!("Elf with most calories has {}", rations.iter().max().unwrap());

    rations.sort();
    rations.reverse();
    println!("Three richest elves have a total of {} calories", rations[0..3].iter().sum::<i32>());

    return;
}