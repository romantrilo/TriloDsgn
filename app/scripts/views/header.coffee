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
            @$btn = @$el.find '.lines-button'
            @$lines = @$btn.find('.lines')
            @$logo = @$el.find '.logo h1'
            @$return = @$el.find '.return'
            @

        toggleMenu: () ->
            $body = $ 'body'
            $body.toggleClass 'menu-opened'

            onOpen1stStage = =>
                @$lines.addClass 'minus'
                @$lines.addClass 'x'
                @hideReturnLink()

            onOpen2ndStage = =>
                @app.footer.whiteContacts()

            onClose1stStage = =>
                @$lines.removeClass 'minus'
                @$lines.removeClass 'close'

            onClose2ndStage = =>
                @$logo.removeClass 'white'
                @app.footer.$keywords.removeClass 'white'
                @app.timeline.scrollPossible = true;

            if @$lines.hasClass 'x'
                @$lines.removeClass 'x'
                @app.footer.unWhiteContacts()
                if @app.header.returnLinkVisility
                    @app.header.showReturnLink()
                _.delay onClose1stStage, 500
                _.delay onClose2ndStage, 700
            else
                @$logo.addClass 'white'
                @$lines.addClass 'close'
                @app.footer.$keywords.addClass 'white'
                @app.timeline.scrollPossible = false;
                _.delay onOpen1stStage, 500
                _.delay onOpen2ndStage, 700

        showReturnLink: ->
            @$return.addClass 'visible'

        hideReturnLink: ->
            @$return.removeClass 'visible'

        showTimeline: ->
            @app.timeline.show()

    }
