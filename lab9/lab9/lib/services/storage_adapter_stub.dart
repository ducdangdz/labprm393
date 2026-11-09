import 'storage_adapter.dart';

StorageAdapter getStorageAdapter() =>
    throw UnsupportedError('Cannot create a storage adapter without dart:io or dart:html.');
