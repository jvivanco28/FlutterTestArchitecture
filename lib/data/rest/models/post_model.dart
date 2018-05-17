import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart/rxdart.dart';

/// This allows our `Post` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'post_model.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

/// Every json_serializable class must have the serializer mixin.
/// It makes the generated toJson() method to be usable for the class.
/// The mixin's name follows the source class, in this case, User.
class Post extends Object with _$PostSerializerMixin {

  /// Use this annotation if we want to map the json key to a differently named
  /// member. In this case, the names are the same.
  @JsonKey(name: 'userId')
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  @override
  String toString() {
    return 'Post{userId: $userId, id: $id, title: $title, body: $body}';
  }

  // Manual Json Deserialization
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return new Post(
//      userId: json['userId'],
//      id: json['id'],
//      title: json['title'],
//      body: json['body'],
//    );
//  }

  /// A necessary factory constructor for creating a new PostModel instance
  /// from a map. We pass the map to the generated _$PostModelFromJson constructor.
  /// The constructor is named after the source class, in this case PostModel.
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  // TODO I don't know if this is the best way of handling this... It seems shitty
  static List<Post> fromJsonList(List<dynamic> json) {
    return json.map((singlePostJson) => Post.fromJson(singlePostJson))
            .toList();
  }
}
