define [

    'backbone'
    'slick'
    'views/preloader'
    'text!../templates/timeline.html'

], (Backbone, Slick, Preloader, template) ->

    'use strict'

    Backbone.View.extend {

        events: {
            'beforeChange .timeline': '_updateCovers'
            'click .item': '_itemOnClick'
            'click .slick-center': 'triggerCoversLinkClick'
        }

        template: _.template template

        initialize: (options) ->
            @model = options.model
            @app = options.app
            @scrollUpTime = 0
            @triggerOnChange = true
            @$el = @app.$el.find '#timeline'
            @render()

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

            @shown = true
            @scrollPossible = true
            @scrollTimedOut = true

            $(window).bind 'mousewheel', @onScroll.bind @

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

        update: (index, withCustomSpeed, specifiedSpeed) ->
            if withCustomSpeed
                @setSpeed index, specifiedSpeed

            if specifiedSpeed == 0
                @triggerOnChange = false

            @timeline.slick 'slickGoTo', index

            if specifiedSpeed == 0
                @triggerOnChange = true

            return

        fadeIn: ->
            @timeline.removeClass 'fade-out'

        fadeOut: ->
            @timeline.addClass 'fade-out'

        onScroll: (event) ->
            if !@scrollPossible or !@scrollTimedOut
                return

            delta = event.originalEvent.wheelDelta

            if delta >= 0
                element = if @app.$body.hasClass 'about' then @app.about.$el else @app.$itemWrapper

                if !@shown and element.scrollTop() == 0
                    @shown = true
                    @scrollTimedOut = false
                    @show()
            else
                if @shown
                    @shown = false
                    @scrollTimedOut = false
                    @triggerCoversLinkClick()

            timeOutScroll = =>
                @scrollTimedOut = true

            delay = if @app.model.isCurrentProject() then 1500 else 2500

            _.delay timeOutScroll, delay

        _itemOnClick: (event) ->
            $targetIndex = $(event.target).closest('.item').data 'slick-index'
            $currentCenterIndex = @$el.find('.item.slick-center').data 'slick-index'

            if $targetIndex != $currentCenterIndex
                @timeline.slick 'slickGoTo', $targetIndex

        _updateCovers: (event, slick, currentSlide, nextSlide) ->
            if currentSlide == nextSlide
                return

            @covers.slick 'slickGoTo', nextSlide

            if @triggerOnChange
                @trigger 'timeline-update', nextSlide

            @coversUpdated = true

            flagToDefault = =>
                @coversUpdated = false

            _.defer flagToDefault

        viewItem: ->
            onOpen = =>
                @preloader.fadeIn()
                @loadItem()
                setTimeout animatePreLoad, 500

            unless @coversUpdated
                @fadeOut()
                @app.navs.showReturnLink()
                @app.navs.returnLinkVisility = true;
                @preloader.updateText()
                @app.$body.addClass 'project'
                @app.$itemView.addClass 'project'
                _.delay onOpen, 500
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

                window.paceOptions = {
                    elements: {
                        selectors: ['.img']
                    },
                    startOnPageLoad: false
                }
                Pace.restart()
                $.ajax url, options
            else
                @app.$itemView.html @app.about.el

            $(document).on 'ajax-load-done', @slideItemUp.bind @

        show: ->
            delay = 0
            isAbout = @app.$body.hasClass 'about'
            isContacts = @app.$body.hasClass 'contacts-active'

            preloaderFadeOut = =>
                @app.menu.close()
                @preloader.fadeOut()
                @app.navs.$lines.removeClass 'white'

            timelineFadeIn = =>
                @app.trigger 'timeline-update'
                @fadeIn()
                @app.titleToDefault()
                @app.navs.hideReturnLink()
                @app.navs.returnLinkVisility = false;

            clearItemView = =>
                @app.$itemView.html ''
                @app.$itemView.removeClass 'project'

            if isAbout
                @toDefault()
                @app.about.hide()
                @scrollUpTime = @app.about.scrollUpTime
                delay = 1750
            else if isContacts
                @toDefault()
                @app.contacts.hide()
                @scrollUpTime = 0
                delay = 1100

            unless isAbout or isContacts
                _.delay @slideItemDown.bind(@), delay
                _.delay preloaderFadeOut, 500 + delay + @scrollUpTime

            _.delay timelineFadeIn, 1000 + delay + @scrollUpTime
            _.delay clearItemView, 1500 + delay + @scrollUpTime

        slideItemUp: ->
            @preloader.$descr.addClass 'show'
            @app.$itemView.addClass 'up'
            $(document).off 'ajax-load-done', @slideItemUp

        slideItemDown: ->
            slide = =>
                @preloader.$descr.removeClass 'show'
                @app.$itemView.removeClass 'up'
                @app.$body.removeClass 'project'

            itemTopOffset = @app.$itemWrapper.scrollTop()

            @scrollUpTime = if itemTopOffset == 0 then 0 else itemTopOffset

            @app.$itemWrapper.animate({
                scrollTop: 0
            }, @scrollUpTime);

            _.delay slide, @scrollUpTime

        setSpeed: (newIndex, specifiedSpeed) ->
            speed = if specifiedSpeed then specifiedSpeed else @app.model.getSpeedByIndex(newIndex)

            set = (newSpeed) =>
                @timeline.slick 'slickSetOption', 'speed', newSpeed
                @covers.slick 'slickSetOption', 'speed', newSpeed

            speedToDefault = =>
                set 1000

            set speed

            _.delay speedToDefault, speed + 500

        triggerCoversLinkClick: ->
            @covers.find('.slick-active').find('a.view-item')[0].click()

        reInitSliders: (onMenuOpened) ->
            @slideItemDown()
            @timeline.slick 'unslick'
            @covers.slick 'unslick'
            @initTimeline()
            @initCovers()
            @update @app.model.getCurrentIndex(), false, 0
            if onMenuOpened
                @fadeIn()

        toDefault: ->
            @preloader.fadeOut()
            @slideItemDown()
            @fadeOut()

            _.delay =>
                @app.$itemView.html ''
                @app.$itemView.removeClass 'project'
            , 1500
    }
