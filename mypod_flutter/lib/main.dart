import 'package:mypod_client/mypod_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
var client = Client('http://192.168.10.13:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Serverpod Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // These fields hold the last result or error message that we've received from
  // the server or null if no result exists yet.
  String? _resultMessage;
  String? _errorMessage;

  final _textEditingController = TextEditingController();

  // Calls the `hello` method of the `example` endpoint. Will set either the
  // `_resultMessage` or `_errorMessage` field, depending on if the call
  // is successful.
  void _callHello() async {
    try {
      final result = await client.example.hello(_textEditingController.text);
      setState(() {
        _resultMessage = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
      });
    }
  }
  

  addproduct(Product product)async{
    try{

     var result = await client.product.insertProduct(product);
     if(result){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfuly")));
      setState(() {
        _resultMessage = "Article Added";
        _products.add(product);
      });
      Navigator.pop(context);
     }
    }on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There is an error $e")));

    }
  }
  List<Product> _products = [];
  fetchProduct({search})async{
    try{
     var result = await client.product.getProducts(search: search);
     if(result.isNotEmpty){
      setState(() {
        _products = result;
        _resultMessage = "${result.length} products in the table";
      });
     }
    }on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There is an error $e")));

    }
  }
  updateProduct(Product product)async{
    try{
     var result = await client.product.updateProduct(product);
     if(result){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product update successfuly")));
     }
     Navigator.pop(context);
     setState(() {
       int index = _products.indexWhere((element) => element.id==product.id);
       _products[index] = product;
     });
    }on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There is an error $e")));

    }
  }
  deleteProduct(id)async{
    try{
     var result = await client.product.deleteProduct(id);
     if(result){
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted successfuly")));
      setState(() {
        _products.removeWhere((element) => element.id==id);
      });
     }
    }on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There is an error $e")));

    }
  }

  @override
  void initState() {
    fetchProduct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (BuildContext context, index){
            return ListTile(
              title: Text(_products[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${_products[index].price} \$"),
                  Text("${_products[index].unit} Units"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    deleteProduct(_products[index].id);
                  }, icon: Icon(Icons.delete)),
                  IconButton(onPressed: (){
                    _showArticleDialog(product: _products[index]);
                  }, icon: Icon(Icons.edit))

                ],
              ),
            );
          })
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showArticleDialog();
      },
      child: Icon(Icons.add),),
    );
  }
  _showArticleDialog({Product? product}) {
    var titleController = TextEditingController();
    var priceController = TextEditingController();
    var unitController = TextEditingController();

    if (product != null) {
      titleController.text = product.title;
      priceController.text = product.price.toString();
      unitController.text = product.unit.toString();
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Price',
                  ),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Unit',
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (product != null) {
                      product.title = titleController.text;
                      product.price = double.parse(priceController.text);
                      updateProduct(product);
                    } else {
                      var newProduct = Product(
                        title: titleController.text,
                        price: double.parse(priceController.text),
                        unit: int.parse(unitController.text),
                        isAvailable: true,
                        description: ""
                      );
                      addproduct(newProduct);
                      
                    }
                  },
                  child: const Text('Add Article'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// _ResultDisplays shows the result of the call. Either the returned result from
// the `example.hello` endpoint method or an error message.
class _ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const _ResultDisplay({
    this.resultMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    if (errorMessage != null) {
      backgroundColor = Colors.red[300]!;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = Colors.green[300]!;
      text = resultMessage!;
    } else {
      backgroundColor = Colors.grey[300]!;
      text = 'No server response yet.';
    }

    return Container(
      height: 50,
      color: backgroundColor,
      child: Center(
        child: Text(text),
      ),
    );
  }
}
