define [

    'backbone'
    'views/footer'
    'text!../templates/menu.html'

], (Backbone, Footer, template) ->

    'use strict'

    Backbone.View.extend {

        className: 'menu'

        template: _.template(template)

        initialize: (options) ->
            @app = options.app

        render: ->
            @$el.html @template()
            @

        _isOpened: ->
            $('body').hasClass('menu-opened')

        close: ->
            if @_isOpened()
                @app.header.toggleMenu()

    }
