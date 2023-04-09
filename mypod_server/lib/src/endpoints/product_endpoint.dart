import 'package:mypod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ProductEndpoint extends Endpoint {
  // Fetch Data
  Future<List<Product>> getProducts(Session session, {String? search})async{
    return await Product.find(session,
    //optional parameter for making conditional query
    where: (v) => search != null ? v.title.like('%$search'): Constant(true));
  }

  // Insert Data
  Future<bool> insertProduct(Session session, Product product)async{
    await Product.insert(session, product);
    return true;
  }

  // Update Data
  Future<bool> updateProduct(Session session, Product product)async{
    var result = await Product.update(session, product);
    return true;
  }

  // Delete Data
  Future<bool> deleteProduct(Session session, int id)async{
    var result = await Product.delete(session, where: (v)=>v.id.equals(id));
    return result==1;
  }
}
