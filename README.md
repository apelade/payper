###
# payper
======

## Node Examples for the _PayPal_ REST API with AJAX

### Featuring [SuperAgent](https://github.com/visionmedia/superagent) for this festival of AJAX.
- It's a powerful ajax cleanser, and works on windows no problem.

### There is a jquery version of these examples: __[payjaq](https://github.com/apelade/payjaq)__
- It's a longer install for the deps on windows, but that's where the jquery is at.

### See the [PayPal API](https://developer.paypal.com/webapps/developer/docs/api) 


## Install:
- Run the [nodejs.org](http://nodejs.org) installer.
- Download the [zip file](https://github.com/apelade/payper/archive/master.zip).
- Extract it and open a shell there.
- `npm install superagent`
- `npm install -g coffee-script` if desired?


## Run:
- `node payper_test.js` or `coffee payper_test.coffee`
- `coffee -cb payper_test.coffee` compiles to javascript


## Notes:
- To create live test objects, get a dev client id and secret from PayPal.
- Immutable PayPal-hosted objects may have outages, like on 4/4/2013 2:15 PM Pacific, or go away.
 - The error output was on res.body.payments[0]
 - TypeError cannot read property [0] of undefined
- The tests that try to execute a payment Correctly Fail with PAYMENT_STATE_INVALID 
  when running static PayPal test objects.
- Note the payment approval step must have been taken by the user for
  completePayment to succeed.
- Don't forget to redirect to approval_url listed in response links if using
  the paypal payment method. See github/apelade/sto for a [simple example.](https://github.com/apelade/sto/blob/master/route/index.coffee)
- Since this is an example, uses a single-arg callback.
- Otherwise, it may be a callback per result state, using a common err handler.

### License:
MIT 
