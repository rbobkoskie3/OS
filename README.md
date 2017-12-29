# OS

This repository contains Miscellaneous Code: Java, C, Shell (Bash) and Python scripts to automate common tasks and commands.
====================================================

# GIT COMMANDS
// Create repository on GitHub website.
// Clone repository from windows command line:
   git clone https://github.com/<USER>/<REPOSITORY>

C:\PYCODE>cd "GTECH GITHUB"
C:\PYCODE\GTECH GITHUB>git clone https://github.com/rbobkoskie3/GEORGIA-TECH.git
Cloning into 'GEORGIA-TECH'...
remote: Counting objects: 160, done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 160 (delta 3), reused 0 (delta 0), pack-reused 138
Receiving objects: 100% (160/160), 139.43 KiB | 0 bytes/s, done.
Resolving deltas: 100% (17/17), done.

// Change the current working directory to your local repository, and stage the file(s) for commit to your local repository, e.g., copy files into the local repository:
   git add .

C:\PYCODE\GTECH GITHUB>cd GEORGIA-TECH
C:\PYCODE\GTECH GITHUB\GEORGIA-TECH>git add .

// Commit the file that you've staged in your local repository:
   git commit -ma
   git commit -m <FILE>

C:\PYCODE\GTECH GITHUB\GEORGIA-TECH>git commit -ma

// Push the changes in your local repository to GitHub:
   git push origin

C:\PYCODE\GTECH GITHUB\GEORGIA-TECH>git push origin
Logon failed, use ctrl+c to cancel basic credential prompt.
Username for 'https://github.com/': rbobkoskie3
Password for 'https://rbobkoskie3@github.com/':
Counting objects: 1311, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (1296/1296), done.
Writing objects: 100% (1311/1311), 3.35 MiB | 452.00 KiB/s, done.
Total 1311 (delta 16), reused 0 (delta 0)
remote: Resolving deltas: 100% (16/16), completed with 1 local object.
To https://github.com/rbobkoskie3/GEORGIA-TECH.git
   6f7ea7c..fc1d6b8  master -> master

// Remove untracked files and directories from the working tree when switching branches or checking out different commits:
   git reset --hard
   git clean -f -d

// Cleanup unnecessary files and optimize the local repository:
   git gc

// Deletes all stale tracking branches which have already been removed at origin but are still locally available in remotes/origin:
   git remote prune origin

// Delete untracked files from your tree:
   git clean


// Delete the last commit:
   git reset HEAD~

C:\PYCODE\GITHUB\GTECH_CS6475-CP>git push origin
Counting objects: 14, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (11/11), done.
Writing objects: 100% (14/14), 240.29 MiB | 1.46 MiB/s, done.
Total 14 (delta 6), reused 11 (delta 3)
remote: Resolving deltas: 100% (6/6), completed with 4 local objects.
remote: error: GH001: Large files detected. You may want to try Git Large File S
torage - https://git-lfs.github.com.
remote: error: Trace: 8f284b1a90caf5b70a3d1702fc55ed76
remote: error: See http://git.io/iEPt8g for more information.
remote: error: File CS6475-CP_LECTURE-NOTES.pdf is 228.72 MB; this exceeds GitHu
b's file size limit of 100.00 MB
To https://github.com/rbobkoskie3/GTECH_CS6475-CP.git
! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/rbobkoskie3/GTECH_CS6475-
CP.git'
C:\PYCODE\GITHUB\GTECH_CS6475-CP>git reset HEAD~
Unstaged changes after reset:
D       CS6475-CP_LECTURE-NOTES.pdf
