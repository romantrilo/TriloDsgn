define [

    'backbone'
    'text!../templates/preloader.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        className: 'pre-load outer fade-out'

        initialize: (options) ->
            @app = options.app

        render: ->
            @$el.html @template()
            @$text = @$el.find '.text'
            @$over = @$el.find '.over'
            @$descr = @$el.find '.pre-load-description'
            @app.$itemWrapper.prepend @$el

        updateText: () ->
            title = @app.model.getCurrentTitle()
            @$text.text title
            @$over.text title
            @$descr.text @app.model.getCurrentDescription()


        fadeIn: ->
            @$el.removeClass 'fade-out'
            @app.$itemWrapper.css 'zIndex', 5

        fadeOut: ->
            widthToDefault = =>
                @$over[0].style.width = 0;

            @$el.addClass 'fade-out'
            @app.$itemWrapper.css 'zIndex', 0
            setTimeout widthToDefault, 1000

    }
