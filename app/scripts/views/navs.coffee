define [

    'backbone'
    'text!../templates/navs.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        initialize: (options) ->
            @app = options.app
            @render()
            @initElements()
            @initListeners()

        render: ->
            @$el.html @template()
            navs = @$el.find '.nav'
            @app.$el.append nav for nav in navs
            @

        initElements: ->
            @$menuBtn = @app.$el.find '.lines-button'
            @$lines = @$menuBtn.find('.lines')
            @$logo = @app.$el.find '.logo h1'
            @$logoClickable = @app.$el.find '.logo-clickable'
            @$return = @app.$el.find '.return'
            @$returnP = @app.$el.find '.return p'
            @$contacts = @app.$el.find '.contacts'
            @$keywords = @app.$el.find '.key-words'

        initListeners: ->
            @$menuBtn.click @toggleMenu.bind @
            @$logoClickable.click @showTimeline.bind @
            @$returnP.click @hideCurrentLayer.bind @


        toggleMenu: ->
            if @$lines.hasClass 'x'
                unless @app.$body.hasClass 'menu-closing'
                    @app.menu.close()
            else
                unless @app.$body.hasClass('menu-opened') or @app.$body.hasClass('menu-closing')
                    @app.menu.open()

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
                @$menuBtn.trigger 'click'
            else
                @app.timeline.show()

        whiteLogo: ->
            @$logo.addClass 'white'

        unWhiteLogo: ->
            @$logo.removeClass 'white'

        whiteContacts: ->
            @$contacts.addClass 'white'

        unWhiteContacts: ->
            @$contacts.removeClass 'white'

        whiteKeyWords: ->
            @$keywords.addClass 'white'

        unWhiteKeyWords: ->
            @$keywords.removeClass 'white'

        whiteReturnLink: ->
            @$return.addClass 'white'

        unWhiteReturnLink: ->
            @$return.removeClass 'white'

        whiteMenuBtn: ->
            @$menuBtn.addClass 'white'

        unWhiteMenuBtn: ->
            @$menuBtn.removeClass 'white'

        hideCurrentLayer: ->
            if @app.$body.data('layer') == 'about'
                @app.about.hide()
                return
            if @app.$body.data('layer') == 'contacts'
                @app.contacts.hide()
                return

        showFooterElements: ->
            @$keywords.removeClass 'hide'
            @$contacts.removeClass 'hide'

        hideFooterElements: ->
            @$keywords.addClass 'hide'
            @$contacts.addClass 'hide'

    }

