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
            @$emailBackground = @$email.find '.background'
            @$emailText = @$email.find 'span'

        render: ->
            @$el.html @template()
            @

        show: ->
            menuOpened = @app.menu.isOpened()
            delay = 0

            @app.timeline.scrollPossible = false
            @app.$body.addClass 'contacts-active'

            unless menuOpened
                @app.timeline.fadeOut()
                @app.$blackRec.addClass 'left-bottom'

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
            , 1800

            _.delay =>
                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @app.about.$el.hide 0
                @$el.show 0

                @app.$blackRec.addClass 'contacts-active'
                @app.navs.unWhiteReturnLink()
                @app.navs.unWhiteKeyWords()
                @app.navs.unWhiteContacts()
                @app.navs.unWhiteLogo()
                @app.navs.unWhiteMenuBtn()

                if menuOpened
                    @app.$body.removeClass 'menu-opened'
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.navs.menuBtnToHamburger()
                    @app.timeline.fadeOut()

                _.delay =>
                    @$emailBackground.addClass 'show'
                    @$arrow.addClass 'show'
                    @$arrow.addClass 'mobile-moving'
                    @app.menu.$el.hide 500
                , 1000

                _.delay =>
                    @$emailText.addClass 'show'
                    @$arrow.addClass 'right'
                , 1500
            , delay

        hide: (options) ->
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
                unless options && options.onMenuOpen
                    @app.$blackRec.addClass 'hide'
                    _.delay =>
                        @app.navs.unWhiteReturnLink()
                        @app.navs.unWhiteKeyWords()
                        @app.navs.unWhiteContacts()
                        @app.navs.unWhiteLogo()
                        @app.navs.unWhiteMenuBtn()
                    , 250
            , 1000

            _.delay =>
                @app.$blackRec.removeClass 'center-ease'
                @app.$blackRec.removeClass 'left-bottom'
                @app.$blackRec.removeClass 'hide'
                @$el.removeClass 'hide'
                @$arrow.removeClass 'show'
                @$arrow.removeClass 'mobile-moving'
                @$arrow.removeClass 'right'
                @$emailText.removeClass 'show'
                @$emailBackground.removeClass 'show'
            , 2000

    }
