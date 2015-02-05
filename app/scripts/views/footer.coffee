define [

    'backbone'
    'text!../templates/footer.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        className: 'footer'

        template: _.template(template)

        render: ->
            @$el.html @template()
            @

    }
