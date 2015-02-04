define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Router.extend {

        initialize: (app) ->
            @app = app.appView
            @urls = @app.model.get('urls')
            @listenTo @app, 'timeline-update', @updateTimelineUrl

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
                @app.updateTimeline _.indexOf @urls, url
            else
                @goTo404()

        updateTimelineUrl: (index) ->
            @navigate "timeline/#{@urls[index]}", {trigger: false}

        goToContacts: ->
            @app.showContacts()

        goToAbout: ->
            @app.showAbout()

        goTo404: ->
            console.log '404 has been reached'
            @app.show404()
    }
