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
            @$body = $ 'body'
            @$content = @$el.find '#content'
            @$blackRec = @$el.find '#black_rec'
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

        showContacts: ->

        showItem: ->
            if @menu.isOpened()
                @header.$menuBtn.trigger('click');
                _.delay( =>
                    @timeline.viewItem()
                , 1000)
            else
                @timeline.viewItem()
            return

        showAbout: ->
            if @menu.isOpened()
#                TODO
            else
#                TODO


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
