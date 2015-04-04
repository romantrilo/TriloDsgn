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
            @$h1 = @$el.find 'h1'
            @$text = @$el.find '.text'
            @$over = @$el.find '.over'
            @$descr = @$el.find '.pre-load-description'
            @app.$itemWrapper.prepend @$el

        updateText: () ->
            title = @app.model.getCurrentTitle()
            @app.updateTitle title.toUpperCase()
            @$h1.text title.toUpperCase()
            @$text.text title
            @$over.text title
            @$descr.text @app.model.getCurrentDescription()


        fadeIn: ->
            @$h1.show 0
            @$el.removeClass 'fade-out'
            @app.$itemWrapper.css 'zIndex', 30
            return

        fadeOut: ->
            widthToDefault = =>
                @$over[0].style.width = 0;

            @$h1.hide 0
            @$el.addClass 'fade-out'
            @app.$itemWrapper.css 'zIndex', 0
            setTimeout widthToDefault, 1000

    }
