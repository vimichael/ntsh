# ntsh

shell scripts for note-taking

## installation

```bash
git clone https://github.com/vimichael/ntsh.git
```

## usage

```bash
cd <ntsh directory>
source ntshenv

# create a note
note . this is a title -t tag1 tag2 tag3
# create a journal
journal
# remove a note and any references to it (replace with links to redacted note)
remove this-is-a-title
# rename note
nr old-title new-title
```

## license

this code is licensed under [MIT](./LICENSE)
