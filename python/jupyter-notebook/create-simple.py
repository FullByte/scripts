# It is possible to create a jupyter notebook using python

import nbformat as nbf
nb = nbf.v4.new_notebook()
text = """# My first automatic Jupyter Notebook"""
code = """print("hello world")"""
nb['cells'] = [nbf.v4.new_markdown_cell(text), nbf.v4.new_code_cell(code)]
fname = 'helloworld.ipynb'
with open(fname, 'w') as f:
    nbf.write(nb, f)