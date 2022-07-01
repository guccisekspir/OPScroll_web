class MyScrollState {
  DateTime? lastScrolledDateTime;
  bool startScroll(DateTime scrollStartDateTime) {
    /// When [ScrollStart] called firstly we look at the [lastScrolledDateTime]
    /// If it is null that mean this is first scrolling
    /// so we dont controll any sequence and directly yield ScrollState
    if (lastScrolledDateTime == null) {
      lastScrolledDateTime = scrollStartDateTime;
      return true;
    } else {
      /// If [lastScrolledDateTime] not null thats mean
      /// We have to controll difference [lastScrolledDateTime] and [event.scrollStartDateTime]
      /// Because [ScrollStart] is calling every Listener [PointerScrollEvent]
      /// We are controlling in there about
      /// is this event calling from current scrolling sequence or new scroll
      /// if difference shorter than 1 second it is meaning we are still in sequence
      Duration differenceDuration =
          lastScrolledDateTime!.difference(scrollStartDateTime);
      if (-differenceDuration.inSeconds > 1) {
        lastScrolledDateTime = DateTime.now();
        return true;
      }
    }
    return false;
  }
}
