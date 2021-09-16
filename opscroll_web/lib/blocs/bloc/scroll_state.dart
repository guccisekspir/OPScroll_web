part of 'scroll_bloc.dart';

abstract class ScrollState extends Equatable {
  const ScrollState();
}

class ScrollInitial extends ScrollState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollToNextPage extends ScrollState {
  final DateTime scrollNextDateTime;

  ScrollToNextPage({required this.scrollNextDateTime});
  @override
  // TODO: implement props
  List<Object?> get props => [scrollNextDateTime];
}

class ScrollToPreviousPage extends ScrollState {
  final DateTime scrollPreviousDateTime;

  ScrollToPreviousPage({required this.scrollPreviousDateTime});
  @override
  // TODO: implement props
  List<Object?> get props => [scrollPreviousDateTime];
}
