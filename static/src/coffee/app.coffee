window.React = React = require 'react'

{div, img, span} = React.DOM

Screenshot = React.createClass
  displayName: 'Screenshot'
  tickTime: 200
  tickMultiplier: 4
  getInitialState: ->
    if @props.type
      text: ''
    else
      text: @props.text
  componentDidMount: ->
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
  render: ->
    (div className: 'typing-screenshot',
      (img src: @props.src, alt: @props.alt)
      (span
        style:
          top: "#{@top}%"
          left: "#{@left}%"
        @state.text
      )
    )


for s in document.querySelectorAll('.screenshot')
  React.renderComponent(
    Screenshot
      src: s.getAttribute('data-src')
      alt: s.getAttribute('data-alt')
      text: s.getAttribute('data-text')
      left: s.getAttribute('data-left')
      top: s.getAttribute('data-top')
      type: s.getAttribute('data-type')
    s
  )

