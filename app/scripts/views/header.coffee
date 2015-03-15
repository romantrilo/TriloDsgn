define [

    'backbone'
    'text!../templates/header.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        events: {
            'click .lines-button': 'toggleMenu'
            'click .logo-clickable': 'showTimeline'
            'click .return p': 'showTimeline'
        }

        tagName: 'header'

        template: _.template(template)

        initialize: (options) ->
            @app = options.app
            @returnLinkVisility = false

        render: ->
            @$el.html @template()
            @$menuBtn = @$el.find '.lines-button'
            @$lines = @$menuBtn.find('.lines')
            @$logo = @$el.find '.logo h1'
            @$return = @$el.find '.return'
            @

        toggleMenu: ->
            if @$lines.hasClass 'x'
                unless @app.$body.hasClass 'menu-closing'
                    @_closeMenu()
            else
                unless @app.$body.hasClass('menu-opened') or @app.$body.hasClass('menu-closing')
                    @_openMenu()

        _openMenu: ->
            @whiteLogo()
            @menuBtnToX()

            @app.$body.addClass 'menu-opened'
            @app.footer.whiteKeyWords()
            @app.timeline.scrollPossible = false;

            _.delay( =>
                @app.menu.animateMenuLinks()
            , 300)

            _.delay( =>
                @hideReturnLink()
            , 500)

            _.delay( =>
                @app.footer.whiteContacts()
            , 700)

        _closeMenu: ->
            @menuBtnToHamburger()
            @app.footer.unWhiteContacts()

            @app.$body.removeClass 'menu-opened'
            @app.$body.addClass 'menu-closing'

            if @app.header.returnLinkVisility
                @app.header.showReturnLink()

            _.delay( =>
                @menuBtnToHamburger()
            , 500)

            _.delay( =>
                @unWhiteLogo()
                @app.footer.unWhiteKeyWords()
                @app.timeline.scrollPossible = true;
            , 700)

            _.delay( =>
                @app.menu.hideLinks()
                @app.$body.removeClass 'menu-closing'
            , 1000)

        menuBtnToX: ->
            @$lines.addClass 'close'
            _.delay( =>
                @$lines.addClass 'minus'
                @$lines.addClass 'x'
            , 500)

        menuBtnToHamburger: ->
            @$lines.removeClass 'x'
            _.delay( =>
                @$lines.removeClass 'minus'
                @$lines.removeClass 'close'
            , 500)

        showReturnLink: ->
            @$return.addClass 'visible'

        hideReturnLink: ->
            @$return.removeClass 'visible'

        showTimeline: ->
            if @app.$body.hasClass 'menu-opened'
                @app.header.$menuBtn.trigger 'click'
            else
                @app.timeline.show()

        whiteLogo: ->
            @$logo.addClass 'white'

        unWhiteLogo: ->
            @$logo.removeClass 'white'

    }
