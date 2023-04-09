/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:mypod_client/src/protocol/product_class.dart' as _i3;
import 'dart:io' as _i4;
import 'protocol.dart' as _i5;

class _EndpointExample extends _i1.EndpointRef {
  _EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {'name': name},
      );

  _i2.Future<_i3.Product> getProduct() =>
      caller.callServerEndpoint<_i3.Product>(
        'example',
        'getProduct',
        {},
      );
}

class _EndpointProduct extends _i1.EndpointRef {
  _EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<List<_i3.Product>> getProducts({String? search}) =>
      caller.callServerEndpoint<List<_i3.Product>>(
        'product',
        'getProducts',
        {'search': search},
      );

  _i2.Future<bool> insertProduct(_i3.Product product) =>
      caller.callServerEndpoint<bool>(
        'product',
        'insertProduct',
        {'product': product},
      );

  _i2.Future<bool> updateProduct(_i3.Product product) =>
      caller.callServerEndpoint<bool>(
        'product',
        'updateProduct',
        {'product': product},
      );

  _i2.Future<bool> deleteProduct(int id) => caller.callServerEndpoint<bool>(
        'product',
        'deleteProduct',
        {'id': id},
      );
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i4.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i5.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    example = _EndpointExample(this);
    product = _EndpointProduct(this);
  }

  late final _EndpointExample example;

  late final _EndpointProduct product;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'example': example,
        'product': product,
      };
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
