define [

    'backbone'
    'text!../templates/header.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        className: 'header'

        template: _.template(template)

        render: ->
            @$el.html @template()
            @

    }
