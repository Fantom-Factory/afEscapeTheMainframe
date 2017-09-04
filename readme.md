#Fanny the Fantom v0.3.0.2
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom-lang.org/)
[![pod: v0.3.0.2](http://img.shields.io/badge/pod-v0.3.0.2-yellow.svg)](http://www.fantomfactory.org/pods/afFannyTheFantom)
![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)

## Overview

Fanny the Fantom is a simple jump and duck game to test your reflexes, rendered in stunning retro 3D vector graphics. Written entirely in the Fantom programming language, Fanny the Fantom runs on both the desktop and in a browser!

![Fanny the Fantom Screenshot](http://eggbox.fantomfactory.org/pods/afFannyTheFantom/doc/screenshot.png)

*Fanny the Fantom has been captured by the evil Mainframe. Help Fanny escape dodgy programming by avoiding obstacles and collecting bonus cubes.*

*Fanny must jump and duck through 10 frantic levels in this tense retro 3D vector game.*

*Can you escape the Mainframe!?*

Visit [http://fanny.fantomfactory.org/](http://fanny.fantomfactory.org/) to play Fanny the Fantom online!

Or [download](https://bitbucket.org/AlienFactory/affannythefantom/downloads) the desktop version!

## Install

Install `Fanny the Fantom` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afFannyTheFantom

Or install `Fanny the Fantom` with [fanr](http://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afFannyTheFantom

To use in a [Fantom](http://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afFannyTheFantom 0.3"]

## Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afFannyTheFantom/) - the Fantom Pod Repository.

## About

Fanny the Fantom is a little side project I wrote to help raise awareness of the [Fantom programming language](http://fantom-lang.org/).

Fantom is great for advanced server side development, and Fantom is awesome at creating web applications. But I wanted to show that Fantom is good for the fun things too!

## Credits

- **Game Design:**  Steve & Emma Eynon
- **Coding:**  [SlimerDude](http://www.alienfactory.co.uk/aboutMe)
- **Sound Effects:**  [Modulate](https://web.facebook.com/Modulate/)
- **Music:**  [Zerocakes](https://www.fiverr.com/zerocakes)
- **Cartoon Graphics:**  [Anibal Ordaz](https://www.fiverr.com/ajordaz)

### Game Design

I've always wanted to do a simple game in Fantom, much like the interactive [Google Doodles](https://www.google.com/doodles) or the Chrome [offline T-Rex game](http://www.trex-game.skipser.com/). Only I'm no graphics artist. So I do what I usually do, and relied on my coding skills to create visual effects. I went back to some old 3D vector routines and turned them into a jump game.

My wife, Emma, helped enormously to guide the game's design and look & feel.

We wanted to incorporate Fanny the Fantom as the main character so the game had tie-in with the language. The black / blue theme is supposed to be reminiscent of [fantomfactory.org](http://www.fantomfactory.org/), and also looked suspiciously like a retro [Tron](https://en.wikipedia.org/wiki/Tron). We kept the Tron theme and decided to copy the plot, as that would help explain the blocky vector graphics.

The game play in Fanny the Fantom was initially quite speedy with blocks racing across the screen. But you could only have one, maybe two, obstacles on screen at any given time for there wasn't enough react and jump time to have more. (Fanny has to land before he can jump again!) By accident, one day I slowed everything right down and ended up having lots & lots of blocks on the screen at the same time. It looked way more impressive. And because you could see what was coming up, it was also a lot more engaging and very tricky! So it stayed this way.

We wanted a bonus scheme to break up the monotony of jump, squish, jump, squish, ... We toyed with the idea of different types of bonus cubes: extra lives, invincibility, points, ... and tried floating the cubes over at different speeds, moving them around the screen, etc. Given we expect very few people to actually complete the game, the main goal would be a hi-score, so we settled on a points only bonus. And fixing the bonus to a block seemed to add enough variety.

An absolute must was the ability to persist hi-scores so we could at least compete against each other! A separate project exposes a REST API and persists scores to a MongoDB database.

Fanny was always meant to be played in a browser, but I admit that (as I don't own a tablet or smart phone) touch devices were an after thought. As such Fanny is easier to play with a real keyboard. But hey, it's still playable on a phone, and let's face it - Fanny is not a serious commercial game; it's a cheap'n'cheerful freebie!

### Coding

Fanny the Fantom is coded by me, SlimerDude also known as Steve Eynon. *Hello!*

The game is extremely low level and does not make use of any external libraries, be they OpenGL, graphics, sound, 3D or otherwise. In fact, the only non-core library used is my own [IoC](http://eggbox.fantomfactory.org/pods/afIoc).

All 3D graphics are calculated from the one [3D matrix rotation formula](https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions):

```
y2 :=  ( y * cos(-ax)) -( z * sin(-ax))
z2 :=  ( y * sin(-ax)) +( z * cos(-ax))

x2 :=  ( x * cos(-ay)) +(z2 * sin(-ay))
z3 := -( x * sin(-ay)) +(z2 * cos(-ay))

x3 :=  (x2 * cos(-az)) -(y2 * sin(-az))
y3 :=  (x2 * sin(-az)) +(y2 * cos(-az))
```

There is no z-buffering or complex concave hidden surface removal. All objects are convex square-ish shapes with special care taken over their rendering order.

Fanny is cross platform. It runs as a desktop program (in Java) and in an internet browser (in Javascript). All development was done on the desktop because it's easier to run and debug. It then only took some 30 minutes to get it working in Javascript, and that includes writing the web server to serve it up. Thank you Fantom!

During development I was always concerned that it wouldn't run fast enough in a browser, but I actually find Fanny to run better / smoother in Javascript than what it does on the desktop!

### Sound Effects

All sounds effects and jingles are original and produced by a long standing best mate, Geoff Lee.

Geoff did the music for our [Amiga demos](http://www.alienfactory.co.uk/equinox/) when we were in high school - you can sample some of his early tunes on the Equinox  [Slammer](http://www.alienfactory.co.uk/equinox/slammer) page.

Unsurprisingly, Geoff followed his passion and became a successful international music producer and DJ, mainly under the industrial rubric of [Modulate](https://www.facebook.com/Modulate/) and the more techno inspired [QLERIK](https://www.facebook.com/QLERIK/). See [Soundcloud](https://soundcloud.com/modulate) for samples and remixes.

Geoff was naturally my first choice when it came to generating the audio side of Fanny, and after the sounds effects I was really looking forward to him producing the music too. But life happened and he became a single Dad of two wonderful twins who were (are!) far more deserving of his time, forcing me to look elsewhere.

### Music

Music is composed by the uber talented chiptune enthusiast, [Zerocakes](https://www.fiverr.com/zerocakes) who really gave the title tune a *ghostly* feel and a cartoon overture.

When it came to a tune for the main game, I was very concerned that any formal composition would soon become annoying and irritating to the player. So I thought about how the player may compose their own tune as the game progresses...

I asked Zerocakes to loop the main bass line from the title tune and create a number of musical fill-ins and melodies to play over the top. These are then played, in time with the bass line, whenever you jump or duck over an obstacle, level up, or perform a tricky manoeuvre. Throw in a quick probability function to ensure more fill-ins are played the higher the level, and you have a coherent tune that never repeats and builds up musical layers the longer a game lasts.

While plugging all this into the game tune, I was careful not to create a blatant cacophony of noise. Some may say I failed but I think it largely works!

### Cartoon Graphics

The cartoon graphics, such as the Fanny mascot himself, the background, and the mainframe computer are drawn by [Anibal Ordaz](https://www.fiverr.com/ajordaz); a talented vector artist in Venezuela.

See the [Branding page](http://fantom-lang.org/branding) on *fantom-lang.org* for examples of other Fanny cartoons, all free to download and use in your own work.

## Training Levels

The later levels can be quite fun, but not everyone has the skills to easily reach them, so we introduced training levels whereby you can trial any difficultly level.

Training mode keeps the game at the same level until you die, but any score achieved is NOT saved to the Hi-Score board. So no cheating!

## Cheat Codes

Like any decent retro game, Fanny the Fantom has cheat codes!

Enter any of the following during play to activate:

- `game over` - displays end game sequence as if you completed level 10
- `invisible` - permanently activates *ghost* mode making you impervious to obstacles
- `god mode` - like *invisible* only with a different colour scheme
- `rainbow` - multi-coloured blocks

Note that, similar to training mode, any score achieved while cheating is NOT saved to the Hi-Score board.

## Play on Desktop

If you install `afFannyTheFantom.pod` into your Fantom environment then you can launch the desktop version with the following command:

    C:\> fan afFannyTheFantom

Or you may start a local web server with:

    C:\> fan afFannyTheFantom -webServer

Fanny the Fantom may then be played locally in a browser by visiting [http://localhost:8069/](http://localhost:8069/).

