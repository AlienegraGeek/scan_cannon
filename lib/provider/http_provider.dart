import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import './../common/global/global_url.dart';

/*
  key
  phone = 用户当前手机号 登录的时候写入
 */
class BaseConnect extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = Global.urlHttp;
    httpClient.timeout = const Duration(seconds: 60);
    // Request静默拦截
    // httpClient.addRequestModifier<Request>((req) {
    //   req.headers["token"] = "token";
    //   print(req);
    //   return req;
    // });

    // Response静默拦截
    // httpClient.addResponseModifier<>((request, response) {
    //   CasesModel model = response.body;
    //   if (model.countries.contains('abc')) {
    //     model.countries.remove('abc');
    //   }
    // });

    // It's will attach 'apikey' property on header from all requests
    // httpClient.addRequestModifier((request) {
    //   request.headers['access_token'] = 'hwdDpDy46bQafZEl7ogwH35miMml9VzdvtMuwcjYBGxk8tuN9Fr2xjU5Vw4lYJan1';
    //   return request;
    // });
    httpClient.addRequestModifier((Request request) async {
      // var token = box.read("token");
      // token ??= "";
      // request.headers['access_token'] = token;
      return request;
    });

    // 响应拦截
    httpClient.addResponseModifier((request, response) {
      var resp = response.bodyString.toString();
      if (resp.contains('token is unauthorized') || resp.contains('missing access token')) {
        box.remove("token");
        box.remove("phone");
        box.remove("clientId");
        box.remove("clientName");
        // Get.off(Login());
        return response;
      }
      return response;
    });

    // Token处理
    // httpClient.addAuthenticator<Request?>((req) async {
    //   // final response = await get(Global.urlHttp);
    //   // final token = response.body['token'];
    //   var token =  "hwdDpDy46bQafZEl7ogwH35miMml9VzdvtMuwcjYBGxk8tuN9Fr2xjU5Vw4lYJan";
    //   req.headers['access_token'] = token;
    //   return req;
    // });

    //最大重试次数
    httpClient.maxAuthRetries = 3;
  }
}

class ApiHttpProvider extends BaseConnect {

  //扫码查询商品信息
  Future<Response> scanQueryGood(String code) {
    // return post("/barcode_api.aspx", {"code": code, "AccessKeyId": Global.accessKeyId, "AccessSecret": Global.accessSecret});
    return get("/api/barcode/goods/details", query: {"barcode": code, "app_id": Global.accessKeyId, "app_secret": Global.accessSecret});
  }
}
