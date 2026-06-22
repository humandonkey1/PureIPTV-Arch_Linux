# Maintainer: Pure IPTV Player contributors
pkgname=iptv-player
_pkgname=pure-iptv-player
pkgver=1.0.0
pkgrel=1
pkgdesc="Modern IPTV player with adaptive layout for PC, Tablet, Phone and TV. Powered by PySide6 (Qt6) + libmpv."
arch=('any')
url="https://github.com/example/iptv-player"
license=('Unlicense')
depends=(
    'python'
    'python-pyside6'
    'mpv'
    'python-requests'
    'qt6-declarative'
    'qt6-quickcontrols2'
)
makedepends=()
optdepends=(
    'python-mpv: Python bindings for libmpv (recommended)'
    'python-pip: to install python-mpv via pip if not in repos'
)
provides=("$_pkgname")
conflicts=("$_pkgname")
source=("main.py"
        "main.qml"
        "iptv-player.desktop"
        "iptv-player.svg")
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

package() {
    # Application files
    install -dm755 "$pkgdir/usr/share/$_pkgname"
    install -Dm644 main.py  "$pkgdir/usr/share/$_pkgname/"
    install -Dm644 main.qml "$pkgdir/usr/share/$_pkgname/"

    # Desktop integration
    install -Dm644 iptv-player.desktop "$pkgdir/usr/share/applications/iptv-player.desktop"
    install -Dm644 iptv-player.svg     "$pkgdir/usr/share/icons/hicolor/scalable/apps/iptv-player.svg"

    # Launcher script (executes the Python entrypoint with the right CWD for main.qml)
    install -dm755 "$pkgdir/usr/bin"
    cat > "$pkgdir/usr/bin/iptv-player" << 'EOF'
#!/bin/sh
exec /usr/bin/python /usr/share/pure-iptv-player/main.py "$@"
EOF
    chmod 755 "$pkgdir/usr/bin/iptv-player"

    # License stub (Unlicense — public domain dedication)
    install -dm755 "$pkgdir/usr/share/licenses/$_pkgname"
    cat > "$pkgdir/usr/share/licenses/$_pkgname/LICENSE" << 'EOF'
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

For more information, please refer to <https://unlicense.org>
EOF
}

post_install() {
    cat << 'EOM'
==> Installation notes for iptv-player:
    1. Install the Python libmpv bindings:
         sudo pacman -S python-pip
         pip install --user python-mpv
       (or, if available in your repos/AUR: sudo pacman -S python-mpv)
    2. Launch from the application menu, or via:
         iptv-player
    3. Database is stored at:
         $XDG_DATA_HOME/iptv-player/premium.db
       (defaults to ~/.local/share/iptv-player/premium.db)
EOM
}
