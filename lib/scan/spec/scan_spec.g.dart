// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodItem _$GoodItemFromJson(Map<String, dynamic> json) => GoodItem(
      goodsName: json['goodsName'] as String?,
      barcode: json['barcode'] as String,
      price: json['price'] as String?,
      brand: json['brand'] as String?,
      supplier: json['supplier'] as String?,
      standard: json['standard'] as String?,
    );

Map<String, dynamic> _$GoodItemToJson(GoodItem instance) => <String, dynamic>{
      'goodsName': instance.goodsName,
      'barcode': instance.barcode,
      'price': instance.price,
      'brand': instance.brand,
      'supplier': instance.supplier,
      'standard': instance.standard,
    };

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) => ProductItem(
      productCode: json['productCode'] as String?,
      productFirmName: json['productFirmName'] as String?,
      productName: json['productName'] as String?,
      productSpecifications: json['productSpecifications'] as String?,
      productBrand: json['productBrand'] as String?,
      productPackagngForm: json['productPackagngForm'] as String?,
      productTime: json['productTime'] as String?,
      productAddress: json['productAddress'] as String?,
      productContry: json['productContry'] as String?,
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'productCode': instance.productCode,
      'productFirmName': instance.productFirmName,
      'productName': instance.productName,
      'productSpecifications': instance.productSpecifications,
      'productBrand': instance.productBrand,
      'productPackagngForm': instance.productPackagngForm,
      'productTime': instance.productTime,
      'productAddress': instance.productAddress,
      'productContry': instance.productContry,
    };

QueryRecord _$QueryRecordFromJson(Map<String, dynamic> json) => QueryRecord(
      itemId: json['itemId'] as String,
      recordIP: json['recordIP'] as String?,
      oSName: json['oSName'] as String?,
      browserName: json['browserName'] as String?,
      createDate: json['createDate'] as String?,
      visitorInfoAddress: json['visitorInfoAddress'] as String?,
    );

Map<String, dynamic> _$QueryRecordToJson(QueryRecord instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'recordIP': instance.recordIP,
      'oSName': instance.oSName,
      'browserName': instance.browserName,
      'createDate': instance.createDate,
      'visitorInfoAddress': instance.visitorInfoAddress,
    };
