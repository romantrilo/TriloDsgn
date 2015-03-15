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

        toggleMenu: () ->
            onOpen1stStage = =>
                @app.menu.animateMenuLinks()

            onOpen2ndStage = =>
                @$lines.addClass 'minus'
                @$lines.addClass 'x'
                @hideReturnLink()

            onOpen3rdStage = =>
                @app.footer.whiteContacts()

            onClose1stStage = =>
                @$lines.removeClass 'minus'
                @$lines.removeClass 'close'

            onClose2ndStage = =>
                @$logo.removeClass 'white'
                @app.footer.$keywords.removeClass 'white'
                @app.timeline.scrollPossible = true;

            onClose3rdStage = =>
                @app.menu.hideLinks()
                @app.$body.removeClass 'menu-closing'

            if @$lines.hasClass 'x'
                if @app.$body.hasClass 'menu-closing'
                    return
                @app.$body.removeClass 'menu-opened'
                @app.$body.addClass 'menu-closing'
                @$lines.removeClass 'x'
                @app.footer.unWhiteContacts()
                if @app.header.returnLinkVisility
                    @app.header.showReturnLink()
                _.delay onClose1stStage, 500
                _.delay onClose2ndStage, 700
                _.delay onClose3rdStage, 700
            else
                if @app.$body.hasClass('menu-opened') or @app.$body.hasClass('menu-closing')
                    return
                @app.$body.addClass 'menu-opened'
                @$logo.addClass 'white'
                @$lines.addClass 'close'
                @app.footer.$keywords.addClass 'white'
                @app.timeline.scrollPossible = false;
                _.delay onOpen1stStage, 300
                _.delay onOpen2ndStage, 500
                _.delay onOpen3rdStage, 700

        showReturnLink: ->
            @$return.addClass 'visible'

        hideReturnLink: ->
            @$return.removeClass 'visible'

        showTimeline: ->
            if @app.$body.hasClass 'menu-opened'
                @app.header.$menuBtn.trigger 'click'
            else
                @app.timeline.show()

    }
