
# /*
#   Index
# */
# Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
# Create: Sat Mar 28 2015 15:42:51 GMT+0800 (CST)
#

"use strict"

urlLib = require './url'

paramsHaveRequestBody = ( params ) ->
  { body, requestBodyStream, json, multipart } = params.options
  body or requestBodyStream or 'boolean' isnt typeof json or multipart

checkUrlOrUri = ( options ) ->
  { url, uri } = options
  url ?= uri
  if 'object' is typeof url
    url = urlLib.format url
  else if undefined is url or null is url
    throw new Error 'url or uri could not be undefined or null.'
  options.url = url

checkNecessaryParam = ( options ) ->
  { headers, method, body, form, timeout, async } = options
  async   ?= true
  timeout ?= -1
  headers ?= {}
  method  ?= 'GET'
  method   = method.toUpperCase()
  if method in [ 'POST', 'PUT' ]
    if body?
      headers[ 'content-type' ] ?= 'application/json'
      reqBody = body
    else if form?
      headers[ 'content-type' ] ?= 'application/x-www-form-urlencoded'  
      reqBody = ''
      for key, value of form
        reqBody += "#{key}=#{value}&"
      reqBody = reqBody.substr 0, reqBody.length - 1

  options.async   = async
  options.headers = headers
  options.method  = method
  options.reqBody = reqBody

request = ( options, callback ) ->

  # check the url is valid
  checkUrlOrUri options

  # check the nessary params
  checkNecessaryParam options

  return new Request options, callback

class Request

  constructor : ( options, callback ) ->
    { url, headers, method, reqBody, async, user, password, timeout } = options
    req = new XMLHttpRequest

    req.timeout = timeout
    req.ontimeout = ( event ) ->
      error = new Error "request timeout with url:#{url}"
      callback error

      # avoid multi call.
      callback  = ->

    req.onerror = ( e ) ->
      callback e

      # avoid multi call.
      callback  = ->

    req.onreadystatechange = ->
      { readyState, status } = req
      if 4 is readyState
        callback null, req, req.responseText

    req.open method, url, async, user, password

    # set request headers
    for key, value of headers
      req.setRequestHeader key, value

    try
      req.send reqBody
    catch e
      callback e

      # avoid multi call
      callback = ->

module.exports = request
