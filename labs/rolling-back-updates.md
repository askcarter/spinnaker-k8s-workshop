# Rolling Back
Use git to go back a commit, then push the image and bump the tag.
I workshop have user make two commits (the 2nd of which is bad).  When the user pushes them, have them follow this process.

```shell
# Change code
$ git add <change>
$ git commit -m "Working code fix."

# Change code
$ git add <change>
$ git commit -m "Broken code fix."

$ git push google master

$ git tag -a v3.0.0 -m "my version 3.0.0"
$ git push google v3.0.0
```

Roll back change
```shell
$ git <rollback one commit>
$ git commit -m "Rollbacked buggy code."
$ git push google master
$ git tag -a v4.0.0 -m "my version 4.0.0"
$ git push google v4.0.0
```

You can also use the UI if you need an escape hatch.
