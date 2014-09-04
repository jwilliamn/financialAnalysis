# yahooSpider crawl Fortune 500 companies' listed on Yahoo finance

from scrapy.spider import Spider
from scrapy.selector import Selector
from scrapy.http import Request
from financialCrawler.items import yahooItem

URL_BASE = "http://finance.yahoo.com"
companies = ["EXC"]
financial = []
financial_temp = []


def clean_data(finance):
    raw_data = finance
    finance = [int(''.join(''.join(x).strip().strip('(').strip(')').split(','))) for x in raw_data]
    return finance


# __author__ = 'williamn'
# Spider Beginning
class YahooSpider(Spider):
    name = "yahooSpider"
    allowed_domains = ["finance.yahoo.com"]
    start_urls = [
        "http://finance.yahoo.com/q?s=%s" %s for s in companies
    ]

    def parse(self, response):
        sel = Selector(response)
        links = sel.xpath('//*[@id="yfi_investing_nav"]/div[2]/ul[7]/li/a/@href').extract()
        company = sel.xpath('//*[@id="yfi_rt_quote_summary"]/div[1]/div/h2/text()').extract()

        requests = []

        for site in range(len(links)):
            item = yahooItem()

            item['url'] = URL_BASE + links[site]
            item['company'] = str(''.join(company))
            request = Request(url=item['url'], callback=self.parseFinance)

            #if 'data_required' in item:
            #    temp = item['data_required']
            #    temp.extend(financial_temp)
            #    item['data_required'] = temp
            #else:
            #    item['data_required'] = financial_temp

            #item['data_required'] = clean_data(item['data_required'])

            #item['data_required'] = list(set(item['data_required']))
            request.meta['item'] = item
            requests.append(request)

        return requests

    def parseFinance(self, response):
        sel = Selector(response)
        item = response.meta['item']
        data = sel.xpath('//*[@id="yfncsumtab"]/tr[2]/td/table[2]/tr/td/table')

        index_interrogation = item['url'].find("?")
        data_finance = item['url'][index_interrogation - 2: index_interrogation]
        global financial, financial_temp
        #financial = []

        for d in data:
            if data_finance == "is":
                print "Income Statement!"
                #year2013 = d.xpath('tr[1]/th[1]/text()').extract()
                #year2012 = d.xpath('tr[1]/th[2]/text()').extract()
                #year2011 = d.xpath('tr[1]/th[3]/text()').extract()

<<<<<<< HEAD
                for tab in range(2,5):
                    revenue = d.xpath('tr[2]/td['+str(tab)+']/strong/text()').extract()
                    grossProfit = d.xpath('tr[5]/td['+str(tab)+']/strong/text()').extract()
                    operatingIncome = d.xpath('tr[16]/td['+str(tab)+']/strong/text()').extract()
                    netIncome = d.xpath('tr[35]/td['+str(tab)+']/strong/text()').extract()

                    financial.append(revenue)
                    financial.append(grossProfit)
                    financial.append(operatingIncome)
                    financial.append(netIncome)
=======
                revenue2013 = d.xpath('tr[2]/td[2]/strong/text()').extract()
                revenue2012 = d.xpath('tr[2]/td[3]/strong/text()').extract()
                revenue2011 = d.xpath('tr[2]/td[4]/strong/text()').extract()

                grossProfit2013 = d.xpath('tr[5]/td[2]/strong/text()').extract()
                grossProfit2012 = d.xpath('tr[5]/td[3]/strong/text()').extract()
                grossProfit2011 = d.xpath('tr[5]/td[4]/strong/text()').extract()

                operatingIncome2013 = d.xpath('tr[16]/td[2]/strong/text()').extract()
                operatingIncome2012 = d.xpath('tr[16]/td[3]/strong/text()').extract()
                operatingIncome2011 = d.xpath('tr[16]/td[4]/strong/text()').extract()

                netIncome2013 = d.xpath('tr[35]/td[2]/strong/text()').extract()
                netIncome2012 = d.xpath('tr[35]/td[3]/strong/text()').extract()
                netIncome2011 = d.xpath('tr[35]/td[4]/strong/text()').extract()

                item['revenue']=[revenue2013,revenue2012,revenue2011]
                item['grossProfit']=[grossProfit2013,grossProfit2012,grossProfit2011]
		item['operatingIncome']=[operatingIncome2013,operatingIncome2012,operatingIncome2011]
		
                financial.append(revenue2013)
                financial.append(grossProfit2013)
                financial.append(operatingIncome2013)
                financial.append(netIncome2013)
>>>>>>> 1508d57def69748f27ab648b4cbaf8fd5fb0388c

            if data_finance == "bs":
                print "Balance Sheet!!"

                for tab in range(2,5):
                    totalAssets = d.xpath('tr[20]/td['+str(tab)+']/strong/text()').extract()
                    totalLiabilities = d.xpath('tr[35]/td['+str(tab)+']/strong/text()').extract()
                    totalSHEquity= d.xpath('tr[47]/td['+str(tab)+']/strong/text()').extract()
                    netTangibleAs = d.xpath('tr[49]/td['+str(tab)+']/strong/text()').extract()

                    financial.append(totalAssets)
                    financial.append(totalLiabilities)
                    financial.append(totalSHEquity)
                    financial.append(netTangibleAs)

            if data_finance=="cf":
                print "Cash Flow xD!"

                for tab in range(2,5):
                    totalCFOA = d.xpath('tr[12]/td['+str(tab)+']/strong/text()').extract()
                    totalCFIA = d.xpath('tr[19]/td['+str(tab)+']/strong/text()').extract()
                    totalCFFA = d.xpath('tr[27]/td['+str(tab)+']/strong/text()').extract()
                    changeCash = d.xpath('tr[30]/td['+str(tab)+']/strong/text()').extract()

                    financial.append(totalCFOA)
                    financial.append(totalCFIA)
                    financial.append(totalCFFA)
                    financial.append(changeCash)

        item['rawData'] = financial
        #financial_temp = financial

        return item
