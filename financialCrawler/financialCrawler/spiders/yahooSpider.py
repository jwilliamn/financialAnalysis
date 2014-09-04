# __author__ = 'williamn'
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

            if data_finance == "bs":
                print "Balance Sheet!!"
                totalAssets2013 = d.xpath('tr[20]/td[2]/strong/text()').extract()
                totalAssets2012 = d.xpath('tr[20]/td[3]/strong/text()').extract()
                totalAssets2011 = d.xpath('tr[20]/td[4]/strong/text()').extract()

                totalLiabilities2013 = d.xpath('tr[35]/td[2]/strong/text()').extract()
                totalLiabilities2012 = d.xpath('tr[35]/td[3]/strong/text()').extract()
                totalLiabilities2011 = d.xpath('tr[35]/td[4]/strong/text()').extract()

                totalSHEquity2013 = d.xpath('tr[47]/td[2]/strong/text()').extract()
                totalSHEquity2012 = d.xpath('tr[47]/td[3]/strong/text()').extract()
                totalSHEquity2011 = d.xpath('tr[47]/td[4]/strong/text()').extract()

                netTangibleAs2013 = d.xpath('tr[49]/td[2]/strong/text()').extract()
                netTangibleAs2012 = d.xpath('tr[49]/td[3]/strong/text()').extract()
                netTangibleAs2011 = d.xpath('tr[49]/td[4]/strong/text()').extract()

                financial.append(totalAssets2013)
                financial.append(totalLiabilities2013)
                financial.append(totalSHEquity2013)
                financial.append(netTangibleAs2013)

            if data_finance=="cf":
                print "Cash Flow xD!"
                totalCFOA2013 = d.xpath('tr[12]/td[2]/strong/text()').extract()
                totalCFOA2012 = d.xpath('tr[12]/td[3]/strong/text()').extract()
                totalCFOA2011 = d.xpath('tr[12]/td[4]/strong/text()').extract()

                totalCFIA2013 = d.xpath('tr[19]/td[2]/strong/text()').extract()
                totalCFIA2012 = d.xpath('tr[19]/td[3]/strong/text()').extract()
                totalCFIA2011 = d.xpath('tr[19]/td[4]/strong/text()').extract()

                totalCFFA2013 = d.xpath('tr[27]/td[2]/strong/text()').extract()
                totalCFFA2012 = d.xpath('tr[27]/td[3]/strong/text()').extract()
                totalCFFA2011 = d.xpath('tr[27]/td[4]/strong/text()').extract()

                changeCash2013 = d.xpath('tr[30]/td[2]/strong/text()').extract()
                changeCash2012 = d.xpath('tr[30]/td[3]/strong/text()').extract()
                changeCash2011 = d.xpath('tr[30]/td[4]/strong/text()').extract()

                financial.append(totalCFOA2013)
                financial.append(totalCFIA2013)
                financial.append(totalCFFA2013)
                financial.append(changeCash2013)
        financial_temp = clean_data(financial)

        return item
