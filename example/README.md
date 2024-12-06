# Combine.sh Example

-   [Create](#create)
-   [Compile](#compile)
-   [Run](#run)

## Create

Write your own scripts, or have peak inside [`./scripts`](./scripts/) to see some examples.

Some features / things to consider:

1. Write all scripts using functions
    - This is because functions combine easily and can be called via CLI when combined
2. Don't combine scripts that use CLI arguments (wrap them within a function instead!)
    - CLI arguments will mess with the other scripts when combined
3. Any function you write can be called within any other function (even if they are in a different file!)
4. Functions can be public/private. A public function starts with a capital letter, and can be executed from the CLI after combining. Private functions act as utility functions and are hidden from the CLI.

## Compile

You can use `combine.sh` to compile the `.sh` (and/or `.bash`) files inside the `scripts` directory:

-   Argument 1: directory containing the scripts to compile
-   Argument 2: output script file

```sh
$ ../src/combine.sh scripts myScript.sh
```

```
$ ls
-> scripts
-> myScript.sh
-> README.md
```

## Run

From here you can run the output script:

```sh
$ ./myScript.sh
```

Without any commands, it displays help text showing available commands and all the compiled script functions. It should look something like this:

> Note only public functions (those starting with a capital letter) are listed and avalable to execute here.

```
Help:

Commands
  * run <fn>  |  run a function
  * cat <fn>  |  prints function code
  * help      |  print script help
  * repl      |  shell to run multiple commands (not for programmatic use)

Functions
  * Print_env
  * List_files
```

Run the `print_env` function (this will directly execute that function and print any output)

```sh
$ ./myScript.sh run print_env
```

```
version: 2.1.17
repo_url: https://github.com/hmerritt/combine-script
```
