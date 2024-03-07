use core::panic;
use std::{env, fs, io};

fn read_stdin() {
    let mut msg_buf = String::new();
    let stdin = io::stdin();

    loop {
        let read_bytes = stdin.read_line(&mut msg_buf);
        match read_bytes {
            Ok(0) => break,
            Ok(_) => {
                print!("{}", msg_buf);
                msg_buf.clear();
            }
            _ => panic!("Reading form stdin failed!"),
        }
    }
}

fn zcat(arguments: &Vec<String>) {
    if arguments.len() == 1 {
        read_stdin();
        return;
    }
    let mut i: i8 = 0;
    for arg in arguments {
        if i == 0 {
            print!("{}\n", arg);
            i += 1;
            continue;
        }

        if arg == "-" {
            read_stdin();
        } else {
            let contents = fs::read_to_string(arg);

            match contents {
                Ok(t) => {
                    print!("{}", t);
                }
                _ => println!("rcat: {}: no such file!", arg),
            }
        }
    }
}

fn main() {
    let args_vec: Vec<String> = env::args().collect();
    zcat(&args_vec);
}
