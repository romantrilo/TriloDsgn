define [

    'backbone'
    'router'
    'models/app'
    'views/app'

], (Backbone, Router, AppModel, AppView) ->

    'use strict'

    App = ->
        @start = =>
            @appView = new AppView {model: new AppModel}
            @router = new Router @
            Backbone.history.start()
        return
    App
