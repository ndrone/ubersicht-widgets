command: "pmset -g batt | grep -o '[0-9]*%; [a-z]*'"

refreshFrequency: 30000

style: """
  top: 20px
  left: 225px
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    width: 80px
    max-width: 120px
    text-shadow: 0 0 0px rgba(#000, 0.0)
    background: rgba(#fff, 0.0)
    padding: 4px 6px 4px 6px

    &:after
      content: 'BATTERY'
      position: absolute
      left: 5
      top: -14px
      font-size: 14px
      font-weight: 800

  .percent
    font-size: 24px
    font-weight: 800
    margin: 0

  .status
    padding: 0
    margin: 0
    font-size: 14px
    font-weight: 800
    max-width: 100%
    color: #fff
    text-overflow: ellipsis
    text-shadow: none

"""


render: -> """
  <div><p class='percent'></p><p class='status'></p></div>
"""

update: (output, domEl) ->
  values = output.split(";")
  percent = values[0]
  status = values[1]
  div     = $(domEl)

  div.find('.percent').html(percent)
  div.find('.status').html(status)

