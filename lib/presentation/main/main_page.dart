import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: 1,
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 120,
                height: 60,
                fit: BoxFit.contain,
              )
            )
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Shopping Progress Bar
          _buildProgressBar(),
          SizedBox(height: 20),
          // Tabs, Search, Add Item
          _buildControls(context),
          SizedBox(height: 20),
          // Shopping List Items
          Expanded(
            child: ListView(
              children: [
                _buildShoppingItem(
                  'Organic Cage-Free Eggs',
                  '1 Dozen • Dairy & Alternatives',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'Fresh Wild Blueberries',
                  '2 lbs • Fruits',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'Artisan Sourdough Bread',
                  '1 Loaf • Bakery',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'Grass-Fed Ground Beef',
                  '3 lbs • Meat & Seafood',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'San Marzano Canned Tomatoes',
                  '28 oz can • Pantry',
                  true, // Purchased
                ),
                _buildShoppingItem(
                  'Extra Virgin Olive Oil (Cold Pressed)',
                  '1 Liter • Cooking Essentials',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'Eco-Friendly Dish Soap',
                  '1 Bottle • Household',
                  false, // Not purchased
                ),
                _buildShoppingItem(
                  'Ripe Hass Avocados',
                  '3 Large • Vegetables',
                  false, // Not purchased
                ),
              ],
            ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Back to Login page'),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shopping Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 2 / 8, // Example: 2 items purchased out of 8
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(width: 10),
              Text('2/8 Items Purchased'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildTabButton('All', true),
                    SizedBox(width: 10),
                    _buildTabButton('Purchased', false),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search shopping items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/product'),
              icon: Icon(Icons.add),
              label: Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildShoppingItem(String title, String subtitle, bool isPurchased) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Checkbox(
              value: isPurchased,
              onChanged: (bool? newValue) {
                // Handle checkbox state change
              },
              activeColor: Colors.deepPurple,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: isPurchased ? TextDecoration.lineThrough : null,
                      color: isPurchased ? Colors.grey : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: isPurchased ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.grey),
              onPressed: () {
                // Handle edit item
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // Handle delete item
              },
            ),
          ],
        ),
      ),
    );
  }
}