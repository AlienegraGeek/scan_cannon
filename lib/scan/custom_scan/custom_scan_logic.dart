import 'package:get/get.dart';
import 'package:scan_cannon/scan/spec/scan_spec.dart';

import '../../provider/http_provider.dart';

class CustomScanLogic extends GetxController {
  ApiHttpProvider apiHttpProvider = Get.put(ApiHttpProvider());

  //创建商品信息
  var goodData = GoodItem(barcode: '').obs;

  httpGetScanGood(itemId) async {
    var resp = await apiHttpProvider.scanQueryGood(itemId);
    if (resp.body["code"] == 1) {
      var data = resp.body["data"];
      // print(data);
      goodData.value = GoodItem.fromJson(resp.body["data"]);
      print(goodData.value.barcode);
    }
  }
}
