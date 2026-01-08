class CategoryRequest {
  final String name;
  final int? parentId;

  CategoryRequest({
    required this.name,
    this.parentId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (parentId != null) 'parentId': parentId,
      };
}
