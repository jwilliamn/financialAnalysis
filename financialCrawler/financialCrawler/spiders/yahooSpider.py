# yahooSpider crawl Fortune 500 companies' listed on Yahoo finance

from scrapy.spider import Spider
from scrapy.selector import Selector
from scrapy.http import Request
from financialCrawler.items import yahooItem

URL_BASE = "http://finance.yahoo.com"
companies = ["EXC","DUK","SO","AES","PCG","AEP","NEE","FE","D","EIX","ED","PPL","ETR",
             "XEL","SRE","PEG","DTE","CNP","NU","AEE","CMS","NI","TEG","GAS","WEC","SCG",
             "POM","ATO","PNW","LNT","HE","OGE","TE","VVC","GXP","WR", "SWX"]

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
            request.meta['item'] = item
            requests.append(request)

        print len(requests)+1000
        return requests

    def parseFinance(self, response):
        sel = Selector(response)
        item = response.meta['item']
        data = sel.xpath('//*[@id="yfncsumtab"]/tr[2]/td/table[2]/tr/td/table')

        index_interrogation = item['url'].find("?")
        data_finance = item['url'][index_interrogation - 2: index_interrogation]

        financial = []

        for d in data:
            if data_finance == "is":
                print "Income Statement!"
                #year2013 = d.xpath('tr[1]/th[1]/text()').extract()
                #year2012 = d.xpath('tr[1]/th[2]/text()').extract()
                #year2011 = d.xpath('tr[1]/th[3]/text()').extract()

                print "Revenue GrossProfit OperatingIncome NetIncome"

                for tab in range(2,5):
                    revenue = d.xpath('tr[2]/td['+str(tab)+']/strong/text()').extract()
                    grossProfit = d.xpath('tr[5]/td['+str(tab)+']/strong/text()').extract()
                    operatingIncome = d.xpath('tr[16]/td['+str(tab)+']/strong/text()').extract()
                    netIncome = d.xpath('tr[35]/td['+str(tab)+']/strong/text()').extract()


                    financial.append(revenue)
                    financial.append(grossProfit)
                    financial.append(operatingIncome)
                    financial.append(netIncome)

            if data_finance == "bs":
                print "Balance Sheet!!"

                print "totalAssets TotalLIabilities totalSHEQUITY netTangibleAssets"

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
                print "totalCFOA totalCFIA totalCFFA ChangeCash"
                for tab in range(2,5):
                    totalCFOA = d.xpath('tr[12]/td['+str(tab)+']/strong/text()').extract()
                    totalCFIA = d.xpath('tr[19]/td['+str(tab)+']/strong/text()').extract()
                    totalCFFA = d.xpath('tr[27]/td['+str(tab)+']/strong/text()').extract()
                    changeCash = d.xpath('tr[30]/td['+str(tab)+']/strong/text()').extract()

                    financial.append(totalCFOA)
                    financial.append(totalCFIA)
                    financial.append(totalCFFA)
                    financial.append(changeCash)


        financial_temp = clean_data(financial)
        item['rawData'] = financial_temp
        return item
