# Scrapy settings for financialCrawler project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'financialCrawler'

SPIDER_MODULES = ['financialCrawler.spiders']
NEWSPIDER_MODULE = 'financialCrawler.spiders'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'financialCrawler (+http://www.yourdomain.com)'
