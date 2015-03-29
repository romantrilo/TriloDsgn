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
            @listenTo @app, 'open-about', @showAbout
            @listenTo @app, 'open-contacts', @showContacts
            @initProjectRoutes()

        routes: {
            '': 'init'
            'work': 'showTimeline'
            'timeline/:item': 'updateTimeline'
            'contacts': 'showContacts'
            'about': 'showAbout'
            '*404': 'show404'
        }

        initProjectRoutes: ->
            addRoute = (item, index) =>
                if item.isProject
                    @.route @urls[index], @showItem

            _.each @items, addRoute

        init: (options) ->
            ignoreScrolling = options and options.ignoreScrolling
            url = options and options.url

            show = =>
                url = if url then url else @urls[@urls.length - 1]
                @updateTimeline url

            middleIndex = Math.floor(@urls.length / 2)

            @app.initTimeline()
            @app.timeline.update middleIndex, false
            unless ignoreScrolling
                $(document).on 'first-load-done', show

        updateTimeline: (url) ->
            unless @app.timeline
                @init {url: url}
                return

            delay = 0

            if @app.menu.isOpened()
                @app.menu.close()
                delay = 1000

            _.delay =>
                if @app.$body.hasClass 'about'
                    @app.about.hide()
                    _.delay =>
                        @app.timeline.show()
                    , 1500
                    return
                else if @app.$body.hasClass 'contacts-active'
                    @app.contacts.hide()
                    _.delay =>
                        @app.timeline.show()
                    , 1000
                    return
                else if @app.$body.hasClass 'project'
                    @showTimeline()
                    return

                url = if url then url.toLowerCase()

                if @_urlExists(url)
                    index = _.indexOf @urls, url
                    indexDelta = Math.abs(@app.model.getCurrentIndex() - index)
                    withCustomSpeed = if indexDelta > 2 then true
                    @app.timeline.update index, withCustomSpeed
                    @_updateCurrentTimelineIndex index
                else
                    @show404()
            , delay

        updateTimelineUrl: (index) ->
            index = if index or index == 0 then index else @app.model.get 'currentTimelineItem'
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
                beforeIndex = @app.model.getCurrentIndex()
                @updateTimeline url
                afterIndex = @app.model.getCurrentIndex()
                delay = @app.model.getTimelineSpeed beforeIndex, afterIndex
                delay += 500
                _.delay show, delay

            updateTimeLimeWithDelay = =>
                _.delay updateTimeLine, 1500

            show = =>
                @navigate url, {trigger: false}
                @app.showItem()

            url = Backbone.history.fragment

            unless @app.timeline
                @init {ignoreScrolling: true}
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
                @app.about.show()
                @navigate '#about', {trigger: false}

            showWidthDelay = =>
                _.delay show, 1500

            unless @app.timeline
                @init {ignoreScrolling: true}
                $(document).on 'first-load-done', showWidthDelay
                return

            show()

        showContacts: ->
            show = =>
                @app.contacts.show()
                @navigate '#contacts', {trigger: false}

            showWidthDelay = =>
                _.delay show, 1500

            unless @app.timeline
                @init {ignoreScrolling: true}
                $(document).on 'first-load-done', showWidthDelay
                return

            show()


        show404: ->
            console.log '404 has been reached'
            @app.show404()

        _urlExists: (url) ->
            _.contains(@urls, url)
    }
