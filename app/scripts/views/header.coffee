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
            @return = @$el.find '.return'
            @

        toggleMenu: () ->
            $body = $ 'body'
            $body.toggleClass 'menu-opened'

            onOpen = =>
                @$lines.addClass 'minus'
                @$lines.addClass 'x'
                @hideReturnLink()

            onClose = =>
                @$lines.removeClass 'minus'
                @$lines.removeClass 'close'

            logoOnClose = =>
                @$logo.removeClass 'white'

            contactOnOpen = =>
                @app.footer.whiteContacts()

            if @$lines.hasClass 'x'
                @$lines.removeClass 'x'
                @app.footer.unWhiteContacts()
                if @app.header.returnLinkVisility
                    @app.header.showReturnLink()
                _.delay onClose, 500
                _.delay logoOnClose, 700
            else
                @$logo.addClass 'white'
                @$lines.addClass 'close'
                _.delay onOpen, 500
                _.delay contactOnOpen, 700

        showReturnLink: ->
            @return.addClass 'visible'

        hideReturnLink: ->
            @return.removeClass 'visible'

        showTimeline: ->
            @app.timeline.show()

    }
