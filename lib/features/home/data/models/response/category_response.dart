class CategoryResponse {
  final int? id;
  final String? name;
  final int? parentId;
  final String? parentName;

  CategoryResponse({
    this.id,
    this.name,
    this.parentId,
    this.parentName,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      parentId: json['parentId'] as int?,
      parentName: json['parentName'] as String?,
    );
  }
}
