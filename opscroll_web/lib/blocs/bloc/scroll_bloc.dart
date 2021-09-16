import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'scroll_event.dart';
part 'scroll_state.dart';

class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  ScrollBloc() : super(ScrollInitial());

  DateTime? lastScrolledDateTime;

  @override
  Stream<ScrollState> mapEventToState(
    ScrollEvent event,
  ) async* {
    if (event is ScrollStart) {
      if (lastScrolledDateTime == null) {
        lastScrolledDateTime = event.scrollStartDateTime;
        if (event.isUp) {
          debugPrint("İlk kez geldi previous ");
          yield (ScrollToPreviousPage(scrollPreviousDateTime: DateTime.now()));
        } else {
          debugPrint("İlk kez geldi ve next");

          yield (ScrollToNextPage(scrollNextDateTime: DateTime.now()));
        }
      } else {
        Duration differenceDuration =
            lastScrolledDateTime!.difference(event.scrollStartDateTime);

        debugPrint("ikinci kez geldi ve zaman farkı" +
            differenceDuration.inSeconds.toString());
        if (-differenceDuration.inSeconds > 1) {
          if (event.isUp) {
            debugPrint("scroll to previous");
            lastScrolledDateTime = DateTime.now();
            await Future.delayed(const Duration(milliseconds: 100));

            yield (ScrollToPreviousPage(
                scrollPreviousDateTime: DateTime.now()));
          } else {
            lastScrolledDateTime = DateTime.now();

            debugPrint("scroll to next");

            yield (ScrollToNextPage(scrollNextDateTime: DateTime.now()));
          }
        }
      }
    }
  }
}
