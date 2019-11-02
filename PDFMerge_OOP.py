import sys
sys.path.insert(0, 'U:\MIT\Python\ScriptsLibrary//')

from PDF_OOP import PDF

combo = PDF(r'C:\Users\daniel.vanhasselt.JBC\Downloads\DanielVanHasselt_AangifteAJ19.pdf')


path_file_1 = r'C:\Users\daniel.vanhasselt.JBC\Downloads\SKM_C45819102410270.pdf'
path_file_2 = r'C:\Users\daniel.vanhasselt.JBC\Downloads\SKM_C45819102410280.pdf'
path_file_3 = r'C:\Users\daniel.vanhasselt.JBC\Downloads\SKM_C45819102410281.pdf'
path_file_4 = r'C:\Users\daniel.vanhasselt.JBC\Downloads\SKM_C45819102410271.pdf'


combo.add_page(path_file_1, 0)
combo.add_page(path_file_2, 0)
combo.add_page(path_file_3, 0)
combo.add_page(path_file_4, 0)

combo.export()
