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
        
        # writer object
        self.writer = PyPDF2.PdfFileWriter()  
        # open to write PDF file
        self.output_file = open(output_file, 'wb')   

    def add_pages(self, path_to_input_pdf):
        
        # read input file
        self.input_pdf = open(path_to_input_pdf, 'rb')
        # create object of input file
        pdfReader = PyPDF2.PdfFileReader(self.input_pdf)
        # loop over all pages of input file
        for pageNum in range(pdfReader.numPages):   
            pageObj = pdfReader.getPage(pageNum)   # create object for every page
            self.writer.addPage(pageObj)            # add page to writer object
        # close input file
        self.input_pdf.close()
        
    def add_page(self, path_to_input_pdf, page_num):
        
        # read input file
        self.input_pdf = open(path_to_input_pdf, 'rb')
        # create object of input file
        pdfReader = PyPDF2.PdfFileReader(self.input_pdf)
        # create object for specific page
        pageObj = pdfReader.getPage(page_num)
        # add page to writer object
        self.writer.addPage(pageObj)

    
    def export(self):
        self.writer.write(self.output_file)   # write writer object to output file
        self.output_file.close()    # close/save writer object
        self.input_pdf.close()      # close input file



