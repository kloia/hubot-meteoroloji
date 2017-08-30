# hubot-meteoroloji

A hubot script that presents daily weather forecast from Turkish Meteoroloji Genel Müdürlüğü when someone typed `hava`

See [`src/meteoroloji.coffee`](src/meteoroloji.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-meteoroloji --save`

Then add **hubot-meteoroloji** to your `external-scripts.json`:

```json
[
  "hubot-meteoroloji"
]
```

## Sample Interaction

```
user1>> hubot hava
hubot>> @user1 bugün gökgürültülü sağanak yağışlı 20° - 23°, yarın parçalı bulutlu 18° - 25°.
```

## NPM Module

https://www.npmjs.com/package/hubot-meteoroloji
