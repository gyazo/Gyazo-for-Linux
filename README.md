# Gyazo for Linux

http://gyazo.com/

### Install

Install Ruby and ImageMagick before installing Gyazo.

    $ curl -s https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh | sudo bash
    $ sudo apt-get install gyazo

### How to add a Gyazo icon to Ubuntu Unity Launcher

1. Open Unity Dash
2. Search "Gyazo"
3. Drag the Gyazo icon and drop into the launcher

### Install

Install Ruby and ImageMagick before installing Gyazo.

    $ sudo yum install ruby ImageMagick
    $ sudo yum localinstall gyazo-XXX.rpm

## Contributions
Pull requests are welcome.

Gyazo for Linux is maintained by Nota Inc. But the development is not as active as that of Windows / Mac versions. We can't fix a reported problem soon.

If you want a problem fixed soon, we recommend you fix it by yourself.

We would be glad if you send a PR to this repository.

### How to release

- Create Pull Request from `master` to `release`
    - Please mark version with `git tag`
- Build package and push to packagecloud by CircleCI when it merged

## License

Copyright (c) 2015 Nota Inc.

This software is licensed under the GPL
