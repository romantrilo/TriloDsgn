#/*global require*/
'use strict'

require.config
  paths:
    jquery: '../bower_components/jquery/dist/jquery.min'
    backbone: '../bower_components/backbone/backbone'
    underscore: '../bower_components/underscore/underscore-min'
    itemslide: 'vendor/itemslide'
    jqueryScroll: 'vendor/jquery-scroll.js'

  shim: {
      itemslide:
          deps: ['jquery', 'jqueryScroll'],
          exports: 'slider'
  }

require [
  'application'
], (App) ->
  new App().start()
