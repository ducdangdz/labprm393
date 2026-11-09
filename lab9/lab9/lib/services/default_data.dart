import '../models/note_item.dart';
import '../models/product_item.dart';

List<NoteItem> defaultNotes() {
  return [
    NoteItem(
      id: '1',
      title: 'Welcome to Lab 9.2',
      content: 'This note was read from the local application document directory.',
      category: 'Study',
      createdAt: '2026-11-09 10:00',
    ),
    NoteItem(
      id: '2',
      title: 'JSON Persistence Test',
      content: 'You can add notes here, tap "Save to File", and reload to test persistence.',
      category: 'Important',
      createdAt: '2026-11-09 10:30',
    ),
  ];
}

List<ProductItem> defaultProducts() {
  return [
    ProductItem(
      id: 1,
      name: 'MacBook Air M2',
      category: 'Laptop',
      price: 1099.0,
      quantity: 15,
      description: 'Apple M2 chip, 8GB RAM, 256GB SSD storage',
      updatedAt: '2026-11-09 09:15',
    ),
    ProductItem(
      id: 2,
      name: 'iPhone 15 Pro',
      category: 'Smartphone',
      price: 999.0,
      quantity: 28,
      description: 'Titanium design, A17 Pro chip, 48MP camera',
      updatedAt: '2026-11-09 09:30',
    ),
    ProductItem(
      id: 3,
      name: 'Sony WH-1000XM5',
      category: 'Audio',
      price: 349.0,
      quantity: 40,
      description: 'Industry-leading noise cancelling wireless headphones',
      updatedAt: '2026-11-09 10:00',
    ),
    ProductItem(
      id: 4,
      name: 'Logitech MX Master 3S',
      category: 'Accessories',
      price: 99.0,
      quantity: 50,
      description: 'Ergonomic performance wireless mouse with quiet clicks',
      updatedAt: '2026-11-09 10:45',
    ),
    ProductItem(
      id: 5,
      name: 'Dell UltraSharp 27" 4K',
      category: 'Monitor',
      price: 520.0,
      quantity: 12,
      description: 'IPS Black technology, USB-C Hub monitor with 90W PD',
      updatedAt: '2026-11-09 11:20',
    ),
  ];
}
