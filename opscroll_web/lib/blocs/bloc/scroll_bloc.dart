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
      /// When [ScrollStart] called firstly we look at the [lastScrolledDateTime]
      /// If it is null that mean this is first scrolling
      /// so we dont controll any sequence and directly yield ScrollState
      if (lastScrolledDateTime == null) {
        lastScrolledDateTime = event.scrollStartDateTime;
        if (event.isUp) {
          //First time calling and scroll to previous
          yield (ScrollToPreviousPage(scrollPreviousDateTime: DateTime.now()));
        } else {
          //First time calling and scroll to next

          yield (ScrollToNextPage(scrollNextDateTime: DateTime.now()));
        }
      } else {
        /// If [lastScrolledDateTime] not null thats mean
        /// We have to controll difference [lastScrolledDateTime] and [event.scrollStartDateTime]
        /// Because [ScrollStart] is calling every Listener [PointerScrollEvent]
        /// We are controlling in there about
        /// is this event calling from current scrolling sequence or new scroll
        /// if difference shorter than 1 second it is meaning we are still in sequence
        Duration differenceDuration =
            lastScrolledDateTime!.difference(event.scrollStartDateTime);
        if (-differenceDuration.inSeconds > 1) {
          if (event.isUp) {
            /// If it is new scrolling we will update [lastScrolledDateTime]
            lastScrolledDateTime = DateTime.now();
            yield (ScrollToPreviousPage(
                scrollPreviousDateTime: DateTime.now()));
          } else {
            lastScrolledDateTime = DateTime.now();
            yield (ScrollToNextPage(scrollNextDateTime: DateTime.now()));
          }
        }
      }
    }
  }
}
