http = require 'http'
fs = require 'fs'
trends = require './trends'
cache = require('memory-cache')

html = fs.readFileSync('./flower.html', 'utf-8')

render trends (trends, res) =
  // console.log ("RENDERING TRENDS", trends)
  res.setHeader('Content-Type', 'text/javascript')
  res.end("window.trends = " + JSON.stringify(trends))

server = http.create server @(req, res)
  if (req.url == '/trends')
    cachedTrends = cache.get('trends')
    if (cachedTrends)
      console.log "RENDERING CACHED TRENDS"
      render trends (cachedTrends, res)
    else
      trends.fetch @(trends)
        cache.put('trends', trends, 60000)
        render trends (trends, res)
  else
    res.end(html)

server.listen(process.env.PORT || 1337)
