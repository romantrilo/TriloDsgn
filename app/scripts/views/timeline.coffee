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

        update: (index, withCustomSpeed) ->
            if withCustomSpeed
                @setSpeed index
            @timeline.slick 'slickGoTo', index
            return

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

            unless @coversUpdated
                @fadeOut()
                @app.header.showReturnLink()
                @app.header.returnLinkVisility = true;
                @preloader.updateText()
                if @app.model.isCurrentProject()
                    @app.$itemView.addClass 'project'
                else
                    @app.$itemView.addClass 'about'
                setTimeout onOpen, 500
                return

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
            delay = 0

            hideBlackRectangular = =>
                @app.$body.removeClass 'about'

            preloaderFadeOut = =>
                @app.menu.close()
                @preloader.fadeOut()
                @app.header.$lines.removeClass 'white'

            timelineFadeIn = =>
                @app.trigger 'timeline-update'
                @fadeIn()
                @app.header.hideReturnLink()
                @app.header.returnLinkVisility = false;

            clearItemView = =>
                @app.$itemView.html ''
                @app.$body.removeClass 'about'
                @app.$body.removeClass 'about'
                @app.$itemView.removeClass 'about'
                @app.$itemView.removeClass 'project'

            unless @app.model.isCurrentProject()
                delay = 1000
                hideBlackRectangular()

            console.log delay

            _.delay @slideItemDown.bind(@), delay
            _.delay preloaderFadeOut, delay + @scrollUpTime
            _.delay timelineFadeIn, 1000 + delay + @scrollUpTime
            _.delay clearItemView, 1500 + delay + @scrollUpTime

        slideItemUp: ->
            showBlackRectangle = =>
                @app.$body.addClass 'about'

            @app.$itemView.addClass 'up'
            $(document).off 'ajax-load-done', @slideItemUp

            unless @app.model.isCurrentProject()
                _.delay showBlackRectangle, 1000


        slideItemDown: ->
            slide = =>
                @app.$itemView.removeClass 'up'

            itemTopOffset = @app.$itemWrapper.scrollTop()

            @scrollUpTime = if itemTopOffset == 0 then 0 else itemTopOffset / 2

            @app.$itemWrapper.animate({
                scrollTop: 0
            }, @scrollUpTime);
            _.delay slide, @scrollUpTime

        setSpeed: (newIndex) ->
            speed = @app.model.getSpeedByIndex(newIndex)

            set = (newSpeed) =>
                @timeline.slick 'slickSetOption', 'speed', newSpeed
                @covers.slick 'slickSetOption', 'speed', newSpeed

            speedToDefault = =>
                set 1000

            set speed

            _.delay speedToDefault, speed + 500


    }
