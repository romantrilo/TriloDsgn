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
            'contact': 'goToContacts'
            'about': 'goToAbout'
            '*404': 'goTo404'
        }

        init: ->
            @updateTimeline('')

        updateTimeline: (url) ->
            url = url.toLowerCase()
            if _.contains(@urls, url) or url == ''
                index = if url == '' then 0 else _.indexOf @urls, url
                @app.updateTimeline index
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
