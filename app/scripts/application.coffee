define [

    'backbone'
    'router'
    'models/app'
    'views/app'
    'data/timeline-items'

], (Backbone, Router, AppModel, AppView, Data) ->

    'use strict'

    App = ->
        @start = =>
            @appView = new AppView {
                model: new AppModel Data
            }
            @router = new Router @
            Backbone.history.start()
        return
    App
