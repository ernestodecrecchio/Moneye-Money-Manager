# Custom Floating Bottom Bar (Capsule Shell Navigation)

A beautiful, modern, pill-shaped floating bottom navigation bar inspired by mobile designs (such as Revolut's layout) built in Flutter. This component is optimized for smooth, gesture-rich interactions, fluid transitions, and complete style customization.

---

## 🏗️ Architecture Overview

The architecture of this component is designed to be cohesive, highly modular, and decoupled from the main application theme. It allows page content to render edge-to-edge (behind the bottom bar) while elegantly handling safe area insets, scroll clearance, and background gradients.

```
       +---------------------------------------------+
       |                 TabBarPage                  |  <-- Main Scaffold & State
       +---------------------------------------------+
                              |
       +----------------------+----------------------+
       |                                             |
+--------------+                             +---------------+
|  TabBarBody  |                             | BottomBarBody |
+--------------+                             |     Fade      |
       |                                     +---------------+
+--------------------+                       (Fades scrolled
| TabBarScrollScope  |                       content behind bar)
+--------------------+
       |
+--------------------+
| Active Tab Screen  |
|  (e.g., HomePage)  |
+--------------------+
       |
       v Uses
+--------------------+
| TabBarScrollSliver |
|         or         |
| TabBarScrollPadding|
+--------------------+
(Adds clearance space
 so content is scrollable
 above the bottom bar)
```

The component consists of the following modular files:

### 1. `tab_bar_theme.dart` (The Central Hub ⚙️)
This is the single source of truth for the entire bottom bar's design system. It unifies what was previously divided into multiple separate classes (`AppChrome` and `TabBarColors`) into a single, high-cohesion `ThemeExtension` called `TabBarTheme`.
- **Layout Metrics**: Tab bar height, bottom margin, horizontal margin, outer radius, item radius, and Floating Action Button (FAB) parameters.
- **Styling**: Backdrop blur sigma (`barBackdropBlurSigma`), animation transitions (`selectionAnimationDuration`, `selectionAnimationCurve`), and drop shadow configuration.
- **Colors**: Bar fills, border colors, selected pill background, and active/inactive icon/text foreground colors for both **Light** and **Dark** modes.
- **Calculations**: Exposes straightforward helper methods (`chromeHeight`, `scrollBottomInset`, `fadeOverlayHeight`) and `BuildContext` getters to easily determine layout coordinates based on screen safe area padding.

### 2. `revolut_style_bottom_bar.dart` (The Core Widget 📱)
The visual widget implementing the capsule shell. It builds:
- A `BackdropFilter` with customizable blur that creates a glassmorphism feel.
- A sliding indicator pill backdrop (`_TabBarTrack`) that moves with an `AnimatedPositioned` widget across tabs with a smooth cubic curve.
- Responsive, semantics-tagged tab buttons (`_TabBarTab`) that handle light haptic feedback and text-style resizing on selection.

### 3. `revolut_bottom_bar_item.dart` (Data Model 🏷️)
Represents a navigation destination. To avoid overengineering and remove verbose builder boilerplate, it has been enhanced to support two patterns:
1. **Static Icons**: Simply supply an `IconData` or a static `Widget` to the `icon` field. It is styled and colored automatically.
2. **Dynamic Builders**: Provide a custom `iconBuilder` closure to render custom responsive widgets (like SVGs) that react to selection states.

### 4. `tab_bar_shell.dart` (Integration Helpers 🧩)
A collection of structural layout widgets supporting edge-to-edge content:
- **`TabBarBody`**: Removes default bottom padding and lets tab content extend behind the navigation bar.
- **`TabBarScrollScope`**: An `InheritedWidget` that holds the computed bottom padding necessary for content to scroll past the bar and FAB.
- **`TabBarScrollPadding` / `TabBarScrollBottomSliver`**: Wrappers for lists or CustomScrollViews that automatically inject the correct bottom padding retrieved from the `TabBarScrollScope`.
- **`BottomBarBodyFade`**: Anchors a subtle linear gradient at the bottom of the screen to fade scrollable lists before they slide under the bar.
- **`FabAboveTabBarLocation`**: A standard FloatingActionButtonLocation offset helper that places the FAB perfectly above the floating tab bar capsule.

---

## 🎨 Centralized Theming

All theme and layout configurations are kept in a single file (`tab_bar_theme.dart`). 

### Light & Dark Mode Mapping
Colors are dynamically constructed using standard `AppColors` and the current context `Brightness`:

```dart
// To change sizes, change static constants or pass custom values:
static const standard = TabBarTheme(
  tabBarHeight: 68,
  tabBarBottomMargin: 4,
  tabBarHorizontalMargin: Constants.horizontalPadding,
  tabBarOuterRadius: 36,
  tabBarItemRadius: 28,
  fabSize: 56,
  fabAboveTabBarGap: 0,
  fabMargin: 16,
  scrollBottomSpacing: 0,
  fadeExtensionAboveBar: 0,
  barBackdropBlurSigma: 12.0,
  selectionAnimationDuration: Duration(milliseconds: 280),
  selectionAnimationCurve: Curves.easeOutCubic,
  // ... colors are handled in TabBarTheme.fromAppColors(...)
);
```

---

## 🚀 Usage Guide

### Defining Bottom Bar Items
You can mix and match static `IconData` and complex custom builders seamlessly:

```dart
items: [
  // 1. Using a custom builder (e.g. for dynamic SVGs)
  RevolutBottomBarItem(
    label: 'Dashboard',
    iconBuilder: (isSelected, color) => SafeVectorGraphic(
      iconPath: 'assets/icons/transactions.svg',
      color: color,
    ),
  ),
  // 2. Using simple, zero-boilerplate material icons
  RevolutBottomBarItem(
    label: 'Savings',
    icon: Icons.savings_rounded,
  ),
  RevolutBottomBarItem(
    label: 'Settings',
    icon: CupertinoIcons.gear_solid,
  ),
]
```

### Implementing Tab Views with Scroll Clearance
For lists to clear the floating bottom bar, either wrap your list in a `TabBarScrollPadding` widget, or include `TabBarScrollBottomSliver` at the bottom of a sliver list:

```dart
// Option A: For standard list/scroll view
@override
Widget build(BuildContext context) {
  return TabBarScrollPadding(
    child: ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    ),
  );
}

// Option B: For CustomScrollView (Slivers)
@override
Widget build(BuildContext context) {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(...),
      ),
      // Ensures the last item floats above the bottom bar capsule
      const TabBarScrollBottomSliver(),
    ],
  );
}
```
