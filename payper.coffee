###
# payper
======

## Node Examples for the _PayPal_ REST API with AJAX


## Featuring [SuperAgent](https://github.com/visionmedia/superagent) for nice the AJAX
See the PayPal API at: https://developer.paypal.com/webapps/developer/docs/api


## Install:
- Run the [nodejs.org](http://nodejs.org) installer.
- Download the [zip file](https://github.com/apelade/payper/archive/master.zip).
- Extract it and open a shell there.
- `npm install superagent`
- `npm install -g coffee-script` if desired?


## Run:
- `node payper.js` or `coffee payper.coffee`
- `coffee -c payper.coffee` compiles coffee to javascript


## Notes: 
- The tests that try to execute a payment Correctly Fail with PAYMENT_STATE_INVALID 
  when running static PayPal test objects.
- To create live test objects, get a dev client id and secret from PayPal.
- Note the payment approval step must have been taken by the user for
  completePayment to succeed.
- Don't forget to redirect to approval_url listed in response links if using
  the paypal payment method.
- Since this is an example, uses a single-arg callback.
- Otherwise, it may be a callback per result state, using a common err handler.
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
