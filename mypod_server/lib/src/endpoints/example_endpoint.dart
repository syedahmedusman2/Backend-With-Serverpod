import 'package:mypod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
//For returning hard code data 
  Future<Product> getProduct(Session session)async{
    return Product(title: "Product 1",
     price: 350,
     description: "This is the description",
     unit: 25,
     isAvailable: true);
  }
}
