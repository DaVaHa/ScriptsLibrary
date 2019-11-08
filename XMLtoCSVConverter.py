'''

Read XML's

'''


import xml.etree.ElementTree as et 
import os
import pandas as pd

# Input
path = 'L:\\MIT\Projects\\Target2020Online\\'
xmls = [f for f in os.listdir(path) if f.endswith('.xml')]
print("XMLs : {}".format(len(xmls)))

data_of_interest = ['SKU_ID', 'EAN', 'QTY']

    
# Function
def parse_XML(xml_file, df_cols): 
    """Parse the input XML file and store the result in a pandas 
    DataFrame with the given columns. 
    
    The first element of df_cols is supposed to be the identifier 
    variable, which is an attribute of each node element in the 
    XML data; other features will be parsed from the text content 
    of each sub-element. 
    """
    
    xtree = et.parse(xml_file)
    xroot = xtree.getroot()
    rows = []
    
    for node in xroot: 
        res = []
        #res.append(node.attrib.get(df_cols[0]))
        for el in df_cols: 
            if node is not None and node.find(el) is not None:
                res.append(node.find(el).text)
            else: 
                res.append(None)
        rows.append({df_cols[i]: res[i] 
                     for i, _ in enumerate(df_cols)})
    
    out_df = pd.DataFrame(rows, columns=df_cols)
        
    return out_df




# Run for all files
for xml in xmls:
    
    df = parse_XML(path + xml, data_of_interest)
    skus = len(df.dropna())
    stock = pd.to_numeric(df['QTY']).sum()

    # print results
    #print(df.info())
    #print(df.head())
    print("XML : {} - SKU : {} - STOCK : {}".format(xml, skus, stock))

    # export
    export_file = xml.replace('.xml','.csv')
    df.to_csv(path + export_file, index=False)




          
