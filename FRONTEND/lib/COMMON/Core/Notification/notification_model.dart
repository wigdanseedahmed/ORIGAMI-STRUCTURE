class NotificationModel {
  final String name;
  final String profilePic;
  final String content;
  final String postImage;
  final String timeAgo;
  final bool hasStory;

  NotificationModel(
      this.name,
      this.profilePic,
      this.content,
      this.postImage,
      this.timeAgo,
      this.hasStory
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        json['name'],
        json['profilePic'],
        json['content'],
        json['postImage'],
        json['timeAgo'],
        json['hasStory']
    );
  }
}