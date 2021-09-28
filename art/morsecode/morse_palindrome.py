#!/usr/bin/env python

#stolen from here: https://gist.github.com/vesche/ada491d63d77d8afa55a599c787df957

import requests

MORSE_MAP = {
    'A': '.-',   'B': '-...', 'C': '-.-.',
    'D': '-..',  'E': '.',    'F': '..-.',
    'G': '--.',  'H': '....', 'I': '..',
    'J': '.---', 'K': '-.-',  'L': '.-..',
    'M': '--',   'N': '-.',   'O': '---',
    'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...',  'T': '-',    'U': '..-',
    'V': '...-', 'W': '.--',  'X': '-..-',
    'Y': '-.--', 'Z': '--..'
}

url = 'https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt'
words = requests.get(url).text.splitlines()

for word in words:
    morse_conv = ' '.join([MORSE_MAP[c] for c in word.upper()])

    if morse_conv == morse_conv[::-1] and len(word) > 4:
        print(f'{word:12} {morse_conv}')