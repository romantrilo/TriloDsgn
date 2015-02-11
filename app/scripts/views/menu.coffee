define [

    'backbone'
    'views/footer'
    'text!../templates/menu.html'

], (Backbone, Footer, template) ->

    'use strict'

    Backbone.View.extend {

        className: 'menu'

        template: _.template(template)

        render: ->
            @$el.html @template()
#            @$el.append new Footer().render().$el
            @

    }