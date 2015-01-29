#/*global require*/
'use strict'

require.config
  shim: {
    bootstrap:
      deps: ['jquery'],
      exports: 'jquery'
  }
  paths:
    jquery: '../bower_components/jquery/dist/jquery.min'
    backbone: '../bower_components/backbone/backbone'
    underscore: '../bower_components/underscore/underscore-min'
    itemslide: 'vendor/itemslide'

require [
  'application'
], (App) ->
  new App().start()
