import 'dart:ffi';

void main() {
  print('FFI is working');
  print('Size of Int64: ${sizeOf<Int64>()}');
}
