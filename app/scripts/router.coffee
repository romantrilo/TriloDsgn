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
            'work': 'showTimeline'
            'timeline/:item': 'updateTimeline'
            'contact': 'goToContacts'
            'about': 'goToAbout'
            '*404': 'goTo404'
        }

        init: ->
            @updateTimeline('')
            @_updateCurrentTimelineIndex 0

        updateTimeline: (url) ->
            url = if url then url.toLowerCase()
            if _.contains(@urls, url) or !url
                index = if url then _.indexOf @urls, url else 0
                @app.updateTimeline index
                @_updateCurrentTimelineIndex index
            else
                @goTo404()

        updateTimelineUrl: (index) ->
            @navigate "timeline/#{@urls[index]}", {trigger: false}
            @_updateCurrentTimelineIndex index

        showTimeline: ->
            @app.showTimeline()
            @updateTimelineUrl(@app.model.get 'currentTimelineItem')

        _updateCurrentTimelineIndex: (index) ->
            @app.model.set {'currentTimelineItem': index}

        goToContacts: ->
            @app.showContacts()

        goToAbout: ->
            @app.showAbout()

        goTo404: ->
            console.log '404 has been reached'
            @app.show404()
    }
