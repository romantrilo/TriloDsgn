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
                delay = 1000

            _.delay =>
                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @$el.show 0

                @app.$blackRec.addClass 'contacts-active'
                @app.navs.showReturnLink()

                if menuOpened
                    @app.$body.removeClass 'menu-opened'
                    @app.navs.unWhiteLogo()
                    @app.navs.unWhiteMenuBtn()
                    @app.navs.menuBtnToHamburger()
                    @app.navs.unWhiteKeyWords()
                    @app.navs.unWhiteContacts()

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
