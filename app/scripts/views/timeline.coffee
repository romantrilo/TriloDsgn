define [

    'backbone'
    'slick'
    'views/preloader'
    'text!../templates/timeline.html'

], (Backbone, Slick, Preloader, template) ->

    'use strict'

    Backbone.View.extend {

        tagName: 'div'

        id: 'timeline'

        events: {
            'beforeChange .timeline': '_updateCovers'
            'click .slick-center': 'viewItem'
        }

        template: _.template template

        initialize: (options) ->
            @model = options.model
            @app = options.app
            @render()
            @scrollUpTime = 0

        render: ->
            @$el.html @template {
                items: @model
            }
            @initCovers()
            @initTimeline()
            @initPreloader()
            # this is the fix for slick messed up slider on initial load
            $(window).trigger 'resize'
            @

        initTimeline: ->
            @timeline = @$el.find '.timeline'
            options = {
                centerMode: true
                focusOnSelect: true
                infinite: false
                slidesToShow: 3
                speed: 1000
                swipeToSlide: true
                respondTo: 'slider'
                responsive: [
                    {
                        breakpoint: 1200
                        settings: {
                            slidesToShow: 1
                        }
                    }
                ]
                touchThreshold: 20
            }
            @timeline.slick options

        initCovers: ->
            options = {
                infinite: false
                slidesToShow: 1
                slidesToScroll: 1
                speed: 1000
                asNavFor: '.timeline'
                touchThreshold: 20
            }
            @covers = @$el.find '.covers'
            @covers.slick options

        initPreloader: ->
            @preloader = new Preloader {
                app: @app
            }
            @preloader.render()

        update: (index) ->
            @timeline.slick('slickGoTo', index)

        fadeIn: ->
            @timeline.removeClass 'fade-out'

        fadeOut: ->
            @timeline.addClass 'fade-out'

        _updateCovers: (event, slick, currentSlide, nextSlide) ->
            if currentSlide == nextSlide
                return

            @covers.slick 'slickGoTo', nextSlide
            @trigger 'timeline-update', nextSlide

            @coversUpdated = true

            flagToDefault = =>
                @coversUpdated = false

            _.defer flagToDefault

        viewItem: () ->
            onOpen = =>
                @preloader.fadeIn()
                @loadItem()
                setTimeout animatePreLoad, 500
#                on success download, do animations

            unless @coversUpdated
                @fadeOut()
                @app.header.showReturnLink()
                @app.header.returnLinkVisility = true;
                @preloader.updateText()
                setTimeout onOpen, 500

        loadItem: ->
            if @app.model.isCurrentProject()
                currentUrl = @app.model.getCurrentUrl()
                url = "html/items/#{currentUrl}.html"
                options = {
                    success: (html) =>
                        @app.$itemView.html html
                    error: =>
                        @app.show404()
                }
                $.ajax url, options
            else
                @app.$itemView.html @app.about.el

            $(document).on 'ajax-load-done', @slideItemUp.bind @

        show: ->
            preloaderFadeOut = =>
                @app.menu.close()
                @preloader.fadeOut()

            timelineFadeIn = =>
                @app.trigger 'timeline-update'
                @fadeIn()
                @app.header.hideReturnLink()
                @app.header.returnLinkVisility = false;

            @slideItemDown()
            _.delay preloaderFadeOut, 500 + @scrollUpTime
            _.delay timelineFadeIn, 1000 + @scrollUpTime

        slideItemUp: ->
            @app.$itemView.addClass 'up'
            $(document).off 'ajax-load-done', @slideItemUp


        slideItemDown: ->
            slide = =>
                @app.$itemView.removeClass 'up'

            itemTopOffset = @app.$itemWrapper.scrollTop()

            @scrollUpTime = if itemTopOffset == 0 then 0 else itemTopOffset / 2

            @app.$itemWrapper.animate({
                scrollTop: 0
            }, @scrollUpTime);
            _.delay slide, @scrollUpTime




    }
