import 'package:transportia/api/api.dart';

class ApiBusListingResource {
  final int id;
  final String? externalId;
  final String origin;
  final String originCode;
  final String fetchedFrom;

  final String title;
  final String? description;
  final String? link;

  final String? manufacturer;
  final String? scale;
  final String? manufacturerCode;

  final double priceLow;
  final double priceHigh;
  final String? currency;

  final String imageList;

  final String? sellerName;
  final String? sellerLink;

  final String? condition;

  final String? listedAt;
  final String? endsAt;

  final String? category;

  final int? total;
  final int? lowest;
  final bool? soldOut;
  final bool? someSoldOut;

  ApiBusListingResource({
    required this.id,
    this.externalId,
    required this.origin,
    required this.originCode,
    required this.fetchedFrom,
    required this.title,
    this.description,
    this.link,
    this.manufacturer,
    this.scale,
    this.manufacturerCode,
    required this.priceLow,
    required this.priceHigh,
    this.currency,
    required this.imageList,
    this.sellerName,
    this.sellerLink,
    this.condition,
    this.listedAt,
    this.endsAt,
    this.category,
    this.total,
    this.lowest,
    this.soldOut,
    this.someSoldOut,
  });

  factory ApiBusListingResource.fromJson(Map<String, dynamic> json) {
    return ApiBusListingResource(
      id: json["id"],
      externalId: json["external_id"],
      origin: json["origin"],
      originCode: json["origin_code"],
      fetchedFrom: json["fetched_from"],
      title: json["title"],
      description: json["description"],
      link: json["link"],
      manufacturer: json["manufacturer"],
      scale: json["scale"],
      manufacturerCode: json["manufacturer_code"],
      priceLow: json["price_low"],
      priceHigh: json["price_high"],
      currency: json["currency"],
      imageList: json["image_list"],
      sellerName: json["seller_name"],
      sellerLink: json["seller_link"],
      condition: json["condition"],
      listedAt: json["listed_at"],
      endsAt: json["ends_at"],
      category: json["category"],
      total: json["total"],
      lowest: json["lowest"],
      soldOut: json["sold_out"],
      someSoldOut: json["some_sold_out"],
    );
  }

  static Future<List<ApiBusListingResource>> fetchAll({
    String? search,
    String? sortBy,
    String? scale,
    String? origin,
    String? condition,
    String? manufacturer,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("sort", sortBy),
      ("scale", scale),
      ("origin", origin),
      ("condition", condition),
      ("manufacturer", manufacturer),
      ("page_length", 50),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${x.$2.$2}";
    }

    final data = await Api().get("/listings$query");

    return (data as List)
        .map((json) => ApiBusListingResource.fromJson(json))
        .toList();
  }
}
