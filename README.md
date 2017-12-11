# Gyazo for Linux

[![Circle CI](https://circleci.com/gh/gyazo/Gyazo-for-Linux.svg?style=svg)](https://circleci.com/gh/gyazo/Gyazo-for-Linux)

https://gyazo.com/

## Install

### `apt-get` Install

- `curl -s https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh | sudo bash`
- `sudo apt-get install gyazo`

### `yum` Install

- `curl -s https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.rpm.sh | sudo bash`
- `sudo yum install gyazo`

### Add the Gyazo Icon to the Unity Launcher

1. Open the Unity Dash
2. Search "Gyazo"
3. Drag the Gyazo icon and drop it into the launcher

### :warning: Troubleshooting

#### Failed to Install

- Please refer to [this issue](https://github.com/gyazo/Gyazo-for-Linux/issues/35).
  - Install `deb` package, write `os` to `ubuntu` and `version` to `trusty`
  - Install `rpm` package, write `os` to `el` and `version` to `6`

#### Change your Screenshot Command/Tool

Gyazo uses the `import` (imagemagick) command/tool by default. If you have trouble using Gyazo when taking screenshots, such as it not taking the correct area, a broken image being taken, or something irregular, try changing your screenshot tool following these steps before submitting an Issue.

Change screenshot command with `$HOME/.gyazo.config.yml`, as shown below.

- `scrot`

```yaml
command: scrot -s
```

- `gnome-screenshot`

```yaml
command: gnome-screenshot -a -f
```

- `xfce4-screenshooter`

```yaml
command: xfce4-screenshooter -r -o gyazo
```

- [Other Screenshot Tools](https://wiki.archlinux.org/index.php/Taking_a_screenshot)

## Contributing

Gyazo for Linux is maintained by Nota Inc., but the development is not as active as the Windows and Mac versions of Gyazo. Fixes for reported problems and issues may take longer than usual. If you would like a problem fixed soon, we recommend you attempt to fix it and pull request the fix.

Pull requests are welcome and encouraged.

### How to Release


- Create a pull request to bump version:
  - Change version numbers (e.g. https://github.com/gyazo/Gyazo-for-Linux/pull/96/files)
  - Modify changelog
- And merge it to master
- Create a pull request from `master` to `release`
    - Mark the version using `git tag`
- Build the package and push it to PackageCloud through CircleCI after it's merged

## License

Copyright (c) 2015 Nota Inc. All rights reserved.

Gyazo-for-Linux is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

Gyazo-for-Linux is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Gyazo-for-Linux; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
