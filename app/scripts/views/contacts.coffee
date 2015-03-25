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
                    @app.navs.showReturnLink()
                    @app.navs.whiteReturnLink()
                    @app.navs.whiteContacts()
                , 1800

                delay = 2200

            _.delay =>
                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @$el.show 0

                @app.$blackRec.addClass 'contacts-active'
                @app.navs.unWhiteReturnLink()
                @app.navs.unWhiteKeyWords()
                @app.navs.unWhiteContacts()
                @app.navs.unWhiteLogo()
                @app.navs.unWhiteMenuBtn()

                if menuOpened
                    @app.$body.removeClass 'menu-opened'
                    @app.navs.menuBtnToHamburger()

                _.delay =>
                    @$emailBackground.addClass 'show'
                    @app.menu.$el.hide 500
                    @$arrow.addClass 'mobile-moving'
                    @$arrow.addClass 'show'
                , 1000

                _.delay =>
                    @$emailText.addClass 'show'
                    @$arrow.addClass 'right'
                , 1500
            , delay

    }
