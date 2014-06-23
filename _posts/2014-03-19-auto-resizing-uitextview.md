---
title: Auto Resizing UITextView
layout: post
---

There are some techniques to resize UITextView with respect to the keyboard.

- Add a `UITextView` inside a `UITableViewCell` and adjust the cell's size, so that `UITextView` will also be resized
- Add a `UITextView` to the `UIViewController` (or a subclass of it) and resize the `UITextView` itself

But I've used non of the above in my upcoming app. I've found a tweaked version of the second technique.

## Don't resize the `UITextView`

Instead adjust its `contentInset` property. So that, you can have a `UITextView` that **seems like** adjusting its size.

This technique also comes with a very useful benefit that I was thinking ways to
solve it. Assume that you are resizing `UITextView` every time keyboard is shown 
or hidden. When you assign a pattern image or color to `UITextView` as background 
color,<del>keyboard animation causes `UITextView` to adjust its size improperly during 
its animation</del>. And this lets the super view of `UITextView` to say 'Hello!' between
`UITextView` and the keyboard. (At the second thought, I figured out that we can 
fix this animation stuff with providing a `UIViewAnimationCurve` to `UIView`'s
animate methods.)

![Demo]({{ site.baseurl }}assets/post_images/resizing.gif)

But by adjusting only contentInset of `UITextView`, you no longer need to think about it!

## Talk is cheap, show me the code

Firstly, as you know, we need to add our lovely `UIViewController` (or probably a 
subclass of it) as observer of keyboard notifications:

```objective-c
// Register for keyboard notifications
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
```

Then our keyboard notification handler methods:

```objective-c
#pragma mark - Notifications
- (void)keyboardWillShow:(NSNotification *)note {

    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = CGRectGetHeight(keyboardFrame);
    self.textView.contentInset = contentInset;
    self.textView.scrollIndicatorInsets = contentInset;

}
- (void)keyboardWillHide:(NSNotification *)note {

    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = 0.0;

    self.textView.contentInset = contentInset;
    self.textView.scrollIndicatorInsets = contentInset;

}
```

Alternatively, you can add this piece of code to `- keyboardWillShow:` method to 
make text view auto scroll to current cursor location:

```objective-c
TimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
CGRect caretFrame = [self.textView caretRectForPosition:self.textView.selectedTextRange.start];

[UIView animateWithDuration:animationDuration
                 animations:^{
                     [self.textView scrollRectToVisible:caretFrame animated:NO];
                 }];
```

There is a problem with `UIScrollView`'s (and its subviews') `- scrollRectToVisible:animated:` method.
If you pass `YES` to animate the scrolling, it won't scroll a pixel at all.
So, I found a workaround to force it to animate with `UIView`'s animate method.

If you find some bugs, have suggestions, or any other stuff, feel free to drop a line!

