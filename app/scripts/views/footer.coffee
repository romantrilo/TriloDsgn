define [

    'backbone'
    'text!../templates/footer.html'

], (Backbone, template) ->

    'use strict'

    Backbone.View.extend {

        tagName: 'footer'

        template: _.template(template)

        initialize: (options) ->
            @app = options.app

        render: ->
            @$el.html @template()
            @$contacts = @$el.find '.contacts'
            @$keywords = @$el.find '.key-words'
            @

        whiteContacts: ->
            @$contacts.addClass 'white'

        unWhiteContacts: ->
            @$contacts.removeClass 'white'

        whiteKeyWords: ->
            @$keywords.addClass 'white'

        unWhiteKeyWords: ->
            @$keywords.removeClass 'white'
    }
