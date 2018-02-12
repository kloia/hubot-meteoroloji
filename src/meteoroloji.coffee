# Description
#   A hubot script that presents daily weather forecast from Turkish Meteoroloji Genel Müdürlüğü when someone typed `hava`
#
# Configuration:
#   HUBOT_METEOROLOJI_CITY
#   HUBOT_METEOROLOJI_DISTRICT
#
# Commands:
#   weather - Daily weather forecast
#   forecast - Alias for weather
#   hava - Alias for weather
#
# Notes:
#
# Author:
#   Mehmet Ali Aydın <maaydin@gmail.com>
api_url = "http://212.175.180.28/api"

events = {
  "A": "açık",
  "AB": "az bulutlu",
  "PB": "parçalı bulutlu",
  "CB": "çok bulutlu",
  "HY": "hafif yağmurlu",
  "Y": "yağmurlu",
  "KY": "kuvvetli yağmurlu",
  "KKY": "karla karışık yağmurlu",
  "HKY": "hafif kar yağışlı",
  "K": "kar yağışlı",
  "KYK": "yoğun kar yağışlı",
  "HSY": "hafif sağanak yağışlı",
  "SY": "sağanak yağışlı",
  "KSY": "kuvvetli sağanak yağışlı",
  "MSY": "mevzi sağanak yağışlı",
  "DY": "dolu",
  "GSY": "gökgürültülü sağanak yağışlı",
  "KGSY": "kuvvetli gökgürültülü sağanak yağışlı",
  "SIS": "sisli",
  "PUS": "puslu",
  "DNM": "dumanlı",
  "KF": "toz veya kum fırtınası",
  "R": "rüzgarlı",
  "GKR": "güneyli kuvvetli rüzgar",
  "KKR": "kuzeyli kuvvetli rüzgar",
  "SCK": "sıcak",
  "SGK": "soğuk"
}

event_emojis = {
  "A": ":sunny:",
  "AB": ":mostly_sunny:",
  "PB": ":partly_sunny:",
  "CB": ":barely_sunny:",
  "HY": ":partly_sunny_rain:",
  "Y": ":rain_cloud:",
  "KY": ":rain_cloud:",
  "KKY": ":rain_cloud:",
  "HKY": ":snow_cloud:",
  "K": ":snow_cloud:",
  "KYK": ":snow_cloud:",
  "HSY": ":rain_cloud:",
  "SY": ":thunder_cloud_and_rain:",
  "KSY": ":thunder_cloud_and_rain:",
  "MSY": ":thunder_cloud_and_rain:",
  "DY": ":thunder_cloud_and_rain:",
  "GSY": ":thunder_cloud_and_rain:",
  "KGSY": ":thunder_cloud_and_rain:",
  "SIS": ":fog:",
  "PUS": ":fog:",
  "DNM": ":tornado:",
  "KF": ":tornado:",
  "R": ":wind_blowing_face:",
  "GKR": ":wind_blowing_face:",
  "KKR": ":wind_blowing_face:",
  "SCK": ":sun_with_face:",
  "SGK": ":snowflake:"
}

city = process.env.HUBOT_METEOROLOJI_CITY ? "istanbul"
district = process.env.HUBOT_METEOROLOJI_DISTRICT ? "sariyer"

forecast = (msg) ->
  place_url = api_url + "/merkezler?il=#{city}&ilce=#{district}"
  req = msg.http(place_url)
  req.get() (err, res, body) ->
    if err
      msg.send "@#{msg.message.user.name} #{city} #{district} için hava durumu tahminlerini şu an sunamıyorum"
    else
      response = JSON.parse body
      forecast_id = response[0]["gunlukTahminIstNo"]
      forecast_url = api_url + "/tahminler/gunluk?istno=#{forecast_id}"
      req2 = msg.http(forecast_url)
      req2.get() (err2, res2, body2) ->
        if err2
          msg.send "@#{msg.message.user.name} #{city} #{district} için hava durumu tahminlerini şu an sunamıyorum"
        else
          response = JSON.parse body2
          today_min = response[0]["enDusukGun1"]
          today_max = response[0]["enYuksekGun1"]
          today_event = events[response[0]["hadiseGun1"]]
          today_event_emoji = event_emojis[response[0]["hadiseGun1"]]
          tomorrow_min = response[0]["enDusukGun2"]
          tomorrow_max = response[0]["enYuksekGun2"]
          tomorrow_event = events[response[0]["hadiseGun2"]]
          tomorrow_event_emoji = event_emojis[response[0]["hadiseGun2"]]
          msg.send "@#{msg.message.user.name} *#{city}/#{district}* bugün #{today_event} *#{today_min}° - #{today_max}°* #{today_event_emoji} , yarın #{tomorrow_event} *#{tomorrow_min}° - #{tomorrow_max}°* #{tomorrow_event_emoji}"
module.exports = (robot) ->
  robot.hear /.*(hava|weather|forecast).*/i, (msg) ->
    forecast msg
