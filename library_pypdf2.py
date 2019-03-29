'''

Tricks on Python Library : PYPDF2

https://pythonhosted.org/PyPDF2/index.html
https://automatetheboringstuff.com/chapter13/
'''

import PyPDF2


# read in PDF
pdfFile = open(path, 'rb') # as bytes

# extract text from page 
pdfReader = PyPDF2.PdfFileReader(pdfFile) #PyPDF object
page = pdfReader.getPage(0) # page one
page.extractText() #text from page one

# combine PDF pages
pdfWriter = PyPDF2.PdfFileWriter() # create writer object

pdfFile1 = open(path_1, 'rb')   # open 
pdfReader1 = PyPDF2.PdfFileReader(pdfFile1)
pageObj1 = pdfReader1.getPage(0) 
pdfWriter.addPage(pageObj1) # write page to writer object 

pdfFile2 = open(path_2, 'rb')
pdfReader2 = PyPDF2.PdfFileReader(pdfFile2)
pageObj2 = pdfReader2.getPage(0)
pdfWriter.addPage(pageObj2)

pdfOutputFile = open(merged_pdf, 'wb') # open new PDF object # write as bytes
pdfWriter.write(pdfOutputFile) # write to new PDF
pdfOutputFile.close() # save & close

pdfFile1.close() # close PDF files
pdfFile2.close()

# looping over all pages
for pageNum in range(pdfReader.numPages):
    pageObj = pdfReader.getPage(pageNum)
    pdfWriter.addPage(pageObj)

# rotate page
pdfReader = PyPDF2.PdfFileReader(pdfFile)
page = pdfReader.getPage(0)
page.rotateClockwise(90)







