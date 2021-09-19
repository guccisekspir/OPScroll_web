# OPscroll_web


<p align="left" width="100%">
    <img width="100%" src="https://media.giphy.com/media/UjyBgiG2NjM4nYghBh/giphy.gif?cid=790b761177a01e756ce8a2f4e90dc103b29ddc59d2eb0581&rid=giphy.gif&ct=g">
</p>

<h1 align="center">OPScroll</h1>

<p align="center">A simple and easy to use library that creates OnePage sites for Flutter Web Developers! Make a beautiful and smooth landing pages with OPScroll with in minutes. Try out our <a href="https://opscrolll.web.app/">Web Demo App</a>.</p><br>

# Table of contents


- [Installing](#installing)
- [Usage](#usage)
- [Up Coming](#upcoming)

# Installing

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  opscroll_web: ^0.0.2
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```
$ pub get
```

with `Flutter`:

```
$ flutter pub get
```

### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:opscroll_web/opscroll_web.dart';
```

# Usage

`OPScroll` is a _Stateful Widget_ that produces OnePage scroll mechanicsm for your
Flutter Web Projects.
Include it in your `build` method like:

```dart
OpscrollWeb({
  onePageChildren:[],
  pageController:PageController(),
  scrollCurve : Curves.easeIn,
  scrollSpeed : const Duration(milliseconds: 900),
  floatingButtonBackgroundColor :Colors.white,
  floatingButtonSplashColor : Colors.white,
  isFloatingButtonActive : false,
  isTouchScrollingActive : false,
  isFadingScroll: false,
  scrollDirection = Axis.vertical,
})
```

# Scrolling Options

You can allow to scrolling by tapping.Just give the true value to `isTouchScrollingActive`

```dart
isTouchScrollingActive=true,
```

You can allow to scrolling by Floating Action Button.Just give the true value to `isFloatingButtonActive`
Also you can change background & splash colors.

```dart
isTouchScrollingActive=true, //Optional
floatingButtonBackgroundColor :Colors.white, //Optional
floatingButtonSplashColor : Colors.white, //Optional
```

# UpComing

- [+] Fade Scroll Effect
- [ ] Drop Scroll Effect
- [ ] Hero Scroll Effect

