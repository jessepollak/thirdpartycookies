express = require 'express'
logger = require 'morgan'
partials = require 'express-partials'
useragent = require 'useragent'
url = require 'url'

app = express()

app.use(logger('dev'))
app.use(express.static(__dirname + '/static'))
app.use(partials())
app.engine('.html', require('ejs').__express)
app.set('views', __dirname + '/views')
app.set('view engine', 'html')

app.get '/', (req, res) ->
  res.render 'index', layout: 'base'

app.get '/*', (req, res) ->
  # grab the path and strip the leading slash
  path = url.parse(req.url).path.slice(1)

  browser = useragent.parse(req.headers['user-agent']).family
  browser = browser.toLowerCase() if browser
  if browser not in ['chrome']
    return res.render 'unsupported', layout: 'base'

  res.render "browsers/#{browser}", layout: 'base', domain: path

app.listen(process.env.PORT || 3000)