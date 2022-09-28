#pip install pdfminer
#https://github.com/euske/pdfminer/

from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument

fp = open('resume-new-en.pdf', 'rb')
parser = PDFParser(fp)
doc = PDFDocument(parser)

print(doc.info)  # The "Info" metadata
