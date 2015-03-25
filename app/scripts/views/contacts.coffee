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

        render: ->
            @$el.html @template()
            @

        show: ->
            delay = 0

            @app.timeline.scrollPossible = false

            if @app.menu.isOpened()
                @app.menu.close()
                delay = 1000

            _.delay =>
                @app.timeline.$el.hide 0
                @app.$itemWrapper.hide 0
                @app.$blackRec.addClass 'contacts-active'
                @$el.show 0
                @$arrow.addClass 'mobile-moving'
                @$arrow.addClass 'right'
                @$email.find('.background').addClass 'show'
                _.delay =>
                    span = @$email.find 'span'
                    span.addClass 'show'
                , 700
            , delay

    }
