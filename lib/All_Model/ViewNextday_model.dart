// class weatherView {
//   String? cod;
//   int? message;
//   int? cnt;
//   List<List>? list;
//   City? city;
//
//   weatherView({this.cod, this.message, this.cnt, this.list, this.city});
//
//   weatherView.fromJson(Map<String, dynamic> json) {
//     cod = json['cod'];
//     message = json['message'];
//     cnt = json['cnt'];
//     if (json['list'] != null) {
//       list = <List>[];
//       json['list'].forEach((v) {
//         list!.add(new List.fromJson(v));
//       });
//     }
//     city = json['city'] != null ? new City.fromJson(json['city']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cod'] = this.cod;
//     data['message'] = this.message;
//     data['cnt'] = this.cnt;
//     if (this.list != null) {
//       data['list'] = this.list!.map((v) => v.toJson()).toList();
//     }
//     if (this.city != null) {
//       data['city'] = this.city!.toJson();
//     }
//     return data;
//   }
// }
//
// class List {
//   int? dt;
//   Main? main;
//   List<Weather>? weather;
//   Clouds? clouds;
//   Wind? wind;
//   int? visibility;
//   int? pop;
//   Sys? sys;
//   String? dtTxt;
//
//   List(
//       {this.dt,
//         this.main,
//         this.weather,
//         this.clouds,
//         this.wind,
//         this.visibility,
//         this.pop,
//         this.sys,
//         this.dtTxt});
//
//   List.fromJson(Map<String, dynamic> json) {
//     dt = json['dt'];
//     main = json['main'] != null ? new Main.fromJson(json['main']) : null;
//     if (json['weather'] != null) {
//       weather = <Weather>[] as List?;
//       json['weather'].forEach((v) {
//         weather!.add(Weather.fromJson(v));
//       });
//     }
//     clouds =
//     json['clouds'] != null ? new Clouds.fromJson(json['clouds']) : null;
//     wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
//     visibility = json['visibility'];
//     pop = json['pop'];
//     sys = json['sys'] != null ? new Sys.fromJson(json['sys']) : null;
//     dtTxt = json['dt_txt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['dt'] = this.dt;
//     if (this.main != null) {
//       data['main'] = this.main!.toJson();
//     }
//     if (this.weather != null) {
//       data['weather'] = this.weather!.map((v) => v.toJson()).toList();
//     }
//     if (this.clouds != null) {
//       data['clouds'] = this.clouds!.toJson();
//     }
//     if (this.wind != null) {
//       data['wind'] = this.wind!.toJson();
//     }
//     data['visibility'] = this.visibility;
//     data['pop'] = this.pop;
//     if (this.sys != null) {
//       data['sys'] = this.sys!.toJson();
//     }
//     data['dt_txt'] = this.dtTxt;
//     return data;
//   }
// }
//
// class Main {
//   double? temp;
//   double? feelsLike;
//   double? tempMin;
//   double? tempMax;
//   int? pressure;
//   int? seaLevel;
//   int? grndLevel;
//   int? humidity;
//   double? tempKf;
//
//   Main(
//       {this.temp,
//         this.feelsLike,
//         this.tempMin,
//         this.tempMax,
//         this.pressure,
//         this.seaLevel,
//         this.grndLevel,
//         this.humidity,
//         this.tempKf});
//
//   Main.fromJson(Map<String, dynamic> json) {
//     temp = json['temp'];
//     feelsLike = json['feels_like'];
//     tempMin = json['temp_min'];
//     tempMax = json['temp_max'];
//     pressure = json['pressure'];
//     seaLevel = json['sea_level'];
//     grndLevel = json['grnd_level'];
//     humidity = json['humidity'];
//     tempKf = json['temp_kf'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['temp'] = this.temp;
//     data['feels_like'] = this.feelsLike;
//     data['temp_min'] = this.tempMin;
//     data['temp_max'] = this.tempMax;
//     data['pressure'] = this.pressure;
//     data['sea_level'] = this.seaLevel;
//     data['grnd_level'] = this.grndLevel;
//     data['humidity'] = this.humidity;
//     data['temp_kf'] = this.tempKf;
//     return data;
//   }
// }
//
// class Weather {
//   int? id;
//   String? main;
//   String? description;
//   String? icon;
//
//   Weather({this.id, this.main, this.description, this.icon});
//
//   Weather.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     main = json['main'];
//     description = json['description'];
//     icon = json['icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['main'] = this.main;
//     data['description'] = this.description;
//     data['icon'] = this.icon;
//     return data;
//   }
// }
//
// class Clouds {
//   int? all;
//
//   Clouds({this.all});
//
//   Clouds.fromJson(Map<String, dynamic> json) {
//     all = json['all'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['all'] = this.all;
//     return data;
//   }
// }
//
// class Wind {
//   double? speed;
//   int? deg;
//   double? gust;
//
//   Wind({this.speed, this.deg, this.gust});
//
//   Wind.fromJson(Map<String, dynamic> json) {
//     speed = json['speed'];
//     deg = json['deg'];
//     gust = json['gust'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['speed'] = this.speed;
//     data['deg'] = this.deg;
//     data['gust'] = this.gust;
//     return data;
//   }
// }
//
// class Sys {
//   String? pod;
//
//   Sys({this.pod});
//
//   Sys.fromJson(Map<String, dynamic> json) {
//     pod = json['pod'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pod'] = this.pod;
//     return data;
//   }
// }
//
// class City {
//   int? id;
//   String? name;
//   Coord? coord;
//   String? country;
//   int? population;
//   int? timezone;
//   int? sunrise;
//   int? sunset;
//
//   City(
//       {this.id,
//         this.name,
//         this.coord,
//         this.country,
//         this.population,
//         this.timezone,
//         this.sunrise,
//         this.sunset});
//
//   City.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     coord = json['coord'] != null ? new Coord.fromJson(json['coord']) : null;
//     country = json['country'];
//     population = json['population'];
//     timezone = json['timezone'];
//     sunrise = json['sunrise'];
//     sunset = json['sunset'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     if (this.coord != null) {
//       data['coord'] = this.coord!.toJson();
//     }
//     data['country'] = this.country;
//     data['population'] = this.population;
//     data['timezone'] = this.timezone;
//     data['sunrise'] = this.sunrise;
//     data['sunset'] = this.sunset;
//     return data;
//   }
// }
//
// class Coord {
//   double? lat;
//   double? lon;
//
//   Coord({this.lat, this.lon});
//
//   Coord.fromJson(Map<String, dynamic> json) {
//     lat = json['lat'];
//     lon = json['lon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['lat'] = this.lat;
//     data['lon'] = this.lon;
//     return data;
//   }
// }

