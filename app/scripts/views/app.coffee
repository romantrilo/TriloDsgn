define [

    'backbone'
    'views/timeline'
    'views/navs'
    'views/menu'
    'views/about'
    'views/contacts'
    'text!../templates/app.html'

], (Backbone, Timeline, Navs, Menu, About, Contacts, template) ->

    'use strict'

    Backbone.View.extend {

        template: _.template(template)

        initialize: () ->
            @$el = $ 'main'
            @render()
            @initElements()
            @initNavs()
            @initMenu()
            @initAbout()
            @initContacts()

        initElements: ->
            @$body = $ 'body'
            @$blackRec = @$el.find '#black_rec'
            @$itemWrapper = @$el.find '#item'
            @$itemView = @$itemWrapper.find '.item-view'
            @$layers = @$el.find '.layer'

        render: ->
            @$el.html @template()

        initNavs: ->
            @navs = new Navs {
                app: @
            }

        initMenu: ->
            @menu = new Menu {
                app: @
            }

        initTimeline: ->
            if @menu.isOpened()
                @menu.close()

            @timeline = new Timeline {
                model: @model.get 'items'
                app: @
            }

            @listenTo @timeline, 'timeline-update', @triggerTimelineUpdate

        triggerTimelineUpdate: (index) ->
            @trigger 'timeline-update', index

        initAbout: ->
            @about = new About {
                app: @
            }

        initContacts: ->
            @contacts = new Contacts {
                app: @
            }

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

        show404: ->

    }
