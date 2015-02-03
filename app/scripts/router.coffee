define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Router.extend {

        initialize: (app) ->
            @app = app
            @urls = app.appView.model.get('urls')

        routes: {
            'timeline/:item': 'updateTimeline'
            'contacts': 'goToContacts'
            'about': 'goToAbout'
            '404': 'goTo404'
        }

        updateTimeline: (url) ->
            unless _.contains @urls, url
                console.log url

        goToContacts: ->

        goToAbout: ->

        goTo404: ->
    }
