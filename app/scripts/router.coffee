define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Router.extend {

        initialize: (app) ->
            @app = app.appView
            @urls = @app.model.get('urls')

        routes: {
            '': 'init'
            'timeline/:item': 'updateTimeline'
            'contacts': 'goToContacts'
            'about': 'goToAbout'
            '*404': 'goTo404'
        }

        init: ->
            @updateTimeline('')

        updateTimeline: (url) ->
            if url == '' or _.contains @urls, url
                @app.updateTimeline url
            else
                @goTo404()

        goToContacts: ->
            @app.showContacts()

        goToAbout: ->
            @app.showAbout()

        goTo404: ->
            console.log '404 has been reached'
            @app.show404()
    }
