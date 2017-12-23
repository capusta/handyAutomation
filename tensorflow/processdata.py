#! /usr/bin/env python
"""
    Given a list of files, find all video files and classify them by their base directory:
    foo_file1 /foo/bar/baz  (index 1)
    foo_file2 /foor/bar/bay (index 2)
    foo_file3 /foo/bar/baz  (index 1, same dir as foo_file1)
"""

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--dir", help='Dir to search from')

#1.  Parse a list of strings (filenames)
  # Split on non-alphanumeric characters, clean, track the largest
  # sort in decreasing order
  # normalize

args = vars(parser.parse_args());
