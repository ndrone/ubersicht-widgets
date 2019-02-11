iconSet = "Climacons"
numberOfDays = 3 # max of 8 days
numberOfAlerts = 1
latitude = "34.579491"
longitude = "-86.941597"
apiKey = "your api key from forecast-io"
showForecast = 1
debug = 0

command: "curl -s 'https://api.forecast.io/forecast/#{apiKey}/#{latitude},#{longitude}?exclude=minutely,hourly,flags'"

refreshFrequency: '15m'

style: """
  top: 10px
  right: 10px
  font-family: Helvetica Neue
  font-weight: bold
  color: #fff

  .weather
    display: flex
  .text-container
    display: flex
    flex-direction: column
    justify-content: center
  .conditions
    font-size: 20px
  .time
    font-size: 12px
    font-weight: 800
    padding-bottom: 7px
  .forecast
    font-size: 14px
    font-weight: 800
    max-width: 500px
  .date
    width: 125px
    float: left
  .temp
    width: 60px
    float: left
  .desc
    float: left
  img
    height: 90px
"""

render: -> """
  <div class="weather">
    <div class="image"></div>
    <div class="text-container">
      <div class="conditions"></div>
      <div class="time"></div>
      <div class="forecast"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  weatherData = JSON.parse(output)
  if debug
    console.log(weatherData)
  # image
  if weatherData.hasOwnProperty('alerts')
    $(domEl).find('.image').html('<img src=' + "weather-forecast-io.widget/images/" + iconSet + "/severe.png" + '>')
  else
    $(domEl).find('.image').html('<img src=' + "weather-forecast-io.widget/images/" + iconSet + "/" + weatherData.currently.icon + ".png"+ '>')

  # time of last update
  time = new Date(weatherData.currently.time * 1000).toLocaleDateString('en-US', { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' });
  $(domEl).find('.time').html(time)

  # current conditions
  current = weatherData.currently.summary + ", " + Math.round(weatherData.currently.temperature) + "°"
  $(domEl).find('.conditions').html(current)

  # forecast
  if showForecast == 1 || weatherData.hasOwnProperty('alerts')
    forecast = ""
    if weatherData.hasOwnProperty('alerts')
      if numberOfAlerts < weatherData.alerts.length
        maxAlerts = numberOfAlerts
      else
        maxAlerts = weatherData.alerts.length
      for i in [0..maxAlerts-1]
        forecast = forecast + "<div style='white-space: pre-wrap;'>" + weatherData.alerts[i].title + " Expires " + new Date(weatherData.alerts[i].expires * 1000).toLocaleDateString('en-US', { weekday: 'short', hour: 'numeric', minute: 'numeric' });"</div>"
        forecast = forecast + "<br>" + weatherData.alerts[i].description + "<p>"
        forecast = forecast.replace(/\n/g, " ")
        forecast = forecast.replace(/\*/g, "\n* ")
    else
      if numberOfDays > 8
        maxDays = 8
      else
        maxDays = numberOfDays
      for i in [0..numberOfDays-1]
        forecastDate = "<div class=date>" + new Date(weatherData.daily.data[i].time * 1000).toLocaleDateString('en-US', {weekday: 'short'}) + "</div>"
        forecastTemps = "<div class=temp>" + Math.round(weatherData.daily.data[i].temperatureMax) + "° / " + Math.round(weatherData.daily.data[i].temperatureMin)+ "°</div>"
        forecastDescr = "<div class=desc>" + weatherData.daily.data[i].summary + "</div><br style=clear: left;>"
        forecast = forecast + forecastDate + forecastTemps + forecastDescr
    forecast = forecast.replace(/ +/g, " ")
    $(domEl).find('.forecast').html(forecast)
