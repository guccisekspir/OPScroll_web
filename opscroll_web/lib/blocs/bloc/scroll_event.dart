part of 'scroll_bloc.dart';

abstract class ScrollEvent extends Equatable {
  const ScrollEvent();
}

class ScrollStart extends ScrollEvent {
  final DateTime scrollStartDateTime;
  final bool isUp;

  ScrollStart({required this.scrollStartDateTime, required this.isUp});
  @override
  List<Object?> get props => [scrollStartDateTime, isUp];
}
