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

        initialize: ->
            @render()
            @initHeader()
            @initFooter()
            @initMenu()
            @$content = @$el.find '#content'

        render: ->
            @$el.html @template()

        initHeader: ->
            @header = new Header {
                app: @
            }
            @$el.append @header.render().$el

        initFooter: ->
            @footer = new Footer {
                app: @
            }
            @$el.append @footer.render().$el

        initMenu: ->
            @menu = new Menu {
                app: @
            }
            @$el.append @menu.render().$el

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
            @menu.close()
            @timeline = new Timeline {
                model: @model.get 'items'
                app: @
            }
            @$content.append @timeline.$el
            @listenTo @timeline, 'timeline-update', @triggerTimelineUpdate

        triggerTimelineUpdate: (index) ->
            @trigger 'timeline-update', index

    }
