import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';

class ProfileResponsePostOb {
  bool? success; // Indicates if the request was successful
  List<BlogOb>? result; // Holds the list of blog objects

  ProfileResponsePostOb({this.success, this.result});

  // Constructor for creating an instance from JSON
  ProfileResponsePostOb.fromJson(Map<String, dynamic> json) {
    success = json['success']; // Extract the success flag
    // Check if 'result' is not null before processing
    if (json['result'] != null) {
      result = <BlogOb>[]; // Initialize the list
      json['result'].forEach((v) {
        result!.add(BlogOb.fromJson(v)); // Convert JSON to BlogOb and add to the list
      });
    }
  }

  // Convert the instance back to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success; // Include the success flag
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList(); // Convert list of BlogOb to JSON
    }
    return data; // Return the data map
  }
}
