class NotificationModel {
  String? packageName;
  String? title;
  String? content;

  NotificationModel({this.packageName, this.title, this.content});

  NotificationModel.fromMap(Map map){
    if (check("packageName", map)) {
      packageName = map["packageName"];
    }
    if (check("title", map)) {
      title = map["title"];
    }
    if (check("content", map)) {
      content = map["content"];
    }
  }


  check(String key, Map map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }

  Map toMap() {
    return {
      "packageName": packageName,
      "title": title,
      "content": content,
    };
  }

}