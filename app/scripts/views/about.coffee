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
                console.time '1'
                @app.hideAllExcept @$el
                @app.navs.unWhiteKeyWords()
                @app.navs.unWhiteContacts()
                @app.navs.hideFooterElements()

                _.delay =>
                    @app.navs.showReturnLink()
                    @app.navs.whiteReturnLink()
                    @app.navs.menuBtnToHamburger()
                    @app.navs.whiteMenuBtn()
                    if menuOpened
                        @app.menu.$el.hide 250
                , 500

                _.delay =>
                    @$groups.addClass 'up'
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.$blackRec.removeClass 'about-start'
                    @app.$blackRec.removeClass 'center'
                , 1000

            @app.$body.addClass 'about'
            if menuOpened
                _.delay =>
                    @app.$blackRec.removeClass 'menu-opened'
                , 1000
            else
                @app.$blackRec.addClass 'about-start'
                @app.timeline.fadeOut()
                showAboutDelay = 2000
                _.delay =>
                    @app.$blackRec.addClass 'center'
                    console.time '1'
                , 1000



            _.delay showAbout, showAboutDelay
            return

        hide: ->
            @app.$body.removeClass 'about'

    }
