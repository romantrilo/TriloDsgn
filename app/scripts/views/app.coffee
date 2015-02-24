define [

    'backbone'
    'views/timeline'
    'views/header'
    'views/footer'
    'views/menu'
    'views/about'
    'text!../templates/app.html'

], (Backbone, Timeline, Header, Footer, Menu, About, template) ->

    'use strict'

    Backbone.View.extend {

        el: $ 'main'

        template: _.template(template)

        initialize: () ->
            @render()
            @initHeader()
            @initFooter()
            @initMenu()
            @initAbout()
            @$content = @$el.find '#content'
            @$itemWrapper = @$el.find '#item'
            @$itemView = @$itemWrapper.find '.item-view'


        render: ->
            @$el.html @template()

        initHeader: ->
            @header = new Header {
                app: @
            }
            @$el.prepend @header.render().$el

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

        initAbout: ->
            @about = new About {
                app: @
            }
            @about.render()

        updateTimeline: (index) ->
            if not @timeline
                @initTimeline()
            if index
                @timeline.update index
            else
                @timeline.update 0
            return

        showContacts: ->

        showItem: ->
            if @menu._isOpened()
#                TODO
            else
                @timeline.viewItem()
            return

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
