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

    rawData = Field()

    revenue = Field()
    grossProfit = Field()
    operatingIncome = Field()
    
    netIncome = Field()

    totalAssets = Field()
    totalLiabilities = Field()
    totalSHEquity = Field()
    netTangibleAs = Field()



    #data_required = Field()
<<<<<<< HEAD

    pass
=======
    pass
>>>>>>> 1508d57def69748f27ab648b4cbaf8fd5fb0388c
