# Description
#   A hubot script that presents daily weather forecast from Turkish Meteoroloji Genel Müdürlüğü when someone typed `hava`
#
# Configuration:
#   HUBOT_METEOROLOHUJI_CITY
#   HUBOT_METEOROLOHUJI_DISTRICT
#
# Commands:
#   hava - <Hava durumu raporu>
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

city = process.env.HUBOT_METEOROLOHUJI_CITY ? "istanbul"
district = process.env.HUBOT_METEOROLOHUJI_DISTRICT ? "sariyer"

forecast = (msg) ->
   serviceRepoName = msg.match[3]
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
               tomorrow_min = response[0]["enDusukGun2"]
               tomorrow_max = response[0]["enYuksekGun2"]
               tomorrow_event = events[response[0]["hadiseGun2"]]
               msg.send "@#{msg.message.user.name} bugün #{today_event} #{today_min}° - #{today_max}°, yarın #{tomorrow_event} #{tomorrow_min}° - #{tomorrow_max}°."
module.exports = (robot) ->
   robot.hear /.*hava.*/i, (msg) ->
      forecast msg
