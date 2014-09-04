# BVL Crawler

from scrapy.spider import Spider
from scrapy.selector import Selector
#from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
#from scrapy.contrib.spiders import CrawlSpider, Rule
from financialCrawler.items import bvlItem

class BvlSpider(Spider):
    name = "bvlSpider"
    allowed_domains = ["www.bvl.com.pe"]
    start_urls = [
        #'http://www.www.bvl.com.pe/'
        "http://www.bvl.com.pe/mercempresas.html"
    ]

    #rules = (
     #   Rule(SgmlLinkExtractor(allow=r'Items/'), callback='parse', follow=True),
    #)

    def parse(self, response):
        sel = Selector(response)
        link = sel.xpath('//td[@class="divABC"]')

        items = []

        for site in link:
            item = bvlItem()

            item['title'] = site.xpath('a/text()').extract()
            item['company'] = site.xpath('a/text()').extract()
            item['url'] = site.xpath('a/@href').extract()
            items.append(item)
            print item['title']
        #i['domain_id'] = sel.xpath('//input[@id="sid"]/@value').extract()
        #i['name'] = sel.xpath('//div[@id="name"]').extract()
        #i['description'] = sel.xpath('//div[@id="description"]').extract()
        return items
