define [

    'backbone'
    'text!../templates/timeline.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        tagName: 'div'

        id: 'timeline'

        template: _.template(template)

        initialize: ->
            @render()

        render: ->
            @$el.html @template(@model)
            @initTimeline()
            @initCovers()
            return @

        initTimeline: ->
            @timeline = @$el.find '.timeline'
#            TODO

        initCovers: ->
            @covers = @$el.find '.covers'
#            TODO

        update: (url) ->

        toBeginning: ->

    }
