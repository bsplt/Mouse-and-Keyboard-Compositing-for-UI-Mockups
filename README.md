# Realistic Mouse and Keyboard Composting for animated UI mockups
Have you ever had the problem that you had to animate mouse movement and keyboard typing by hand and it didn't look right? It happened to be several times when I had to work on UI demonstrations in After Effects. It is super hard to animate the natural movements and pauses a hand does on the interface. That's why I wrote these programs. What they basically do is record your input and render it nicely for compositing.

## Getting started
In the repository you'll find two [Processing](https://processing.org/) sketches with similar function. They are slightly different in their requirements though. But in general they do one thing: They record you typing or clicking/moving your mouse and render it on transparent PNGs so that you can easily import the sequence into After Effects or your tool of choice.

### keyRender
This program needs no further setting up, it works out of the box. It is this simple: Run the sketch and start typing. Line wraps, backspace, etc, every input gets recorded. Once you press `ESC` everything will be rendered in a folder called `save` into your sketch folder. That's it. You'll have a natural looking typing animation.

Customizing the program to your needs is pretty easy. Things to do:
* Change the font: It's a file called `font.ttf` inside your `data` folder of your sketch. Included in this repository is the font [Karla](https://fonts.google.com/specimen/Karla).
* Change the layout: The layout gets determined by the `size()` function inside Processing's `setup()` which sets the pixel width and height of the window that will be rendered. So it's good to adjust it to the rest of your animation parameters. On the top of the file you'll find the `layoutPadding` and `maxLineWidth` parameters which set the margin from window border, illustrated by a gray line, that will not be rendered.
* Change the typography: The parameters `fontSize`, `lineHeight` and `letterSpacing` are the basic tools to change the appearance for you typography.
* Change the timeBase: The `timeBase` parameter sets the frame rate in which the animation will be rendered. Default is 60 fps, change it to your project requirements.
Consider that rendering will take a while.
![Example animation of the keyboard program](https://raw.githubusercontent.com/bsplt/Mouse-and-Keyboard-Compositing-for-UI-Mockups/master/examples/KeyboardExample.gif?raw=true)

### mouseRender
This program is a little more complicated as you generally want to know where you should move your mouse. That's why there is a sort of slide show in the background. For using it as compositing tool you want to put each state of the the UI that depends on mouse clicks into the `mockups` folder. I included some of the files of the video you can see below as example. As soon as you run the sketch your mouse movement gets recorded. When you click a mouse button the next image from the `mockups` folder will be shown in the background so that you know where to move the mouse next. Once you press `r` every movement and click will be recorded and once you press `r` again it will be rendered in a folder called `save` into your sketch folder where you also find a file called `mouseclicks.txt` which tells you the exact frames of your clicks. That's it.

Customizing the program to your needs is pretty easy. Things to do:
* Change the mouse icon: In the `data` folder you'll find a file named `mouse.png`. You can change this or specify another path on the top of the code with the `mouseImage` parameter.
* Change the timeBase: The `timeBase` parameter sets the frame rate in which the animation will be rendered. Default is 60 fps, change it to your project requirements.
Consider that rendering will take a while.
![Example animation of the mouse program](https://raw.githubusercontent.com/bsplt/Mouse-and-Keyboard-Compositing-for-UI-Mockups/master/examples/MouseExample.gif?raw=true)

## Example
I used the software in this animation I made for an interaction design class, check it out:


[![Example](http://img.youtube.com/vi/lwESUN0Did0/maxresdefault.jpg)](https://www.youtube.com/watch?v=lwESUN0Did0)

## Further information
Please feel free to contact me if you have questions or suggestions.

License is according to the software used.