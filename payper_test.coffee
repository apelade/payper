###
  Show example usage with static test data
###

payper = require "./payper"

###
  Exercise the functions in payjaq
###
test = () ->
  client_id = 'EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp'
  client_secret = 'EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp'
  
  ###
    Get a token that will be used to credential the remaining ops
  ###
  payper.getToken client_id, client_secret, (err, res) ->
    console.log err if err? 
    token = res.body.access_token
    console.log "Token == ", token, "\n"
    
    ###
      Get 10 payments
    ###
    payper.getPaymentsPaged token, (err, res) ->
      console.log " "
      console.log res.body.payments
      fakeid = res.body.payments[0].id
      console.log " ABOUT TO GET PAYMENT BY ID"
      
      ###
        Get a payment by id
      ###
      payper.getPaymentById fakeid, token, payper.thisnevergetscalled    
    
    ###
      Get your payments of status approved
    ###
    payper.getApprovedPayments token, (err,res) ->
      console.log res.body.payments[0]
    
    ###
      Make a test object
    ###
    fakepayment = 
      intent: "sale"
      payer:
        payment_method: "credit_card"
        funding_instruments: [credit_card:
          number: "4417119669820331"
          type: "visa"
          expire_month: 11
          expire_year: 2018
          cvv2: 874
          first_name: "Joe"
          last_name: "Shopper"
          billing_address:
            line1: "52 N Main ST"
            city: "Johnstown"
            country_code: "US"
            postal_code: "43210"
            state: "OH"
        ]
      transactions: [
        amount:
          total: "7.47"
          currency: "USD"
          details:
            subtotal: "7.41"
            tax: "0.03"
            shipping: "0.03"
        description: "This is the FAKE transaction description."
      ]

    fakepayer =
      { payer_id : "7E7MGXCWTTKK2" }
    
    ###
      Create a payment with the test object
    ### 
    payper.createPayment fakepayment, token, (err,res) ->
      console.log "CREATE PAYMENT result : " , res.body
      console.log " "
      ###
        Executing that payment will fail as is
      ###
      console.log "EXPECT ERROR: on static test data with message STATE INVALID"
      payper.executePayment res.body.id, fakepayer, token 
      console.log " "


test()
