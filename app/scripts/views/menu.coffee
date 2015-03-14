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
            $(document).on 'menu-link-timeout', @_onMenuLinkTimeout.bind @

        render: ->
            @$el.html @template()
            @$links = @$el.find('.menu-wrapper').find 'a'
            @$links.mouseenter @_onMouseEnter.bind(@)
            @$links.mouseleave @_onMouseOut.bind(@)
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
            linkText = link.find('.text').filter '.white'
            background = link.find('.background')

            background.addClass 'show'
            _.delay hideBackground, 600

            @counter++

            if @counter == @$links.length
                @counter = 0

        hideLinks: ->
            @$links.find('.text').filter('.white').removeClass 'show'

        _onMouseEnter: (event) ->
            $target = $ event.target.closest 'a'

            if $target.data 'mouse-entered'
                return

            $target.data 'mouse-entered', true
            $target.data 'mouse-left', false
            $target.data 'timed-out', false

            $target.find('.dark').addClass 'show'
            $target.find('.background').addClass 'show'

            _.delay ->
                $target.find('.white').removeClass 'show'
                $target.find('.white').addClass 'above'
            , 500

            _.delay ->
                $(document).trigger 'menu-link-timeout', $target
            , 600

        _onMouseOut: (event, onTimeout) ->
            $target = $ event.target.closest 'a'

            unless $target.data 'timed-out'
                $target.data 'mouse-left', true
                return

            if $target.data('mouse-left') and !onTimeout
                return

            $background = $target.find('.background')
            $background.addClass 'hide'
            $target.find('.white').addClass 'show'
#
            _.delay ->
                $target.find('.white').removeClass 'above'
                $target.find('.dark').removeClass 'show'
                $background.removeClass 'show'
                $background.removeClass 'hide'
                $target.data 'mouse-entered', false
                $target.data 'mouse-left', false
                $target.data 'timed-out', false
            , 500

        _onMenuLinkTimeout: (event, link) ->
            $link = $ link
            $link.data 'timed-out', true
            if $link.data 'mouse-left'
                fakeEvent = {}
                fakeEvent.target = $link[0]
                @_onMouseOut(fakeEvent, true)
    }
