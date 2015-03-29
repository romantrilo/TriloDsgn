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
            isMobile = window.innerWidth < 768

            showAbout = =>
                @app.$blackRec.addClass 'about'

                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @app.contacts.$el.hide 0
                @$el.show 0

                if isMobile
                    @app.navs.whiteLogo()
                else
                    @app.navs.unWhiteLogo()

                @app.navs.unWhiteKeyWords()
                @app.navs.unWhiteContacts()
                @app.navs.showReturnLink()
                @app.navs.whiteReturnLink()
                @app.navs.menuBtnToHamburger()
                @app.navs.whiteMenuBtn()

                if menuOpened
                    _.delay =>
                        @app.menu.$el.hide 1000
                    , 1000

                @app.timeline.slideItemDown()

                _.delay =>
                    @$groups.addClass 'up'
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.$blackRec.removeClass 'left-bottom'
                    @app.timeline.scrollPossible = true;
                , 1000

            @app.$body.addClass 'about'

            if menuOpened
                _.delay =>
                    @app.$blackRec.removeClass 'menu-opened'
                    @app.$body.removeClass 'menu-opened'
                    @app.menu.$el.show 0
                    @app.timeline.fadeOut()
                , 2500
            else
                @app.$blackRec.addClass 'left-bottom'

                if @app.timeline
                    @app.timeline.fadeOut()

                showAboutDelay = 2000

                _.delay =>
                    @app.$blackRec.addClass 'center'
                , 1000

            _.delay showAbout, showAboutDelay
            return

        hide: (options) ->
            onMenuOpen = options && options.onMenuOpen
            @scrollTop()

            _.delay =>
                @$groups.removeClass 'up'
            , @scrollUpTime

            _.delay =>
                @app.$body.removeClass 'about'
                @app.$blackRec.addClass 'center'
                @app.$blackRec.removeClass 'about'
                @app.navs.hideReturnLink()
            , 500 + @scrollUpTime

            _.delay =>
                @app.navs.whiteLogo()
                @app.navs.whiteContacts()
            , 1300 + @scrollUpTime

            _.delay =>
                @app.timeline.$el.show 0
                @app.$itemWrapper.show 0
                @$el.hide 0
                @app.timeline.reInitSliders(onMenuOpen)
                unless onMenuOpen
                    @app.$blackRec.addClass 'hide'
                    @app.navs.unWhiteMenuBtn()
                    @app.navs.unWhiteLogo()
                    @app.navs.unWhiteContacts()
            , 1500 + @scrollUpTime

            _.delay =>
                @app.$blackRec.removeClass 'center'
                @app.$blackRec.removeClass 'hide'
            , 2500 + @scrollUpTime

            return


        scrollTop: ->
            slide = =>
                @$groups.removeClass 'up'

            itemTopOffset = @$el.scrollTop()

            @scrollUpTime = if itemTopOffset == 0 then 0 else itemTopOffset

            @$el.animate({
                scrollTop: 0
            }, @scrollUpTime);

            _.delay slide, @scrollUpTime
    }
