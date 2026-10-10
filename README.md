# Antivirus Shell Script Lab

## 1. Overview

This project is a simple antivirus monitoring system written in Bash for the CC373 Operating Systems Lab 2 assignment.

The antivirus daemon monitors a directory, detects changes, scans files for suspicious extensions and keywords, and moves flagged files to a quarantine directory. The restore tool allows users to restore files or permanently delete them.

### Folder Structure

text
antivirus-lab/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
├── dir/
└── malicious_dir/


- antivirusd.sh: Monitors and scans files.
- restore.sh: Allows users to restore or delete quarantined files.
- Makefile: Creates directories and runs the scripts.
- README.md: Project documentation.
- dir/: The directory being monitored.
- malicious_dir/: Stores quarantined files.

## 2. Prerequisites

The project requires Ubuntu, Bash, and GNU Make.

Install Make using the following commands:

bash
sudo apt update
sudo apt install make


Bash and the required Linux commands are normally installed by default on Ubuntu.

## 3. Running the Project

Open the Terminal and navigate to the project directory:

bash
cd ~/antivirus-lab


Prepare the project:

bash
make


Start the antivirus daemon:

bash
make antivirus


The antivirus scans the directory immediately and checks for changes every five seconds by default. Press Ctrl + C to stop it.

Run the restore tool after stopping the antivirus:

bash
make restore


Choose a file by its number and select one of the following options:

1. Restore the file.
2. Permanently delete the file.
3. Leave the file in quarantine.

The antivirus and restore tools must not run at the same time.

## 4. Flagged Extensions and Keywords

The required lists are defined near the beginning of antivirusd.sh.

### Flagged Extensions

- .exe
- .bat
- .vbs
- .scr
- .ps1

### Flagged Keywords

- virus
- trojan
- malware
- worm
- ransomware

Keyword detection is case-insensitive. A file is flagged if its extension matches one of the required extensions or its contents contain one of the required keywords.

## 5. Directory Change Detection

The antivirus saves the directory listing in directory-info.last. After each interval, it creates a new listing called directory-info.new and compares the two files using cmp.

If the listings differ, the antivirus scans the directory and updates the previous snapshot. The process repeats continuously until stopped.

## 6. Quarantine and Restore

When a malicious file is detected, the antivirus prints a message, copies the file into malicious_dir, and removes the original file from dir.

The restore tool displays quarantined files in a numbered list. Users can restore a file to the original directory, permanently delete it, or leave it in
