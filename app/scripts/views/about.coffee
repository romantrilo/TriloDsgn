define [

    'backbone'
    'data/about-info'
    'text!../templates/about.html'

], (Backbone, Data, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        initialize: (options) ->
            @app = options.app
            @$el = @app.$el.find '#about'
            @render()
            @$groups = @$el.find '.groups'

        render: ->
            @$el.html @template(Data)
            @

        show: ->
            showAboutDelay = 0
            menuOpened = @app.menu.isOpened()

            showAbout = =>
                @app.$blackRec.addClass 'about'

                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @$el.show 0

                @app.navs.unWhiteKeyWords()
                @app.navs.unWhiteContacts()
                @app.navs.hideFooterElements()

                @app.navs.showReturnLink()
                @app.navs.whiteReturnLink()
                @app.navs.menuBtnToHamburger()
                @app.navs.whiteMenuBtn()

                if menuOpened
                    @app.menu.$el.hide 500

                _.delay =>
                    @$groups.addClass 'up'
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.$blackRec.removeClass 'about-start'
                , 1000

            @app.$body.addClass 'about'

            if menuOpened
                _.delay =>
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.$body.removeClass 'menu-opened'
                    @app.menu.$el.show 0
                    @app.timeline.fadeOut()
                , 1000
            else
                @app.$blackRec.addClass 'about-start'
                @app.timeline.fadeOut()
                showAboutDelay = 2000
                _.delay =>
                    @app.$blackRec.addClass 'center'
                , 1000

            _.delay showAbout, showAboutDelay
            return

        hide: ->
            @$groups.removeClass 'up'

            _.delay =>
                @app.$body.removeClass 'about'
                @app.$blackRec.addClass 'center'
                @app.$blackRec.removeClass 'about'
                @app.navs.hideReturnLink()
            , 1000

            _.delay =>
                @app.navs.whiteLogo()
                @app.navs.whiteContacts()
            , 1500

            _.delay =>
                @app.timeline.$el.show 0
                @app.$itemWrapper.show 0
                @$el.hide 0
                @app.$blackRec.addClass 'hide'
                _.delay =>
                    @app.navs.unWhiteMenuBtn()
                    @app.navs.unWhiteLogo()
                    @app.navs.unWhiteContacts()
                , 500
            , 2000

            _.delay =>
                @app.$blackRec.removeClass 'center'
                @app.$blackRec.removeClass 'hide'
            , 3000

            return
    }
