# This example is a python script to create a jupyter notebook
# that shows how to create a jupyter notebook
# shwowing an example on how to use itertools combinations

import nbformat as nbf

nb = nbf.v4.new_notebook()
text = """\
# My first automatic Jupyter Notebook
This is an auto-generated notebook."""

code = """\

import nbformat as nbf

nb = nbf.v4.new_notebook()
text = \"""\ Function for Finding Factorial\"""

code = \"""\
from itertools import combinations
print([' '.join(i) for i in combinations("0xfab1", 2) ])
\"""\
    
nb['cells'] = [nbf.v4.new_markdown_cell(text),
               nbf.v4.new_code_cell(code)]
fname = 'FindingFactorial.ipynb'

with open(fname, 'w') as f:
    nbf.write(nb, f)
"""

nb['cells'] = [nbf.v4.new_markdown_cell(text),
               nbf.v4.new_code_cell(code)]
fname = 'AutomaticallyCreateAJupyterNotebook.ipynb'

with open(fname, 'w') as f:
    nbf.write(nb, f)