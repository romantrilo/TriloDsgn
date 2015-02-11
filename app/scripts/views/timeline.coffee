define [

    'backbone'
    'slick'
    'text!../templates/timeline.html'

], (Backbone, Slick, template) ->

    'use strict'

    Backbone.View.extend {

        tagName: 'div'

        id: 'timeline'

        events: {
            'beforeChange .timeline': '_updateCovers'
            'click .item': '_itemOnClick'
            'click .slick-center': '_viewItem'
            'click .view-item': '_viewItem'
        }

        template: _.template template

        initialize: ->
            @render()

        render: ->
            @$el.html @template {items: @model}
            @initCovers()
            @initTimeline()
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

        update: (index) ->
            @timeline.slick('slickGoTo', index)

        fadeIn: ->
            @$el.find('.timeline').removeClass 'fade-out'

        _updateCovers: (event, slick, currentSlide, nextSlide) ->
            @covers.slick 'slickGoTo', nextSlide
            @trigger 'timeline-update', nextSlide

        _viewItem: ->
            @$el.find('.timeline').addClass 'fade-out'
#            TODO

        _itemOnClick: (event) ->
            $targetItem = $(event.target).closest('.item')

            if $targetItem.hasClass('slick-center')
                return

            $targetIndex = $targetItem.data 'slick-index'
            @timeline.slick 'slickGoTo', $targetIndex

    }