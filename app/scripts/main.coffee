#/*global require*/
'use strict'

require.config
  paths:
    jquery: '../bower_components/jquery/dist/jquery.min'
    backbone: '../bower_components/backbone/backbone'
    underscore: '../bower_components/underscore/underscore-min'
    text: '../bower_components/text/text'
    slick: '../bower_components/slick/slick/slick.min'

  shim: {
      'slick': {
          'deps': ['jquery']
          'exports': 'slick'
      }
  }

require [
  'application'
], (App) ->
  new App().start()
