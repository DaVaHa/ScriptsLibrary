'''

Scraping JBC website. See what is online available.

'''

from scrapy import Selector
import requests
import re
import numpy as np
import pandas as pd
import time
import datetime

startTime = time.time()


################ FUNCTIONS  #######################

# Get all navigation links
main_url = "https://www.jbc.be"
def GetAllNavigationLinks(url):
    
    html = requests.get(url).content
    sel = Selector(text=html)

    # get all navigation links
    navs = sel.xpath('//a[contains(@class,"nav-link border-bottom border-lg-0 d-flex align-items-center text-decoration-none w-100")]/@href').extract()

    navigation_links = []
    for nav_url in navs:
        
        nav_html = requests.get(nav_url).content
        nav_sel = Selector(text=nav_html)

        new_navs = nav_sel.xpath('//a[contains(@class,"nav-link")]/@href').extract()
        navigation_links += [n for n in new_navs if 'www.jbc.be' in n]
    
    return list(np.unique(navigation_links))


# Test
#navs = GetAllNavigationLinks(main_url)
#for n in navs[:5]:
#    print(n)
#print("Number of navigations : {}".format(len(navs)))


# Get all product pages for navigation link
def GetAllProductLinks(url):
    
    html = requests.get(url).content
    sel = Selector(text=html)
    
    # find URL for menu pages
##    menu_page_url = sel.xpath('//div[contains(@class,"js-pagination-bar d-flex")]/a/@href').extract_first()
##    print(menu_page_url)

    # find max number of items
    max_string = sel.xpath('//div[@class="d-flex p"]').extract_first() # <div class="d-flex p">\n24 van 49 items\n</div>
    max_items = int(re.findall(' [0-9]* ', max_string)[0].strip()) # 49
    #print("Max items : ", max_items)
    
    product_navs = []
    for i in range(max_items // 72 + 1):
        product_nav = url + '/?sz=72&start=' + str(i*72)
        product_navs.append(product_nav)

    #print(product_navs)
    
    # get multiple product pages
    product_links = []
    for product_url in product_navs:
        product_html = requests.get(product_url).content
        product_sel = Selector(text=product_html)
        products = product_sel.xpath('//div[contains(@class,"product-tile-info d-flex flex-row justify-content-center align-items-center")]/a/@href').extract()
        product_links += ['https://www.jbc.be' + p for p in products]

    return list(np.unique(product_links))


# Test
##product_url = 'https://www.jbc.be/nl-be/dames/collecties/ella-italia/'
##product_url = "https://www.jbc.be/nl-be/meisjes/7-14-jaar/kleding/jassen"
##product_url = "https://www.jbc.be/nl-be/meisjes/7-14-jaar/kleding/nieuw/"
##product_links = GetAllProductLinks(product_url)
##for n in product_links:
##    print(n)
##print("Number of product links : {}".format(len(product_links)))


# Extract availability from product page
def ExtractProductAvailability(url):

    global product_info
    
    # Scrapy Selector from url
    html = requests.get(url).content
    selector = Selector(text=html)

    # Itemid & colour
    try:
        itemid = re.findall("[0-9]{6}", url)[0]
    except:
        itemid = None
        
    try:
        colour = re.findall("color=...", url)[0][-3:]
    except:
        colour = None

    if colour == None:
        try:
            colour = selector.xpath('//a[contains(@class,"mr-2 attr-color-link d-flex position-relative selectable selected")]/@data-swatch-color').extract_first() 
        except:
            colour = None
            
    #print("Itemid:", itemid, "- Colour:", colour)

    # sizes & availabiltiy
    block = selector.xpath('//div[contains(@class,"attr-size-select")]')[0]
    sizes = block.css('option::attr(data-attr-value)').getall() # ['S/M', 'L/XL']
    
    availability_data = block.xpath('//option/text()').extract()
    availability = [s.strip() for s in np.unique(availability_data) if 'Kies je maat' not in s] # ['L-XL - laatste stuks', 'S-M - niet op voorraad']

    common_key = [l.replace('-','').replace('/','') for l in sizes] # ['SM', 'LXL']
    
    for s in sizes:
        
        size = s
        
        try:
            available = [l for l in availability if l.replace('-','').replace('/','').startswith(s.replace('-','').replace('/',''))][0]
        except:
            available = 'Available'
    
        #print("Size:", size, "- Available:'", available)

        # add product_info to global list
        info_by_product = {
                "itemid" : itemid,
                "colour" : colour,
                "size" : size,
                "available" : available
            }
    
        product_info.append(info_by_product)

        #print(info_by_product)

# Test
product_info = []
##product_url = 'https://www.jbc.be/nl-be/cardigan-zwart-dames/106498ZWML%2FXL.html?cgid=741713&dwvar_106498_color=ZWM'
##product_url = 'https://www.jbc.be/nl-be/dames/collecties/ella-italia/106497.html?cgid=741713&dwvar_106497_color=RSM'
##product_url = 'https://www.jbc.be/nl-be/heren/kleding/jeansbroeken/slim-fit-jeans/088495.html?cgid=560354&dwvar_088495_color=GSD'
##product_url = 'https://www.jbc.be/nl-be/heren/kleding/jeansbroeken/101701.html?cgid=560354&dwvar_101701_color=ZWM'
##ExtractProductAvailability(product_url)




# Scrape current product page (incl other colours) => Nodig? Alles staat in menu, behalve volledig onbeschikbare matenbogen..
def ScrapeProductPage(url):

    # scrape current page
    #print(">> Scrape current page.")
    #print("Link", url)
    ExtractProductAvailability(url)
        
    # Find all colours of product
    html = requests.get(url).content
    sel = Selector(text=html)
    colour_links = sel.xpath('//a[contains(@class,"mr-2 attr-color-link d-flex")]/@href').extract()
    print(colour_links) # link is niet goed !!

    for link in colour_links:

        # only scrape if not current page
        if len(re.findall("color=[A-Z]{1,3}", link)) > 0:
            #print(">> Different colour.")
            #print("Link :", link)
            ExtractProductAvailability(link)

    
    
# Test
##test_url = "https://www.jbc.be/nl-be/cardigan-zwart-dames/106498ZWML%2FXL.html?cgid=741713&dwvar_106498_color=ZWM"
##ScrapeProductPage(test_url)



#######################################

### Run it all ###
product_info = []

# All navigation tabs
navs = GetAllNavigationLinks(main_url)
#navs = [n for n in navs if 'perso' in n or 'unique' in n or 'lettersweater' in n]   ## !!

# Get all product info
for nav in navs:
        
    # Tussenstand
    print("\nRuntime : {} min {} sec".format( (int(time.time() - startTime) // 60),  int( (time.time() - startTime) % 60)))

    # Start nieuwe navigatie
    print(">> NAVIGATION :", nav)
    
    # Get all product links from nav
    try:
        product_links = GetAllProductLinks(nav)
    except:
        print("ERROR - no products? :", nav)
        continue
    
    for product_link in product_links:
        #print("PRODUCT PAGE :", product_link)
        
        # Scrape product page
        #ScrapeProductPage(product_link)
        ExtractProductAvailability(product_link)

# combine all info
df = pd.DataFrame(product_info)

df = df.dropna()


print(df.info())
print(df.head(50))

export_csv_file = 'ProductAvailability_' + datetime.datetime.now().strftime('%Y%m%d_%Hh%Mm.csv')
df.to_csv(export_csv_file, index=False)



# end
runtime = time.time() - startTime
print("\nRuntime : {} min {} sec".format( int(runtime // 60),  int(runtime % 60)))
print("\nDone.\n")