import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {

  Weather({

    required this.data,

    required this.warnings,

  });

  Data data;

  List<Warning> warnings;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(

    data: Data.fromJson(json["data"]),

    warnings: List<Warning>.from(

        json["warnings"].map((x) => Warning.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {

    "data": data.toJson(),

    "warnings": List<dynamic>.from(warnings.map((x) => x.toJson())),

  };

}

class Data {

  Data({

    required this.timelines,

  });

  List<Timeline> timelines;

  factory Data.fromJson(Map<String, dynamic> json) => Data(

    timelines: List<Timeline>.from(

        json["timelines"].map((x) => Timeline.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {

    "timelines": List<dynamic>.from(timelines.map((x) => x.toJson())),

  };

}

class Timeline {

  Timeline({

    required this.timestep,

    required this.startTime,

    required this.endTime,

    required this.intervals,

  });

  String timestep;

  DateTime startTime;

  DateTime endTime;

  List<Interval> intervals;

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(

    timestep: json["timestep"],

    startTime: DateTime.parse(json["startTime"]),

    endTime: DateTime.parse(json["endTime"]),

    intervals: List<Interval>.from(

        json["intervals"].map((x) => Interval.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {

    "timestep": timestep,

    "startTime": startTime.toIso8601String(),

    "endTime": endTime.toIso8601String(),

    "intervals": List<dynamic>.from(intervals.map((x) => x.toJson())),

  };

}

class Interval {

  Interval({

    required this.startTime,

    required this.values,

  });

  DateTime startTime;

  Values values;

  factory Interval.fromJson(Map<String, dynamic> json) => Interval(

    startTime: DateTime.parse(json["startTime"]),

    values: Values.fromJson(json["values"]),

  );

  Map<String, dynamic> toJson() => {

    "startTime": startTime.toIso8601String(),

    "values": values.toJson(),

  };

}

class Values {

  Values({

    required this.windSpeed,

    required this.windDirection,

    required this.temperature,

    required this.temperatureApparent,

    required this.weatherCode,

    required this.humidity,

    required this.visibility,

    required this.dewPoint,

    required this.precipitationType,

    required this.cloudCover,

  });

  double windSpeed;

  double windDirection;

  double temperature;

  double temperatureApparent;

  int weatherCode;

  double humidity;

  double visibility;

  double dewPoint;

  int precipitationType;

  double cloudCover;

  factory Values.fromJson(Map<String, dynamic> json) => Values(

    windSpeed: json["windSpeed"].toDouble(),

    windDirection: json["windDirection"].toDouble(),

    temperature: json["temperature"].toDouble(),

    temperatureApparent: json["temperatureApparent"].toDouble(),

    weatherCode: json["weatherCode"],

    humidity: json["humidity"].toDouble(),

    visibility: json["visibility"].toDouble(),

    dewPoint: json["dewPoint"].toDouble(),

    precipitationType: json["precipitationType"],

    cloudCover: json["cloudCover"].toDouble(),

  );

  Map<String, dynamic> toJson() => {

    "windSpeed": windSpeed,

    "windDirection": windDirection,

    "temperature": temperature,

    "temperatureApparent": temperatureApparent,

    "weatherCode": weatherCode,

    "humidity": humidity,

    "visibility": visibility,

    "dewPoint": dewPoint,

    "precipitationType": precipitationType,

    "cloudCover": cloudCover,

  };

}

class Warning {

  Warning({

    required this.code,

    required this.type,

    required this.message,

  });

  int code;

  String type;

  String message;

  factory Warning.fromJson(Map<String, dynamic> json) => Warning(

    code: json["code"],

    type: json["type"],

    message: json["message"],

  );

  Map<String, dynamic> toJson() => {

    "code": code,

    "type": type,

    "message": message,

  };

}
