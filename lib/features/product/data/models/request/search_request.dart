class SearchProductRequest {
  String? keyword;
  int? page;
  int? sizePage;
  int? minPrice;
  int? maxPrice;
  int? status;
  int? categoryId;
  String? sortBy;
  String? sortDir;

  SearchProductRequest({
    this.keyword,
    this.page,
    this.sizePage,
    this.minPrice,
    this.maxPrice,
    this.status,
    this.categoryId,
    this.sortBy,
    this.sortDir,
  });

  SearchProductRequest.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    page = json['page'];
    sizePage = json['sizePage'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    status = json['status'];
    categoryId = json['categoryId'];
    sortBy = json['sortBy'];
    sortDir = json['sortDir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword'] = keyword;
    data['page'] = page;
    data['sizePage'] = sizePage;
    data['minPrice'] = minPrice;
    data['maxPrice'] = maxPrice;
    data['status'] = status;
    data['categoryId'] = categoryId;
    data['sortBy'] = sortBy;
    data['sortDir'] = sortDir;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
