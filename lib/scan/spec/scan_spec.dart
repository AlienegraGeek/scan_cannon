import 'package:json_annotation/json_annotation.dart';

part 'scan_spec.g.dart';

@JsonSerializable()
class GoodItem {
  String? goodsName; //商品名称
  String barcode; //商品对应的条形码code
  String? price; //预估价格
  String? brand; //品牌
  String? supplier; //厂商
  String? standard; //规格

  GoodItem({
    this.goodsName,
    required this.barcode,
    this.price,
    this.brand,
    this.supplier,
    this.standard,
  });

  factory GoodItem.fromJson(Map<String, dynamic> json) => _$GoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$GoodItemToJson(this);
}

@JsonSerializable()
class ProductItem {
  String? productCode;
  String? productFirmName;
  String? productName;
  String? productSpecifications;
  String? productBrand;
  String? productPackagngForm;
  String? productTime;
  String? productAddress;
  String? productContry;

  ProductItem(
      {this.productCode,
      this.productFirmName,
      this.productName,
      this.productSpecifications,
      this.productBrand,
      this.productPackagngForm,
      this.productTime,
      this.productAddress,
      this.productContry});

  factory ProductItem.fromJson(Map<String, dynamic> json) => _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);
}

@JsonSerializable()
class QueryRecord {
  String itemId;
  String? recordIP;
  String? oSName;
  String? browserName;
  String? createDate;
  String? visitorInfoAddress;

  QueryRecord({required this.itemId, this.recordIP, this.oSName, this.browserName, this.createDate, this.visitorInfoAddress});

  factory QueryRecord.fromJson(Map<String, dynamic> json) => _$QueryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$QueryRecordToJson(this);
}
