#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
=======
    echo "Parameter: $param"
>>>>>>> d6e7d6f (git-rebase 1)
    count=$(( $count + 1 ))
done

echo "====="
