http = require 'http'
fs = require 'fs'
trends = require './trends'

html = fs.readFileSync('./flower.html', 'utf-8')

cache = []

render trends (trends, res) =
  console.log ("RENDERING TRENDS", trends)
  res.setHeader('Content-Type', 'text/javascript')
  res.end("window.trends = " + JSON.stringify(trends))

server = http.create server @(req, res)
  if (req.url == '/trends')
    if (cache.length == 0)
      trends.fetch @(trends)
        cache := trends
        render trends (cache, res)
    else
      render trends (cache, res)
      trends.fetch @(trends)
        cache := trends
  else
    res.end(html)

server.listen(process.env.PORT || 1337)
