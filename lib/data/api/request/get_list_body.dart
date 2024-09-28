class GetListBody {
  final String search;
  GetListBody({required this.search});
  Map<String, dynamic> toApi() {
    return {'q': search};
  }
}
