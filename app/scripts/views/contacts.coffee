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

        render: ->
            @$el.html @template()
            @

    }
