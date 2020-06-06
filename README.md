# YouTube-Embedded-Player-in-UICollectionView
To demonstrate the pitfall when using YouTube Embedded Player in UICollectionView

Assuming the view hierarchy is like: 
```
UICollectionView
┗ UICollectionViewCell 
 ┗ WKWebView
```
YouTube Embedded Player is loaded in the `WKWebView`.

Once the user interacts with the video player (like play, pause), delegate events like `willDisplayCell`, `didEndDisplayingCell` stop working.

![](https://miro.medium.com/max/640/1*iBnBc33VzPEjdzpE0Xh-og.gif)

This project is to demonstrate the problem and the workaround implemented using CADisplayLink.
