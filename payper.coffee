###
  Node Examples for the Paypal REST API with SuperAgent AJAX
  See https://github.com/apelade/payper/README.md for details
###

superagent = require 'superagent'

printResults = (err, res) ->
  console.log err if err?
  console.log res.body if res?.body?

PAYMENT = 'https://api.sandbox.paypal.com/v1/payments/payment/'
SALE = 'https://api.paypal.com/v1/payments/sale/'
REFUND = 'https://api.paypal.com/v1/refund/'
CREDIT_CARD ='https://api.paypal.com/v1/vault/credit-card/'

###
  Three wrapper functions for each main ajax type we need. No beforeSend func!
###
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
  
###
  These functions could be called from Express server route files, for example
  Params username and password are paypal sandbox credentials.
  Get your own for interaction with live paypal objects.
###
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

  getAllPayments : ( token, callback = printResults) ->
    ajaxGet('', token, callback)

  getApprovedPayments : ( token, callback = printResults ) ->
    ajaxGet('?state=approved', token, callback)

  getPaymentsPaged : ( token, callback = printResults ) ->
    ajaxGet('?count=10', token, callback)

  getPaymentById : ( id, token, callback = printResults ) ->
    ajaxGet(id, token, callback)

  createPayment : ( payment, token, callback = printResults ) ->
    ajaxPost('', JSON.stringify(payment), token, callback)

  executePayment : ( id, payer, token, callback = printResults ) ->
    ajaxPost( id + '/execute/', JSON.stringify(payer), token, callback)
    
  ############# UNTESTED #######################  
    
  getSaleById : ( id, token, callback = printResults ) ->
    ajaxGet( SALE + id, token, callback )
  
  refundSale : ( id, token, callback = printResults ) ->
    empty_payload = {}  
    ajaxPost( SALE + id + '/refund', empty_payload, token, callback )
    
  getRefundById : ( id, token, callback = printResults ) ->
    ajaxGet( REFUND + id, token, callback )
  
  # cvv2, names, and address are optional, supply defaults?
  storeCreditCard : ( type, num, exp_mo, exp_yr, cvv2, first_name, last_name, billing_addr, token, callback = printResults ) ->
    card =
      type: type
      number: num
      expire_month: exp_mo
      expire_year: exp_yr
      cvv2:cvv2
      first_name: first_name
      last_name: last_name
      billing_addr: billing_addr
      
    ajaxPost( CREDIT_CARD, JSON.stringify(card), token, callback )

  getCreditCardById : ( id, token, callback = printResults ) ->
    ajax.get( CREDIT_CARD + id, token, callback )    

return module.exports
