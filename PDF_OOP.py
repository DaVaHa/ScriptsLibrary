'''

PDF Object Oriented Programming


'''

import os
import PyPDF2



# define class PDF


class PDF:

    """
    Create efficient PDF Object to avoid copy-pasting
    the same code over and over again.
    """

    def __init__(self, output_file):
        self.writer = PyPDF2.PdfFileWriter()   # writer object
        self.output_file = open(output_file, 'wb')   # open to write PDF file

    def add_pages(self, path_to_input_pdf): 
        self.input_pdf = open(path_to_input_pdf, 'rb')  # read input file
        pdfReader = PyPDF2.PdfFileReader(self.input_pdf)  # create object of input file
        for pageNum in range(pdfReader.numPages):   # loop over all pages of input file
            pageObj = pdfReader.getPage(pageNum)   # create object for every page
            self.writer.addPage(pageObj)            # add page to writer object
        
    def export(self):
        self.writer.write(self.output_file)   # write writer object to output file
        self.output_file.close()    # close/save writer object
        self.input_pdf.close()   # close input file


    

# Test
path = '/home/daniel/Downloads//'
file = [path + f for f in os.listdir(path) if 'pdf' in f]
file.sort()

file1 = file[3]
file2 = file[4]

dest = path + 'TEST.pdf'
