# Gyazo for Linux

http://gyazo.com/

## Debian/Ubuntu package

[Download a deb file](https://github.com/kambara/Gyazo-for-Linux/downloads).

### Install

Install Ruby and ImageMagick before installing Gyazo.

    $ curl -s https://packagecloud.io/install/repositories/gyazo/gyazo-for-linux/script.deb.sh | sudo bash
    $ sudo apt-get install gyazo

### How to add a Gyazo icon to Ubuntu Unity Launcher

1. Open Unity Dash
2. Search "Gyazo"
3. Drag the Gyazo icon and drop into the launcher

### How to change screenshot-tool

Gyazo use `import`(imagemagick) comand by default.
If you have some trouble on screenshot such as cannot take correct area, take broken image...,try to change screenshot-tool by this way.

Revise `/src/gyazo.rb`[here](https://github.com/gyazo/Gyazo-for-Linux/blob/3451db33631a0732097ed1cfaa87326672695a27/src/gyazo.rb#L24
) like examples.

- scrot

```diff
if imagefile && File.exist?(imagefile) then
  system "convert '#{imagefile}' '#{tmpfile}'"
else
-  system "import '#{tmpfile}'"
+  system "scrot -s '#{tmpfile}'"
end

```

- gnome-screenshot

```diff
if imagefile && File.exist?(imagefile) then
  system "convert '#{imagefile}' '#{tmpfile}'"
else
-  system "import '#{tmpfile}'"
+  system "gnome-screenshot -a -f '#{tmpfile}'"
end
```

- other screenshot tools

https://wiki.archlinux.org/index.php/Taking_a_screenshot




### Contributions
Pull requests are welcome.

Gyazo for Linux is maintained by Nota Inc. But the development is not as active as that of Windows / Mac versions. We can't fix a reported problem soon.

If you want a problem fixed soon, we recommend you fix it by yourself.

We would be glad if you send a PR to this repository.

### How to release

- Create Pull Request from `master` to `release`
    - Please mark version with `git tag`
- Build package and push to packagecloud by CircleCI when it merged

## License

Copyright (c) 2014 Nota Inc.

This software is licensed under the GPL
