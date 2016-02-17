import csv, codecs, cStringIO, urllib2
from ucsv import UnicodeWriter as unicsv
from ucsv import UTF8Recoder as rec_uni
from bs4 import BeautifulSoup, NavigableString


url = "https://www.google.com/edu/resources/programs/exploring-computational-thinking/index.html#!ct-materials"
f = urllib2.urlopen(url)
soup = BeautifulSoup(f, "html.parser")

items = soup.select("ul#list li")

lesson_list = []

for item in items:
    item_list = []
    details = item.select("div.ct-lp-details p")
    for detail in details:
        detail_text_idx = detail.contents[0].find("</span>")
        detail_text = detail.contents[0][detail_text_idx:]
        item_list.append(detail_text)
    
