define [

    'backbone'
    'views/timeline'
    'views/header'
    'views/footer'
    'views/menu'
    'text!../templates/app.html'

], (Backbone, Timeline, Header, Footer, Menu, template) ->

    'use strict'

    Backbone.View.extend {

        el: $ 'main'

        template: _.template(template)

        events: {
            'click .logo-clickable': 'showTimeline'
            'click .lines-button': 'toggleMenu'
        }

        initialize: ->
            @render()
            @initHeader()
            @initFooter()
            @initMenu()
            @$content = @$el.find '#content'

        render: ->
            @$el.html @template()

        initHeader: ->
            @$el.append new Header().render().$el

        initFooter: ->
            @$el.append new Footer().render().$el

        initMenu: ->
            @$el.append new Menu().render().$el

        toggleMenu: () ->
            $body = $ 'body'
            $btn = @$el.find '.lines-button'
            $lines = $btn.find('.lines')
            $logo = @$el.find '.logo h1'
            $contacts = @$el.find '.contacts'

            $body.toggleClass 'menu-opened'

            onOpen = ->
                $lines.addClass 'minus'
                $lines.addClass 'x'

            onClose = ->
                $lines.removeClass 'minus'
                $lines.removeClass 'close'

            logoOnClose = ->
                $logo.removeClass 'white'

            contactOnOpen = ->
                $contacts.addClass 'white'

            if $lines.hasClass 'x'
                $lines.removeClass 'x'
                $contacts.removeClass 'white'
                _.delay onClose, 500
                _.delay logoOnClose, 700

            else
                $logo.addClass 'white'
                $lines.addClass 'close'
                _.delay onOpen, 500
                _.delay contactOnOpen, 700


        updateTimeline: (index) ->
            if not @timeline
                @initTimeline()
            if index
                @timeline.update index
            else
                @timeline.update 0
            return

        showContacts: ->

        showAbout: ->

        show404: ->

        initTimeline: ->
            @closeMenu()
            @timeline = new Timeline {model: @model.get 'items', app: this}
            @$content.append @timeline.$el
            @listenTo @timeline, 'timeline-update', @triggerTimelineUpdate

        triggerTimelineUpdate: (index) ->
            @trigger 'timeline-update', index


        showTimeline: ->
            @closeMenu()
            @timeline.fadeIn()

        _isMenuOpened: ->
            $('body').hasClass('menu-opened')

        closeMenu: ->
            if @_isMenuOpened()
                @toggleMenu()

    }
