import 'dart:convert';

class CoordModel{
  num lon;
  num lat;

  CoordModel({required this.lat,required this.lon});

  factory CoordModel.fromJson(Map<String,dynamic> json){
    return CoordModel(
        lat: json["lat"],
        lon: json["lon"]
    );
  }
}

class WeatherItemModel{
  int id;
  String description;
  String icon;
  String main;

  WeatherItemModel({required this.id,required this.description,required this.icon,required this.main});

  factory WeatherItemModel.fromJson(Map<String,dynamic> json){
    return WeatherItemModel(
    id: json["id"],
    description: json["description"],
    icon: json["icon"],
    main: json["main"]
  );
  }
}

class MainModel{
  num feels_like;
  num? grnd_level;
  num humidity;
  num pressure;
  num? sea_level;
  num temp;
  num temp_max;
  num temp_min;

  MainModel({required this.feels_like,this.grnd_level,required this.humidity,required this.pressure,this.sea_level,required this.temp,required this.temp_max,required this.temp_min});

  factory MainModel.fromJson(Map<String,dynamic> json){
    return MainModel(
        feels_like: json["feels_like"],
        grnd_level: json["grnd_level"],
        humidity: json["humidity"],
        pressure: json["pressure"],
        sea_level: json["sea_level"],
        temp: json["temp"],
        temp_max: json["temp_max"],
        temp_min: json["temp_min"]
    );
  }
}

class WindModel{
  int deg;
  num? gust;
  num speed;

  WindModel({required this.deg,this.gust,required this.speed});

  factory WindModel.fromJson(Map<String, dynamic> json){
    return WindModel(
    deg: json["deg"],
    gust: json["gust"],
    speed: json["speed"]
  );
  }
}

class CloudsModel{
  int all;
  CloudsModel({required this.all});

  factory CloudsModel.fromJson(Map<String,dynamic> json){
    return CloudsModel(all: json["all"]);
  }
}

class SysModel{
  String country;
  int sunrise;
  int sunset;
  
  SysModel({required this.country,required this.sunrise,required this.sunset});
  
  factory SysModel.fromJson(Map<String,dynamic> json){
    return SysModel(
    country: json["country"],
    sunrise: json["sunrise"],
    sunset: json["sunset"]
  );
  }
}

class WeatherDetailsModel{
  CoordModel coord;
  List<WeatherItemModel> weather;
  String base;
  MainModel main;
  int visibility;
  WindModel wind;
  CloudsModel clouds;
  int dt;
  SysModel sys;
  int timezone;
  int id;
  String name;
  int cod;

  WeatherDetailsModel({required this.coord,required this.weather,required this.base,required this.main,required this.visibility,required this.wind,required this.clouds,required this.dt,required this.sys,required this.timezone,required this.id,required this.name,required this.cod});

  factory WeatherDetailsModel.fromJson(Map<String,dynamic> json){
    List<WeatherItemModel> mWeatherItem =[];
    for(Map<String,dynamic> eachItem in json["weather"]){
      mWeatherItem.add(WeatherItemModel.fromJson(eachItem));
    }
    return WeatherDetailsModel(
        coord: CoordModel.fromJson(json["coord"]),
        weather: mWeatherItem,
        base: json["base"],
        main: MainModel.fromJson(json["main"]),
        visibility: json["visibility"],
        wind:WindModel.fromJson(json["wind"]),
        clouds: CloudsModel.fromJson(json["clouds"]),
        dt: json["dt"],
        sys: SysModel.fromJson(json["sys"]),
        timezone: json["timezone"],
        id: json["id"],
        name: json["name"],
        cod: json["cod"]
    );
  }
}