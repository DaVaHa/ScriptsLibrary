import sys
sys.path.insert(0, 'U:\MIT\Python\ScriptsLibrary//')

from PDF_OOP import PDF

claud = PDF(r'C:\Users\daniel.vanhasselt.JBC\Downloads\ClaudMaart.pdf')


path = r'C:\Users\daniel.vanhasselt.JBC\Downloads\Claud11-2903.pdf'


claud.add_page(path, 1)
claud.add_page(path, 3)
claud.add_page(path, 5)
claud.add_page(path, 7)
claud.add_page(path, 9)

claud.export()
