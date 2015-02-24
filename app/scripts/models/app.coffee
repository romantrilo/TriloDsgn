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

        getCurrentItem: ->
            index = @get 'currentTimelineItem'
            @get('items')[index]

        getCurrentTitle: ->
            item = @getCurrentItem()
            if item.isProject then item.title else 'about'

        getCurrentDescription: ->
            @getCurrentItem().description

        getCurrentUrl: ->
            @getCurrentItem().url

        isCurrentProject: ->
            @getCurrentItem().isProject

        isUrlCurrent: (url) ->
            url == @getCurrentItem().url

    }
