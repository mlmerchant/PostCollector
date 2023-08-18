# PostCollector
This repository contains a script that downloads a Reddit post and formats it in the required format for an application (Text2VideoNarrator) that automatically generates narrated (Text-to-Voice) YouTube videos of the Reddit post.

## Table of Contents

1. [About](#about)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)
6. [License](#license)
7. [Contact](#contact)

## About

The script in this repository is designed to streamline the process of converting Reddit posts into YouTube videos. It works in conjunction with another script found [here](https://github.com/mlmerchant/Text2VideoNarrator).

## Prerequisites

- Tested on PowerShell 7.2
- Tested on Microsoft Word 2019

## Installation

1. Clone the repository:
```sh
   git clone https://github.com/mlmerchant/PostCollector.git
```

## Usage
```sh
  ./PostCollector.ps1 -url https://www.reddit.com/path/to/post/
```
The script will then download and format the contents of the reddit post into a word document.  Lines that exceed the line length limits of the Text2VideoNarrator and require manual intervention will be colored blue. Ensure that you manually split those lines at a natural place before cutting and pasted the contents of the word document into new text file for the Text2VideoNarrator script.

## License
Distributed under the MIT License. See `LICENSE` for more information.
