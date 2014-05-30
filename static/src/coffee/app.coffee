window.React = React = require 'react'

{div, img, span} = React.DOM

Screenshot = React.createClass
  displayName: 'Screenshot'
  tickTime: 200
  tickMultiplier: 4
  getDefaultProps: ->
    color: '#333'
  getInitialState: ->
    if @props.type
      text: ''
    else
      text: @props.text
  componentDidMount: ->
    i = @refs.img.getDOMNode()
    i.onload = =>
      @computeTextPlacement()
      @setState hasLoaded: true

    if @props.type
      @textLength = @props.text.length
      setTimeout @tick, @tickTime
  componentWillMount: ->
    @top = parseInt(@props.top) + .1
    @left = parseInt(@props.left) + .3
  tick: ->
    if @state.text.length == @textLength
      nextText = ''
    else
      nextText = @props.text.slice(0, @state.text.length + 1)

    if nextText.length == @textLength
      timeout = @tickTime * @tickMultiplier
    else
      timeout = @tickTime

    @setState text: nextText
    setTimeout @tick, timeout
  computeTextPlacement: ->
    i = @refs.img.getDOMNode()

    @left = (parseInt(@props.left)) / i.naturalWidth * 100
    @top = parseInt(@props.top) / i.naturalHeight * 100

    @lineHeight = parseInt(@props.height) / i.naturalHeight * i.clientHeight
    @fontSize = @lineHeight * .6
  render: ->
    if not @state.hasLoaded
      internals = [(img ref: 'img', src: @props.src, alt: @props.alt)]
    else
      internals = [
        (img ref: 'img', src: @props.src, alt: @props.alt),
        (span
          style:
            top: "#{@top}%"
            left: "#{@left}%"
            fontSize: @fontSize
            lineHeight: "#{@lineHeight}px"
            color: @props.color
          @state.text
        )
      ]

    (div className: 'typing-screenshot', internals...)

for s in document.querySelectorAll('.screenshot')
  React.renderComponent(
    Screenshot
      src: s.getAttribute('data-src')
      alt: s.getAttribute('data-alt')
      text: s.getAttribute('data-text')
      left: s.getAttribute('data-left')
      top: s.getAttribute('data-top')
      height: s.getAttribute('data-height')
      type: s.getAttribute('data-type')
    s
  )

