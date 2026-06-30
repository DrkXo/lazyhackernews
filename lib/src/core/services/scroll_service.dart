import 'package:nocterm/nocterm.dart';

class ScrollService {
  final ScrollController controller = ScrollController();

  void dispose() {
    controller.dispose();
  }

  void scrollToIndex(int index) {
    controller.ensureIndexVisible(index: index);
  }
}
