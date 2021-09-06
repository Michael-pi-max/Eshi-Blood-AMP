abstract class BottomNavigationEvent {}

class ClickBottomNavigationEvent extends BottomNavigationEvent {
  final int currentIndex;

  ClickBottomNavigationEvent({required this.currentIndex});
}
