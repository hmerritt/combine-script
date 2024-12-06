# Combine.sh

A simple script that combines bash scripts **and** provides CLI usage for all user functions.

## Usage

See [Example](./example/README.md) for a more detailed example.

### Recommendations

1. Write all scripts using functions
    - This is because functions combine easily and can be called via CLI when combined
2. Don't combine scripts that use CLI arguments (wrap them within a function instead!)
    - CLI arguments will mess with the other scripts when combined
3. Any function you write can be called within any other function (even if they are in a different file!)
4. Functions can be public/private. A public function starts with a capital letter, and can be executed from the CLI after combining. Private functions act as utility functions and are hidden from the CLI.

### Build a Combined Script

Build using the following command:

```bash
$ ./combine.sh <dir-to-scripts>
```

```bash
$ ./combine.sh scripts
```

### Using CLI commands for functions

`Combine.sh` makes it possible to run individual functions within a script directly from the CLI.

```bash
$ ./script.sh run <function>
```

#### Example CLI function usage

Lets say we have a script as follows;

```bash
#!/bin/bash

function example_func {
  echo "Example function"

  mv $1 $2

  cp $2 /example/location/$2

  echo "All arguments are passed through: ${3}, ${4}, ... (infinity)"
}
```

After building it with `Combine.sh`, we can run this (super useful) function via the CLI:

```bash
$ ./script.sh run example_func
```

Passing arguments is just as easy:

```bash
$ ./script.sh run example_func "arg1.sh" "arg2.sh"
```
