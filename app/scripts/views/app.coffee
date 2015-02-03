define [

    'backbone'
    'views/timeline'
    'text!../templates/app.html'

], (Backbone, Timeline, template) ->

    'use strict'

    Backbone.View.extend {

        el: $ 'main'

        template: _.template(template)

        events: {
            'click .lines-button': 'toggleMenu'
        }

        initialize: ->
            @render()
            @$content = @$el.find '#content'

        render: ->
            @$el.html @template()

        toggleMenu: () ->
            $btn = @$el.find '.lines-button'
            $lines = $btn.find('.lines')

            removeClose = ->
                $lines.removeClass 'minus'
                $lines.removeClass 'close'
            addX = ->
                $lines.addClass 'minus'
                $lines.addClass 'x'

            if $lines.hasClass 'x'
                $lines.removeClass 'x'
                _.delay removeClose, 500
            else
                $lines.addClass 'close'
                _.delay addX, 500


        updateTimeline: (index) ->
            if not @timeline
                @initTimeline()
            if index
                @timeline.update index
            else
                @timeline.update 0
            return

        showContacts: ->

        showAbout: ->

        show404: ->

        initTimeline: ->
            @timeline = new Timeline {model: @model.get 'items'}
            @$content.append @timeline.$el

    }
