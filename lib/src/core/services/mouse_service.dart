typedef StoryTapCallback = void Function(int index);

class MouseService {
  StoryTapCallback? onStoryTap;

  void onStoryTapped(int index) {
    onStoryTap?.call(index);
  }
}
