#!/usr/bin/env python3
#
# Satisfiability modulo wordle: solving that annoying game for you, once and
# for all.
#
# Usage:
# $ python3 -m venv ./venv
# $ source ./venv/bin/activate
# (venv) $ pip install z3-solver
# (venv) $ python solve-wordle.py

import argparse
import logging
import sys
import z3

from typing import Dict, List


solver = z3.Solver()
solver.set(unsat_core=True)
solver.set(':core.minimize', True)
letters = z3.Ints('l1 l2 l3 l4 l5')

clauses: Dict[z3.Bool, z3.ExprRef] = {}

def parse_args(argv: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Wordle cheater",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    ivyp = parser.add_argument_group("Parameters")
    ivyp.add_argument("-d", "--dictfile",
            help="The path to a newline-separated file of English words.",
            default="/usr/share/dict/words")
    ivyp.add_argument("-v", "--verbose",
            help="Dump more info.  More 'v's ==> more info.",
            action='count', default=0)
    args = parser.parse_args(argv)
    init_logging(args)

    return args

def init_logging(args: argparse.Namespace):
    if args.verbose == 0:
        l = logging.WARNING
    if args.verbose == 1:
        l = logging.INFO
    elif args.verbose >= 2:
        #z3.set_option(verbose=5)
        l = logging.DEBUG
    else:
        raise Exception(f"Unxpected verbosity level {args.verbose}")
    logging.basicConfig(format='surdle:%(levelname)s:%(message)s', level=l)

def remember_expr(e: z3.ExprRef):
    """ Inserts the expr into the solver, and remembers it with a fresh
    identifier so unsat_core can tell us something useful."""
    fresh_id = z3.Bool("b" + str(len(clauses)))
    clauses[fresh_id] = e
    solver.assert_and_track(e, fresh_id)

def encode_char(i: int, c: str) -> z3.ExprRef:
    assert(len(c) == 1)
    assert(c.islower())
    return letters[i] == ord(c)

def encode(s: str) -> List[z3.ExprRef]:
    assert(len(s) == 5)
    return [encode_char(i,c) for i,c in enumerate(s)]

def decode(model: List[z3.ExprRef]) -> str:
    ords: List[int] = [model[l].as_long() for l in letters]
    s = "".join([chr(i) for i in ords])

    assert(len(s) == 5)
    assert(s.islower())
    return s

def domain_constraints() -> z3.And:
    """ Adds a conjunction constraining the range of all letters. """
    return z3.And([
        z3.And([l >= ord('a'),
                l <= ord('z')]) for l in letters])

def dictionary_constraints(fn: str) -> z3.Or:
    """Adds a disjunction of five-letter English words."""

    constraints: List[z3.And] = []
    with open(fn) as f:
        logging.info(f"Reading dictionary at {fn}...")
        for line in f:
            line = line.lower().strip()
            if len(line) != 5:
                continue
            constraints.append(z3.And(*encode(line)))
        logging.info(f"Added {len(constraints)} dictionary constraints.")
    return z3.Or(*constraints)

def green_constraint(i: int, c: str) -> z3.ExprRef:
    """ Encodes the fact that letter i is exactly c. """
    logging.debug(f"Remembering that letter {i} is {c}")
    return letters[i] == ord(c)

def yellow_constraint(i: int, c: str) -> z3.ExprRef:
    """" Encodes the fact that c is in the word but not at position i."""
    constraints = []
    candidates = []
    for j in range(len(letters)):
        if j != i:
            candidates.append(j)
            constraints.append(letters[j] == ord(c))
    logging.debug(f"Remembering that one or more of {str(candidates)} is {c}")
    return z3.And(
            letters[i] != ord(c),
            z3.Or(constraints))

def black_constraint(i: int, c: str) -> z3.ExprRef:
    """ Encodes the fact that c is nowhere in the word."""
    logging.debug(f"Remembering that no letter is {c}")
    constraints = [letters[j] != ord(c) for j in range(5)]
    return z3.And(*constraints)

def read_resp() -> str:
    while True:
        feedback = input("> ").strip()
        valid = [c in "🟩🟨⬛gyb" for c in feedback]
        if len(feedback) == 5 and all(valid):
            return feedback

def main(argv: List[str]) -> int:
    args = parse_args(argv[1:])
    solver.add(domain_constraints())
    solver.add(dictionary_constraints(args.dictfile))

    action_table = {
        '⬛': black_constraint,
        '🟨': yellow_constraint,
        '🟩': green_constraint,
        'b': black_constraint,
        'y': yellow_constraint,
        'g': green_constraint
    }

    while True:
        solver.push()
        while solver.check() == z3.sat:
            logging.info("Solving...")

            m = solver.model()
            guess = decode(m)
            print(f"Guessing {guess}")

            # Check for unique solutions
            solver.push()
            solver.add(z3.Not(z3.And(*encode(guess))))
            sat = solver.check()
            solver.pop()
            if sat == z3.unsat:
                print("Unique!")
                break

            feedback = read_resp()

            for i, c in enumerate(feedback):
                remember_expr(action_table[c](i,guess[i]))

        else:
            unsats = [clauses[u] for u in solver.unsat_core()]
            logging.error(f"Contradiction involving some of these clauses!  {[clauses[u] for u in solver.unsat_core()]}...")
            break

        logging.info("Resetting solver state...")
        solver.pop()

    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))