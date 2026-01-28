+++
draft = false
date = "2015-11-17T18:42:31-07:00"
title = "Tricks to Cleanup Git"
description = "Sometimes in the rush of the work day your git repos can get pretty littered with branches you just don’t need anymore. Here’s a few tricks to clean up your repos."
tags = ["git","shell"]
categories = ["code"]
+++

Sometimes in the rush of the work day your git repos can get pretty littered with branches you just don’t need anymore. Here’s a few tricks to clean up your repos.

## Local Branches
Count how many local branches have already been merged into master:
```
git checkout master
git branch -a --merged | grep -v 'remotes/' | grep -v '\*' | grep -v master | wc -l
```

Remove all local git branches that have been merged into master:
```
git checkout master
git branch -a --merged | grep -v 'remotes/' | grep -v '\*' | grep -v master | xargs git branch -D
```

For a more detailed explanation checkout this [Explain Shell](https://explainshell.com/explain?cmd=git+checkout+master+git+branch+-a+--merged+%7C+grep+-v+%27remotes%2F%27+%7C+grep+-v+%27%5C*%27+%7C+grep+-v+master+%7C+xargs+git+branch+-D).

## Specific Remote Branches
Count merged branches for a specific remote
```
git checkout master
git branch -a --merged | grep 'remotes/origin | wc -l
```

Remove remote git branches from a particular remote
```
git checkout master
git branch -a --merged | grep 'remotes/origin' | xargs -I {} git push origin :{}
```
_Replace `origin` with any other remote name you have._

[Explain Shell](https://explainshell.com/explain?cmd=git+branch+-a+--merged+%7C+grep+%27remotes%2Forigin%27+%7C+xargs+-I+%7B%7D+git+push+origin+%3A%7B%7D)

## All Remote Branches
Count merged branches for all remotes
```
git branch -a --merged | grep 'remotes/' | wc -l
```
Remove all remote git branches that have been merged into master:
```
git checkout master
git branch -a --merged | grep 'remotes/' | xargs -I {} git push origin :{}
```
[Explain Shell](https://explainshell.com/explain?cmd=git+branch+-a+--merged+%7C+grep+%27remotes%2F%27+%7C+xargs+-I+%7B%7D+git+push+origin+%3A%7B%7D)
