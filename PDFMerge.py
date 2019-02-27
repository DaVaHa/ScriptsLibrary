'''
This script will create one PDF out of 3 scanned documents.
'''

import os
import PyPDF2
import time
from AwesomeFunctions import ShowRunTime


startTime = time.time()

# path to PDF files
path = r"U:\\"    #source PDF
final_pdf = r'U://ActualisatieGegevens_DanielVanHasselt.pdf'     #target PDF


# all PDF files
files = [f for f in os.listdir(path) if f.endswith('.pdf') and 'SKM_' in f]
files.sort()
print(files)

# for every file: read all pdfs and create one
pdfWriter = PyPDF2.PdfFileWriter()
print("\nReading PDF files...\n")

print(files[0])
pdfFile1 = open(path + files[0], 'rb')
pdfReader1 = PyPDF2.PdfFileReader(pdfFile1)
pageObj1 = pdfReader1.getPage(0)
pdfWriter.addPage(pageObj1)

print(files[1])
pdfFile2 = open(path + files[1], 'rb')
pdfReader2 = PyPDF2.PdfFileReader(pdfFile2)
pageObj2 = pdfReader2.getPage(0)
pdfWriter.addPage(pageObj2)

print(files[2])
pdfFile3 = open(path + files[2], 'rb')
pdfReader3 = PyPDF2.PdfFileReader(pdfFile3)
pageObj3 = pdfReader3.getPage(0)
pdfWriter.addPage(pageObj3)

print(files[3])
pdfFile4 = open(path + files[3], 'rb')
pdfReader4 = PyPDF2.PdfFileReader(pdfFile4)
pageObj4 = pdfReader4.getPage(0)
pdfWriter.addPage(pageObj4)

print(files[4])
pdfFile5 = open(path + files[4], 'rb')
pdfReader5 = PyPDF2.PdfFileReader(pdfFile5)
pageObj5 = pdfReader5.getPage(0)
pdfWriter.addPage(pageObj5)

print(files[5])
pdfFile6 = open(path + files[5], 'rb')
pdfReader6 = PyPDF2.PdfFileReader(pdfFile6)
pageObj6 = pdfReader6.getPage(0)
pdfWriter.addPage(pageObj6)


# export target PDF
print("\nWriting to target PDF...\n")
pdfOutputFile = open(final_pdf, 'wb')
pdfWriter.write(pdfOutputFile)
pdfOutputFile.close()

# close source files
pdfFile1.close()
pdfFile2.close()
pdfFile3.close()
pdfFile4.close()
pdfFile5.close()
pdfFile6.close()

# move source files back to Downloads  # ERROR BECAUSE OF DIFFERENT DISKS :/
##print("Moving source files to Downloads...")
##for f in files:
##    os.rename(path + f, r"C:\\Users\daniel.vanhasselt\Downloads\\" + f)

        
print(ShowRunTime(startTime, time.time()))
