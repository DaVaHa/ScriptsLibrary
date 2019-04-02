"""

Library : SCRAPY

"""


## EXAMPLE SPIDER ##

import scrapy
from scrapy.crawler import CrawlerProcess

# Create the Spider class
class DC_Chapter_Spider(scrapy.Spider):
  name = "dc_chapter_spider"
  # start_requests method
  def start_requests(self):
    yield scrapy.Request(url = url_short,
                         callback = self.parse_front)
  # First parsing method
  def parse_front(self, response):
    course_blocks = response.css('div.course-block')
    course_links = course_blocks.xpath('./a/@href')
    links_to_follow = course_links.extract()
    for url in links_to_follow:
      yield response.follow(url = url,
                            callback = self.parse_pages)
  # Second parsing method
  def parse_pages(self, response):
    crs_title = response.xpath('//h1[contains(@class,"title")]/text()')
    crs_title_ext = crs_title.extract_first().strip()
    ch_titles = response.css('h4.chapter__title::text')
    ch_titles_ext = [t.strip() for t in ch_titles.extract()]
    dc_dict[ crs_title_ext ] = ch_titles_ext


## SELECTOR OBJECT ##

# Get HTML into Selector object
from scrapy import Selector
import requests
import requests
url = 'https://www.datacamp.com/courses/all'
html = requests.get( url ).content
sel = Selector(text=html) 

sel.xpath("//p")



## XPATH NOTATION ##

# all 'div' elements with id "uid"
xpath = '//div[@id="uid"]'

# Single forward slash '/' looks forward one generation
# Double forward slash '//' looks forward all future generations
# Square brackets '[]' help narrow in on speciic elements

# Asterisks '*' is wildcard
xpath = /html/body/*'

# @ represents "attribute"

# contains( @attri-name, "string-expr" )  # substring of attribute
xpath = '//*[contains(@class,"class-1"]'   # all elements with "class-1" as part of classes 
xpath = '//*[@class="class-1"]'   # only elements with class == "class-1"

# Go to attribute
xpath = '/html/body/div/p[2]/@class'
xpath = '//p[@id="p2"]/a/@href' # href attribute of id element "p2"

# all href's
xpath = '/html/body//a/@href'
xpath = '//a[contains(@class,"course-block")]/@href'

# chaining xpath methods
sel.xpath('/html/body/div[2]')
==
sel.xpath('/html').xpath('./body').xpath('./div[2]')



## CSS LOCATOR NOTATION ##

/ replace by > (except first character)
XPath: /html/body/div
CSS Locator: html > body > div

// replaced by a blank space (except first character)
XPath: //div/span//p
CSS Locator: div > span p

[N] replaced by :nth-of-type(N)
XPath: //div/p[2]
CSS Locator: div > p:nth-of-type(2)

To find an element by class, use a period .
Example: p.class-1 selects all paragraph elements belonging to class-1

To find an element by id, use a pound sign #
Example: div#uid selects the div element with id equal to uid

Select paragraph elements within class class1:
css_locator = 'div#uid > p.class1'

Select all elements whose class attribute belonges to class1:
css_locator = '.class1'


from scrapy import Selector
sel = Selector( text=html)

>>> sel.css("div > p")
out: [<Selector xpath='...' data='<p>Hello World!</p>'>] 

>>> sel.css("div > p").extract()
out: [ '<p>Hello World!</p>' ]


# XPath == CSS
xpath = '//div[@id="uid"]/span//h4'
css_locator = 'div#uid > span h4'

xpath = '/html/body/span[1]//a'
css_locator = 'html > body > span:nth-of-type(1) a'



















