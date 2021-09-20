# OPscroll_web


<p align="left" width="100%">
    <img width="100%" src="https://media.giphy.com/media/UjyBgiG2NjM4nYghBh/giphy.gif?cid=790b761177a01e756ce8a2f4e90dc103b29ddc59d2eb0581&rid=giphy.gif&ct=g">
</p>

<h1 align="center">OPScroll</h1>

<p align="center">A simple and easy to use library that creates OnePage sites for Flutter Web Developers! Make a beautiful and smooth landing pages with OPScroll with in minutes. Try out our <a href="https://opscrolll.web.app/">Web Demo App</a>.</p><br>

# Table of contents


- [Installing](#installing)
- [Usage](#usage)
- [Up Coming](#up-coming)
- [Scrolling Options](#scrolling-options)
- [Scrolling Animations](#scrolling-animations)
  - [Fading Scrolling Animation](fading-scrolling-animation)
  - [Circle Scrolling Animation](circle-scrolling-animation)
  - [Drop Scrolling Animation](drop-scrolling-animation)
    


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
  scrollingAnimationOptions: ScrollingAnimationOptions.Default,
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

# Scrolling Animations

There are 4 scrolling options for OPScroll. 

```dart
enum ScrollingAnimationOptions { Fading, Drop, Circle, Default }
```
You can only choice 1 scrolling animation options.

---

## Fading Scrolling Animation

<img src="https://media4.giphy.com/media/LCx7dhjuWyTTSLm563/giphy.gif?cid=790b7611b5a1edd4ba7e478e5db108a2c75c637903a476d1&rid=giphy.gif&ct=g" align = "center" height = "300px">

 ```dart
 OpscrollWeb(
    isFloatingButtonActive: true,
    isTouchScrollingActive: true,
    pageController: pageController,
    scrollingAnimationOptions: ScrollingAnimationOptions.Fading,
    scrollSpeed: const Duration(milliseconds: 900,
    onePageChildren:[]),
```
---

## Circle Scrolling Animation

<img src="https://media0.giphy.com/media/xhY9fvl0vApRDNvwxe/giphy.gif?cid=790b7611cb6f537d7375c7d11c12242fcffd867b7e44ac18&rid=giphy.gif&ct=g" align = "center" height = "300px">

 ```dart
 OpscrollWeb(
    isFloatingButtonActive: true,
    isTouchScrollingActive: true,
    pageController: pageController,
    scrollingAnimationOptions: ScrollingAnimationOptions.Circle,
    scrollSpeed: const Duration(milliseconds: 600,
    onePageChildren:[]),
```
---

## Drop Scrolling Animation

<img src="https://media0.giphy.com/media/SRCY7kZ4v2pQGJ0Ifs/giphy.gif?cid=790b761198a615ed546125053ffceb6a261717ad2e4e99ef&rid=giphy.gif&ct=g" align = "center" height = "300px">

 ```dart
 OpscrollWeb(
    isFloatingButtonActive: true,
    isTouchScrollingActive: true,
    pageController: pageController,
    scrollingAnimationOptions: ScrollingAnimationOptions.Drop,
    scrollSpeed: const Duration(milliseconds: 600,
    onePageChildren:[]),
```

 

# Up Coming

- [:white_check_mark:] Fade Scroll Effect
- [:white_check_mark:] Drop Scroll Effect
- [:hourglass_flowing_sand:] New Scroll Effects
