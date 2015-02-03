define [

    'backbone'

], (Backbone) ->

    'use strict'

    Backbone.View.extend {

        el: $ 'main'

        events: {
            'click .lines-button': 'toggleMenu'
        }

        toggleMenu: () ->
            $btn = @$el.find '.lines-button'
            $lines = $btn.find('.lines')

            removeClose = ->
                $lines.removeClass 'close'
            addX = ->
                $lines.addClass 'x'

            if $lines.hasClass 'x'
                $lines.removeClass 'x'
                _.delay removeClose, 500
            else
                $lines.addClass 'close'
                _.delay addX, 500





    }
