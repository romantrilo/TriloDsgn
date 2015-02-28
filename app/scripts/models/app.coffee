define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Model.extend {

        initialize: (items) ->

            _.each items, (item) ->
                url = item.title.replace(/\s+/g, '-').toLowerCase()
                addition = if item.urlAddition then '-' + item.urlAddition.replace(/\s+/g, '-').toLowerCase() else ''
                item.url = url + addition

            @set {'items': items}

        getCurrentIndex: ->
            @get 'currentTimelineItem'

        getCurrentItem: ->
            index = @getCurrentIndex()
            @get('items')[index]

        getCurrentTitle: ->
            item = @getCurrentItem()
            if item.isProject then item.title else 'about'

        getCurrentDescription: ->
            item = @getCurrentItem()
            if item.isProject then item.description else 'my story in a few words'

        getCurrentUrl: ->
            @getCurrentItem().url

        isCurrentProject: ->
            @getCurrentItem().isProject

        isUrlCurrent: (url) ->
            url == @getCurrentItem().url

        getSpeedByIndex: (index) ->
            unless index
                1000

            currentIndex = @getCurrentIndex()
            @getTimelineSpeed index, currentIndex

        getTimelineSpeed: (indexBefore, indexAfter) ->
            delta = Math.abs indexBefore - indexAfter
            delta * 400

    }
