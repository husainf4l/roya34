import 'package:get/get.dart';

class AppController extends GetxController {
  // Observable variables
  final count = 0.obs;
  final name = 'User'.obs;
  final isLoading = false.obs;

  // Methods
  void increment() {
    count.value++;
  }

  void updateName(String newName) {
    name.value = newName;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  // Called when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    // Initialize resources here
  }

  // Called just before the controller is deleted
  @override
  void onClose() {
    // Dispose of resources here
    super.onClose();
  }
}
