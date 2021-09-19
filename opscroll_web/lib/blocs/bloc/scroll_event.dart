part of 'scroll_bloc.dart';

abstract class ScrollEvent extends Equatable {
  const ScrollEvent();
}

class ScrollStart extends ScrollEvent {
  final DateTime scrollStartDateTime;

  /// [isUp] is listenener [scrollDelta.dy.isNegative] is negative
  /// thats mean user scroll to up
  final bool isUp;

  const ScrollStart({required this.scrollStartDateTime, required this.isUp});
  @override
  List<Object?> get props => [scrollStartDateTime, isUp];
}
