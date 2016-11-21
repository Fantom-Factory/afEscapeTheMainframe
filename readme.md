#Fanny the Fantom v0.1.0
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom-lang.org/)
[![pod: v0.1.0](http://img.shields.io/badge/pod-v0.1.0-yellow.svg)](http://www.fantomfactory.org/pods/afFannyTheFantom)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

Fanny the Fantom is a 3D vector jump game, written enirely in the Fantom programming language, that runs on both the desktop and in a browser!

![Fanny the Fantom Screenshot](http://pods.fantomfactory.org/pods/afFannyTheFantom/doc/screenshot.jpg)

Visit [http://fanny.fantomfactory.org/](http://fannt.fantomfactory.org/) to play Fanny the Fantom online!

Or [download](https://bitbucket.org/AlienFactory/affannythefantom/downloads) to play the desktop version.

## Install

Install `Fanny the Fantom` with the Fantom Pod Manager ( [FPM](http://pods.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afFannyTheFantom

Or install `Fanny the Fantom` with [fanr](http://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://pods.fantomfactory.org/fanr/ afFannyTheFantom

To use in a [Fantom](http://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afFannyTheFantom 0.1"]

## Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afFannyTheFantom/) - the Fantom Pod Repository.

## About

Fanny the Fantom is a side project I wrote to help raise awareness of the [Fantom programming language](http://fantom-lang.org/).

Yes, Fantom is great for advanced server side development. Yes, Fantom is awesome at creating web applications. But I wanted to show that Fantom is good for fun things too!

## Credits

- **Game Design:**  Steve & Emma Eynon
- **Coding:**  [SlimerDude](http://www.alienfactory.co.uk/)
- **Sound Effects:**  [Modulate](https://web.facebook.com/Modulate/)
- **Cartoon Graphics:**  [Ajordaz](https://www.fiverr.com/ajordaz)

## Fantom Development

If you install the Fanny the Fantom pod into your Fantom environment then you can launch the desktop version with the following command:

    C:\> fan afFannyTheFantom

Or you may start a web server with:

    C:\> fan afFannyTheFantom -webServer

Then Fanny the Fantom may be played in a browser by visiting [http://localhost:8069/](http://localhost:8069/).

