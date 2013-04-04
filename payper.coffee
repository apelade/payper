###
Node Examples for the Paypal REST API with SuperAgent AJAX
See https://github.com/apelade/payper/README.md for details
###

superagent = require 'superagent'

printResults = (err, res) ->
  console.log err if err?
  console.log res.body if res?.body?
  console.log  ' '

PAYMENT = 'https://api.sandbox.paypal.com/v1/payments/payment/'

## Three wrapper functions for each main ajax type we need. No beforeSend func!

ajaxGet = (extraPath, token, callback) ->
  superagent.agent()
  .get(PAYMENT + extraPath)
  .set('Content-Type', 'application/json')
  .set('Authorization','Bearer ' + token)
  .end(callback)

ajaxPost = (path, data, token, callback) ->
  superagent.agent()
  .post(PAYMENT + path)
  .type('application/x-www-form-urlencoded')
  .send(data)
  .set('Content-Type', 'application/json')
  .set('Authorization','Bearer ' + token)
  .end(callback)

exports = module.exports =

  getToken : ( username, password, callback = printResults ) ->
    client_id = username
    client_secret = password
    basicAuthCred = client_id + ":" + client_secret + "@"
    url = "https://" + basicAuthCred + "api.sandbox.paypal.com/v1/oauth2/token"
    data = { grant_type : 'client_credentials' }
    superagent.agent()
    .post(url)
    .type('application/x-www-form-urlencoded')
    .send(data)
    .set('Accept', 'application/json')
    .set('Accept-Language', 'en_US')
    .end(callback)

## These would be called from routes in Express server

  getAllPayments : ( token, callback = printResults) ->
    ajaxGet("", token, callback)

  getApprovedPayments : ( token, callback = printResults ) ->
    ajaxGet('?state=approved', token, callback)

  getPaymentsPaged : ( token, callback = printResults ) ->
    ajaxGet('?count=10', token, callback)

  getPaymentById : ( id, token, callback = printResults ) ->
    ajaxGet(id, token, callback)

  createPayment : ( payment, token, callback = printResults ) ->
    ajaxPost("", JSON.stringify(payment), token, callback)

  executePayment : ( id, payer, token, callback = printResults ) ->
    ajaxPost( id + '/execute/', JSON.stringify(payer), token, callback)

return module.exports
