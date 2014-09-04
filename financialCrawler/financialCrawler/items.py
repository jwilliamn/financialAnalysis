# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item, Field

class bvlItem(Item):
    title = Field()
    company = Field()
    url = Field()
    pass

class yahooItem(Item):
    company = Field()
    url = Field()
    revenue = Field()
    grossProfit = Field()
    operatingIncome = Field()
    netIncome = Field()

    #data_required = Field()
    pass