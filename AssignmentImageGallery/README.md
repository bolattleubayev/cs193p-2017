# AssignmentImageGallery

This is an implementation of homework assignment Image Gallery from Stanford CS193p Fall 2017-18 on iTunes U by Paul Hegarty. The project was adapted for Xcode 9 and Swift 4

The app stores images containing both image and URL (in this case from Safari) in different galleries.
Galleries can be edited in the master view's Table View and displayed in detail's Collection View.

### Adding images from Safari

To add image as a background it must have URL and image, so you need to drag image from another app and drop it in the Drop Zone.

<img src="/images/0.png" width="600" height="450">

The image loading is done asynchronously so it will not freeze the app. While loading activity indicator will run

<img src="/images/1.png" width="600" height="450">

Several images can be stored

<img src="/images/2.png" width="600" height="450">

### Customizing Table View

You can add a new Gallery tapping the "+" bar button, you can also delete it by swiping.

<img src="/images/3.png" width="600" height="450">

After deletion from the main section gallery goes to the "Recently Deleted" section. Galleries in the section do not affect the detail view

<img src="/images/4.png" width="600" height="450">

You can also restore gallery from "Recently Deleted" section by swiping from left to right

<img src="/images/5.png" width="600" height="450">

Or permanently delete by swiping from right to left

<img src="/images/6.png" width="600" height="450">
<img src="/images/7.png" width="600" height="450">