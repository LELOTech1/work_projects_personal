import 'package:flutter/material.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter eCommerce',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const BottomNavScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final IconData iconData;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.iconData,
    required this.category,
  });
}

class Cart {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    _items.add(product);
  }

  void clearCart() {
    _items.clear();
  }
}

final Cart cart = Cart();

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProductListScreen(),
    const CartScreen(),
    const CheckoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter eCommerce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfileScreen()), // Navigate to ProfileScreen
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Checkout',
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      title: 'Product 1',
      description: 'Description 1',
      price: 10.99,
      iconData: Icons.shopping_basket,
      category: 'Category A',
    ),
    Product(
      id: '2',
      title: 'Product 2',
      description: 'Description 2',
      price: 19.99,
      iconData: Icons.shopping_cart,
      category: 'Category B',
    ),
    Product(
      id: '3',
      title: 'Product 3',
      description: 'Description 3',
      price: 15.99,
      iconData: Icons.shopping_bag,
      category: 'Category A',
    ),
    // Add more products here
  ];

  ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return Card(
            child: ListTile(
              leading: Icon(products[index].iconData),
              title: Text(products[index].title),
              subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addToCart(
                      products[index]); // Add the product to the cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<bool> _selectedItems =
      List.generate(cart.items.length, (index) => false);

  void _toggleItemSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < cart.items.length; i++) {
      if (_selectedItems[i]) {
        totalPrice += cart.items[i].price;
      }
    }
    return totalPrice;
  }

  void _proceedToCheckout() {
    // Get selected items for checkout
    List<Product> selectedItems = [];
    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        selectedItems.add(cart.items[i]);
      }
    }

    // Process the selected items, e.g., initiate a payment process or navigate to a checkout page.
    // You can implement your logic here.

    // Clear the cart after checkout
    cart.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout successful'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfileScreen()), // Navigate to ProfileScreen
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cart.items.isEmpty)
              const Text('Your cart is empty.')
            else
              Column(
                children: [
                  const Text('Your selected items:'),
                  for (int i = 0; i < cart.items.length; i++)
                    ListTile(
                      leading: Checkbox(
                        value: _selectedItems[i],
                        onChanged: (value) {
                          _toggleItemSelection(i);
                        },
                      ),
                      title: Text(cart.items[i].title),
                      subtitle:
                          Text('\$${cart.items[i].price.toStringAsFixed(2)}'),
                    ),
                  const SizedBox(height: 16),
                  Text(
                      'Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}'),
                  ElevatedButton(
                    onPressed: _proceedToCheckout,
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your selected items:'),
            for (var item in cart.items)
              ListTile(
                leading: Icon(item.iconData),
                title: Text(item.title),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
              ),
            ElevatedButton(
              onPressed: () {
                // Implement the checkout logic here
                // You can clear the cart and show a confirmation message
                cart.clearCart(); // Clear the cart after checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout successful'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  List<Product> products = [
    Product(
      id: '1',
      title: 'Product 1',
      description: 'Description 1',
      price: 10.99,
      iconData: Icons.shopping_basket,
      category: 'Category A',
    ),
    Product(
      id: '2',
      title: 'Product 2',
      description: 'Description 2',
      price: 19.99,
      iconData: Icons.shopping_cart,
      category: 'Category B',
    ),
    Product(
      id: '3',
      title: 'Product 3',
      description: 'Description 3',
      price: 15.99,
      iconData: Icons.shopping_bag,
      category: 'Category A',
    ),
    // Add more products here
  ];

  void _searchProducts(String query) {
    setState(() {
      _searchResults = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProducts,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(_searchResults[index].iconData),
                    title: Text(_searchResults[index].title),
                    subtitle: Text(
                        '\$${_searchResults[index].price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        cart.addToCart(_searchResults[
                            index]); // Add the product to the cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Add state variables and methods to handle the profile data and form submission.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Create your profile form fields here, e.g., TextFields, Dropdowns, etc.
          // Use TextFormField for editable fields and RaisedButton for a save button.
          // Implement logic to update the user's profile data.

          // Example TextField:
          const TextField(
            decoration: InputDecoration(labelText: 'Name'),
            // Add controller and onChanged to handle user input.
          ),

          // Example Dropdown:
          DropdownButtonFormField<String>(
            value: 'Male',
            onChanged: (value) {
              // Handle dropdown selection.
            },
            items: ['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Example Save Button:
        ],
      ),
    );
  }
}
