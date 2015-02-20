define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.Model.extend {

        initialize: (items) ->

            urls = _.map items, (item) ->
                url = item.title.replace(/\s+/g, '-').toLowerCase()
                addition = if item.urlAddition then '-' + item.urlAddition.replace(/\s+/g, '-').toLowerCase() else ''
                url += addition

            @set {'items': items}
            @set {'urls': urls}

        getCurrentItem: ->
            index = @get 'currentTimelineItem'
            @get('items')[index]

        getCurrentTitle: ->
            item = @getCurrentItem()
            if item.isProject then item.title else 'about'

        getCurrentDescription: ->
            @getCurrentItem().description

        getCurrentUrl: ->
            index = @get('currentTimelineItem')
            @get('urls')[index]

        isCurrentProject: ->
            @getCurrentItem().isProject

    }
