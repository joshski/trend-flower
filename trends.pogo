Browser = require("zombie")

exports.fetch (callback) =

  userAgent = [
    'Mozilla/5.0 (Macintosh Intel Mac OS X 10_7_3)' +
    'AppleWebKit/535.20 (KHTML, like Gecko)'
    'Chrome/19.0.1036.7 Safari/535.20'
  ].join ' '

  browser = @new Browser(userAgent: userAgent, debug: false, waitFor: 2500)

  extractTrend (trendElement) =
    // console.log(trendElement.innerHTML)
    titleElement = trendElement.querySelector('.hottrends-single-trend-title')
    imgElement = trendElement.querySelector('img')

    {
      title = titleElement.innerHTML
      image = imgElement.src
    }

  extractTrends () =
    trendElements = browser.queryAll('.hottrends-single-trend-container')
    if (trendElements.legnth == 0)
      getTrends()
    else
      trends = trendElements.map(extractTrend)
      trends.reverse()
      if (trendElements.length > 10)
        browser.close()
        console.log("GOT TRENDS!")
        callback(trends)

  url = "http://www.google.co.uk/trends/hottrends#pn=p9"

  getTrends() =
      browser.visit(url, extractTrends).fail
        setTimeout(getTrends, 100)

  getTrends()
