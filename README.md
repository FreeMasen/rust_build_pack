# Rust Build Pack

This is a minimal rust build pack for Heroku. The build pack will look for the existence of a `Cargo.toml` file in your project root, if it finds one will perform the following.

- Install `rustup`
  - This will use `curl https://sh.rustup.rs -sSf >> ru.sh` to get the install script
  - Once this has completed it will run `ru.sh -y`
- Updates the path to include cargo
  - `export PATH="$PATH:~/cargo.bin"`
- It will then extract your application's name from the `Cargo.toml` file 
  - It does this by looping over each line and looking for the first one that begins with "name = "
  - Once found it removes this prefix
- It will run `cargo build --release`
- Once the application is compiled it will move the result into the root directory as `RUSTAPP`
  - `mv $1/target/release/[app name] ./RUSTAPP`
  - The app name is what we captured from the `Cargo.toml` file
  - This is done to avoid any issues with path resolution
    - `cargo run` will allow you to use paths relative to the crate root but executing directly from the `target` directory will fail to resolve the same paths
- Upon release it will attempt to start the application as a web service

## notes
It is important to bind your web server to `0.0.0.0` instead of `127.0.0.1`.

Another important part about getting a rust webserver working on Heroku is to bind it to the correct port. Heroku will set an env variable `$PORT` and it will expect your to bind to that within 60 seconds of running the `release` script.

To get this value you would do the following.

```rust
use std::env::var;
fn main() {
    if let Ok(port) = var("PORT") {
        let addr = format!("0.0.0.0:{}", port).parse().expect("Unable to parse port");
        //Start your server
    }
}
```