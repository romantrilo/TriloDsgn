define [

    'backbone'
    'text!../templates/menu.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        initialize: (options) ->
            @app = options.app
            @$el = @app.$el.find '#menu'
            $(document).on 'menu-link-timeout', @_onMenuLinkTimeout.bind @
            @counter = 0
            @render()
            @$links = @$el.find('.menu-wrapper').find 'a'
            @initListeners()

        render: ->
            @$el.html @template()
            @

        initListeners: ->
            @$links.mouseenter @_onMouseEnter.bind(@)
            @$links.mouseleave @_onMouseOut.bind(@)
            @$links.eq(1).click (event) =>
                onClick(event, 1)

            @$links.eq(2).click (event) =>
                onClick(event, 2)

            onClick = (event, index) =>
                event.preventDefault()
                @makeLinkBlack(index)

                if index == 1
                    @app.trigger 'open-about'
                else
                    @app.trigger 'open-contacts'

        isOpened: ->
            @app.$body.hasClass('menu-opened')

        open: ->
            overallDelay = 0

            if @app.$body.hasClass 'about'
                @app.about.hide { onMenuOpen: true }
                overallDelay = 1500
            else if @app.$body.hasClass 'contacts-active'
                @app.contacts.hide { onMenuOpen: true }
                overallDelay = 1000

            @app.navs.menuBtnToX()

            _.delay =>
                @app.navs.whiteLogo()
                @app.navs.whiteKeyWords()
                @app.$body.addClass 'menu-opened'
                @app.$blackRec.addClass 'menu-opened'
                @app.timeline.scrollPossible = false;

                @hideLinks()

                _.delay =>
                    @animateLinks()
                , 300

                _.delay =>
                    @app.navs.hideReturnLink()
                , 500

                _.delay =>
                    @app.navs.whiteContacts()
                , 700
            , overallDelay


        close: ->
            if document.location.hash == '#about' and @app.timeline
                @app.about.show()
                @makeLinkBlack(1)
                return
            else if document.location.hash == '#contacts' and @app.timeline
                @app.contacts.show()
                @makeLinkBlack(2)
                return

            unless @isOpened()
                return

            @app.navs.menuBtnToHamburger()
            @app.navs.unWhiteMenuBtn()
            @app.navs.unWhiteContacts()

            @app.$body.removeClass 'menu-opened'
            @app.$body.addClass 'menu-closing'
            @app.$blackRec.addClass 'menu-closed'

            if @app.navs.returnLinkVisility
                @app.navs.showReturnLink()

            _.delay =>
                @app.navs.menuBtnToHamburger()
            , 500

            _.delay =>
                @app.navs.unWhiteLogo()
                @app.navs.unWhiteKeyWords()
                @app.timeline.scrollPossible = true;
            , 700

            _.delay =>
                @hideLinks()
                @app.$body.removeClass 'menu-closing'
                @app.$blackRec.removeClass 'menu-opened'
                @app.$blackRec.removeClass 'menu-closed'
            , 1000

        animateLinks: ->
            _.delay @_animateLink.bind(@), i * 100 for link, i in @$links

        _animateLink: ->
            hideBackground = ->
                linkText.addClass('show')
                background.addClass 'hide'
                _.delay backgroundToDefault, 600

            backgroundToDefault = ->
                background.removeClass 'show'
                background.removeClass 'hide'
                $link.addClass 'hover-allowed'

            $link = @$links.eq @counter
            linkText = $link.find('.text').filter '.white'
            background = $link.find('.background')

            background.addClass 'show'
            _.delay hideBackground, 600

            @counter++

            if @counter == @$links.length
                @counter = 0

        hideLinks: ->
            @$links.find('.text').filter('.white').removeClass 'show'
            @$links.removeClass 'hover-allowed'

        _onMouseEnter: (event) ->
            $target = $ event.target.closest 'a'
            $background = $target.find('.background')

            if $target.data('mouse-entered') or !$target.hasClass('hover-allowed')
                return

            $target.data 'mouse-entered', true
            $target.data 'mouse-left', false
            $target.data 'timed-out', false

            $target.find('.dark').addClass 'show'
            $background.addClass 'show'

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

        makeLinkBlack: (index) ->
            $text = @$links.eq(index).find('.white').find('span')
            $text.addClass 'black'

            _.delay =>
                $text.removeClass 'black'
            , 3000
    }
