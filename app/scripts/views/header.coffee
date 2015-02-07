define [

    'backbone'
    'text!../templates/header.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        tagName: 'header'

        template: _.template(template)

        render: ->
            @$el.html @template()
            @

    }
