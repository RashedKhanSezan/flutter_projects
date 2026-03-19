import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable list for pagination
  var items = <String>[].obs;
  var isLoading = false.obs;
  
  int _page = 1;
  final int _limit = 15;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Load initial data when page opens
  }

  Future<void> fetchData() async {
    if (isLoading.value) return;

    isLoading.value = true;
    
    // Simulate API/Network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate dummy data for the current page
    List<String> newItems = List.generate(
      _limit, 
      (index) => "Product ${(items.length + index + 1)}"
    );

    items.addAll(newItems);
    _page++;
    isLoading.value = false;
  }
}