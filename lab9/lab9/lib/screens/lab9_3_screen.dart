import 'package:flutter/material.dart';
import '../models/product_item.dart';
import '../services/storage_service.dart';

// =============================================================================
// LAB 9.3 – LOCAL JSON CRUD MINI DATABASE (SEARCH + EDIT + DELETE + AUTO-SAVE)
// =============================================================================

class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final StorageService _storageService = StorageService();

  List<ProductItem> _allProducts = [];
  List<ProductItem> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Laptop',
    'Smartphone',
    'Audio',
    'Accessories',
    'Monitor',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  /// Load mini database from local storage
  Future<void> _loadDatabase() async {
    setState(() => _isLoading = true);
    try {
      final items = await _storageService.readDatabase();
      setState(() {
        _allProducts = items;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error loading database: $e', isError: true);
    }
  }

  /// Filter items by query and category
  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final matchesQuery = query.isEmpty ||
            p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || p.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  /// Auto-save: Persists current list to JSON file after any CRUD change
  Future<void> _autoSaveDatabase({String? message}) async {
    try {
      await _storageService.writeDatabase(_allProducts);
      if (message != null) {
        _showSnackBar(message);
      }
    } catch (e) {
      _showSnackBar('Auto-save failed: $e', isError: true);
    }
  }

  // ===========================================================================
  // CRUD OPERATIONS
  // ===========================================================================

  /// CREATE: Add new item with auto-generated incremental ID
  Future<void> _showAddProductDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final descController = TextEditingController();
    String category = 'Laptop';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Add New Product'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((c) => c != 'All')
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => category = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$) *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? -1;
                final qty = int.tryParse(quantityController.text.trim()) ?? -1;
                final desc = descController.text.trim();

                if (name.isEmpty || price < 0 || qty < 0) {
                  _showSnackBar('Please enter valid product details', isError: true);
                  return;
                }

                // Incremental auto ID
                int nextId = 1;
                if (_allProducts.isNotEmpty) {
                  nextId = _allProducts.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
                }

                final newProduct = ProductItem(
                  id: nextId,
                  name: name,
                  category: category,
                  price: price,
                  quantity: qty,
                  description: desc.isEmpty ? 'No description' : desc,
                  updatedAt: _currentDateTimeString(),
                );

                setState(() {
                  _allProducts.insert(0, newProduct);
                  _applyFilter();
                });

                Navigator.pop(ctx);
                _autoSaveDatabase(
                  message: 'Added "${newProduct.name}" (ID #$nextId) & auto-saved to JSON!',
                );
              },
              child: const Text('Add & Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// UPDATE: Edit existing item
  Future<void> _showEditProductDialog(ProductItem product) async {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(text: product.price.toString());
    final quantityController = TextEditingController(text: product.quantity.toString());
    final descController = TextEditingController(text: product.description);
    String category = product.category;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.edit, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text('Edit Product #${product.id}'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _categories.contains(category) && category != 'All'
                      ? category
                      : 'Other',
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((c) => c != 'All')
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => category = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? product.price;
                final qty = int.tryParse(quantityController.text.trim()) ?? product.quantity;
                final desc = descController.text.trim();

                if (name.isEmpty) {
                  _showSnackBar('Name cannot be empty', isError: true);
                  return;
                }

                final updated = product.copyWith(
                  name: name,
                  category: category,
                  price: price,
                  quantity: qty,
                  description: desc,
                  updatedAt: _currentDateTimeString(),
                );

                final index = _allProducts.indexWhere((p) => p.id == product.id);
                if (index != -1) {
                  setState(() {
                    _allProducts[index] = updated;
                    _applyFilter();
                  });

                  Navigator.pop(ctx);
                  _autoSaveDatabase(
                    message: 'Updated "${updated.name}" & auto-saved to JSON!',
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  /// DELETE: Remove item with confirmation dialog
  Future<void> _confirmDelete(ProductItem product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirm Delete'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}" (ID #${product.id})?\n'
          'This will automatically update the local JSON file.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final index = _allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        final removed = _allProducts.removeAt(index);
        setState(() {
          _applyFilter();
        });

        await _autoSaveDatabase();

        _showSnackBar(
          'Deleted "${removed.name}" & auto-saved.',
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() {
                _allProducts.insert(index, removed);
                _applyFilter();
              });
              await _autoSaveDatabase(message: 'Restored "${removed.name}"');
            },
          ),
        );
      }
    }
  }

  /// View raw database JSON file
  Future<void> _viewRawDatabase() async {
    try {
      final filePath = await _storageService.getDatabaseFilePath();
      final content = await _storageService.getRawDatabaseContent();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.storage, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Mini Database JSON'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Path: $filePath',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      content,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showSnackBar('Cannot view file: $e', isError: true);
    }
  }

  /// Reset to default seed products
  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Mini Database?'),
        content: const Text(
          'This will reset your local database to sample initial products. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final items = await _storageService.resetDatabaseToDefaults();
      setState(() {
        _allProducts = items;
        _applyFilter();
        _isLoading = false;
      });
      _showSnackBar('Reset database to default seed data!');
    }
  }

  void _showSnackBar(String message, {bool isError = false, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.indigo.shade800,
        action: action,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _currentDateTimeString() {
    final dt = DateTime.now();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }

  double get _totalInventoryValue {
    return _allProducts.fold(0.0, (sum, p) => sum + (p.price * p.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3: JSON CRUD Mini DB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View JSON Database',
            onPressed: _viewRawDatabase,
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'reset') _confirmReset();
              if (val == 'refresh') _loadDatabase();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Reload from File'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20),
                    SizedBox(width: 8),
                    Text('Reset to Defaults'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDatabase,
        child: Column(
          children: [
            // Database Overview Stats Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Items: ${_allProducts.length}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Text(
                        'Inventory Value: \$${_totalInventoryValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Auto-Save ON',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar (TextField)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: TextField(
                onChanged: (val) {
                  _searchQuery = val;
                  _applyFilter();
                },
                decoration: InputDecoration(
                  hintText: 'Search by product name, category, desc...',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category Filter Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                            _applyFilter();
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // Main List View (ListView.builder)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 54,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _searchQuery.isNotEmpty || _selectedCategory != 'All'
                                    ? 'No products match your filter'
                                    : 'Database is empty.\nTap "+ Add Product" to create one!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];

                            return Card(
                              elevation: 1.5,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: ID, Name, Price
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '#${product.id}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // Row 2: Description
                                    Text(
                                      product.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Row 3: Badges (Category & Stock) + Actions (Edit & Delete)
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            product.category,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: product.quantity > 0
                                                ? Colors.teal.shade50
                                                : Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: product.quantity > 0
                                                  ? Colors.teal.shade300
                                                  : Colors.red.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            product.quantity > 0
                                                ? 'Stock: ${product.quantity}'
                                                : 'Out of Stock',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: product.quantity > 0
                                                  ? Colors.teal.shade900
                                                  : Colors.red.shade900,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        // Edit Button
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 20),
                                          color: Colors.blueAccent,
                                          tooltip: 'Edit Item',
                                          onPressed: () =>
                                              _showEditProductDialog(product),
                                        ),
                                        // Delete Button
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                          ),
                                          color: Colors.redAccent,
                                          tooltip: 'Delete Item',
                                          onPressed: () => _confirmDelete(product),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
