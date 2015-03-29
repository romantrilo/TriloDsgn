define [

    'backbone'
    'text!../templates/contacts.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        initialize: (options) ->
            @app = options.app
            @$el = @app.$el.find '#contacts'
            @render()
            @$arrow = @$el.find '.arrow'
            @$email = @$el.find '.email'
            @$emailText = @$email.find 'span'

        render: ->
            @$el.html @template()
            @

        show: ->
            isMenuOpened = @app.menu.isOpened()
            isMobile = window.innerWidth < 1000
            delay = 0

            @app.timeline.scrollPossible = false
            @app.$body.addClass 'contacts-active'

            if isMenuOpened
                @app.navs.menuBtnToHamburger()
            else
                @app.timeline.fadeOut()
                @app.$blackRec.addClass 'bottom'

                _.delay =>
                    @app.$blackRec.addClass 'center-ease'
                    @app.navs.unWhiteKeyWords()
                , 1000

                _.delay =>
                    @app.navs.whiteLogo()
                    @app.navs.whiteMenuBtn()
                    @app.navs.whiteReturnLink()
                    @app.navs.whiteContacts()
                , 1800

                delay = 2200

            _.delay =>
                @app.navs.showReturnLink()
            , 500

            _.delay =>
                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @app.about.$el.hide 0

                if isMobile
                    @app.$blackRec.addClass 'bottom'
                    mobileDelay = 1000

                _.delay =>
                    @$el.show 0
                    @app.navs.hideFooterElements()
                    @app.navs.unWhiteReturnLink()
                    @app.navs.unWhiteKeyWords()
                    @app.navs.unWhiteContacts()
                    @app.navs.unWhiteLogo()
                    @app.navs.unWhiteMenuBtn()
                    @app.$blackRec.addClass 'contacts-active'

                    _.delay =>
                        @$emailText.addClass 'show'
                        @$arrow.addClass 'show'
                        @$arrow.addClass 'mobile-moving'
                    , 1000

                    _.delay =>
                        @$arrow.addClass 'right'
                        @app.menu.$el.hide 0
                    , 1500
                , mobileDelay

                if isMenuOpened
                    _.delay =>
                        @app.$body.removeClass 'menu-opened'
                        @app.$blackRec.removeClass 'menu-opened'
                        @app.timeline.fadeOut()
                    , 2000
            , delay

        hide: (options) ->
            onMenuOpened = options && options.onMenuOpen

            @app.timeline.scrollPossible = true
            @app.$blackRec.addClass 'center-ease'
            @app.$blackRec.removeClass 'contacts-active'
            @$el.addClass 'hide'

            _.delay =>
                @app.navs.hideReturnLink()
                @app.navs.whiteLogo()
                @app.navs.whiteMenuBtn()
                @app.navs.whiteReturnLink()
                @app.navs.whiteContacts()
            , 800

            _.delay =>
                @app.$body.removeClass 'contacts-active'
                @$el.hide 0
                @app.timeline.$el.show 0
                @app.$itemWrapper.show 0
                @app.menu.$el.show 0
                @app.timeline.reInitSliders(onMenuOpened)
                @app.navs.showFooterElements()
                unless onMenuOpened
                    @app.$blackRec.addClass 'hide'
                    _.delay =>
                        @app.navs.unWhiteReturnLink()
                        @app.navs.unWhiteKeyWords()
                        @app.navs.unWhiteContacts()
                        @app.navs.unWhiteLogo()
                        @app.navs.unWhiteMenuBtn()
                        $(window).trigger 'resize'
                    , 100
            , 1000

            _.delay =>
                @app.$blackRec.removeClass 'center-ease'
                @app.$blackRec.removeClass 'bottom'
                @app.$blackRec.removeClass 'hide'
                @$el.removeClass 'hide'
                @$arrow.removeClass 'show'
                @$arrow.removeClass 'mobile-moving'
                @$arrow.removeClass 'right'
                @$emailText.removeClass 'show'
            , 2000

    }
