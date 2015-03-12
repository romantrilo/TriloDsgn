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
            @counter = 0

        render: ->
            @$el.html @template()
            @$links = @$el.find('.menu-wrapper').find 'a'
            @

        _isOpened: ->
            $('body').hasClass('menu-opened')

        close: ->
            if @_isOpened()
                @app.header.toggleMenu()

        animateMenuLinks: ->
            _.delay @_animateLink.bind(@), i * 100 for link, i in @$links

        _animateLink: () ->
            hideBackground = ->
                linkText.addClass('show')
                background.addClass 'hide'
                _.delay backgroundToDefault, 600

            backgroundToDefault = ->
                background.removeClass 'show'
                background.removeClass 'hide'

            link = @$links.eq @counter
            linkText = link.find('.text').find 'span'
            background = link.find('.background')

            background.addClass 'show'
            _.delay hideBackground, 600

            @counter++

            if @counter == @$links.length
                @counter = 0


        hideLinks: ->
            @$links.find('.text').find('span').removeClass 'show'
    }
