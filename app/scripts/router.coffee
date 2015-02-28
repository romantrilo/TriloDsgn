define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Router.extend {

        initialize: (app) ->
            getUrls = (item) =>
                item.url

            @app = app.appView
            @items = @app.model.get('items')
            @urls = _.map @items, getUrls
            @listenTo @app, 'timeline-update', @updateTimelineUrl
            @initProjectRoutes()

        routes: {
            '': 'init'
            'work': 'showTimeline'
            'timeline/:item': 'updateTimeline'
            'contact': 'showContacts'
            'about': 'showAbout'
            '*404': 'show404'
        }

        initProjectRoutes: ->
            addRoute = (item, index) =>
                if item.isProject
                    @.route @urls[index], @showItem

            _.each @items, addRoute

        init: ->
            index = @urls.length - 1
            @updateTimeline @urls[index]
            @_updateCurrentTimelineIndex index

        updateTimeline: (url) ->
            url = if url then url.toLowerCase()
            if @_urlExists(url) or !url
                index = if url then _.indexOf @urls, url else 0
                @app.updateTimeline index
                @_updateCurrentTimelineIndex index
            else
                @show404()

        updateTimelineUrl: (index) ->
            index = if index then index else @app.model.get 'currentTimelineItem'
            @navigate "timeline/#{@urls[index]}", {trigger: false}
            @_updateCurrentTimelineIndex index

        showTimeline: ->
            if @app.timeline
                @app.timeline.show()
                @updateTimelineUrl(@app.model.get 'currentTimelineItem')
            else
                @init()

        _updateCurrentTimelineIndex: (index) ->
            @app.model.set {'currentTimelineItem': index}

        showItem: ->
            updateTimeLine = =>
                @updateTimeline url
                _.delay show, 1500

            updateTimeLimeWithDelay = =>
                _.delay updateTimeLine, 1500

            show = =>
                @navigate url, {trigger: false}
                @app.showItem()

            url = Backbone.history.fragment

            unless @app.timeline
                @init()
                if @_urlExists(url)
                    $(document).on 'first-load-done', updateTimeLimeWithDelay
                    return

            if @_urlExists(url)
                if @app.model.isUrlCurrent(url)
                    @app.showItem()
                else
                    updateTimeLine()
            else
                @show404()

            return

        showAbout: ->
            show = =>
                @app.showItem()

            showWidthDelay = =>
                _.delay show, 1500

            unless @app.timeline
                @init()
                $(document).on 'first-load-done', showWidthDelay
                return

            if @app.model.isCurrentProject()
                @updateTimeline('')
                showWidthDelay()
                return
            else
               show()

            return

        showContacts: ->
            @app.showContacts()

        show404: ->
            console.log '404 has been reached'
            @app.show404()

        _urlExists: (url) ->
            _.contains(@urls, url)
    }
