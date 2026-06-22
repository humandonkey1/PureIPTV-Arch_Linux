#!/usr/bin/env bash
# Pure IPTV Player — установщик для Arch Linux.
# Запускать из директории, где лежат main.py, main.qml, PKGBUILD и пр.

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_step()  { echo -e "${CYAN}==>${NC} $1"; }
print_ok()     { echo -e "${GREEN}✅${NC} $1"; }
print_warn()   { echo -e "${YELLOW}⚠️${NC}  $1"; }
print_err()    { echo -e "${RED}❌${NC} $1"; }

# --- 1. Проверяем, что мы на Arch ---
if [ ! -f /etc/arch-release ] && ! grep -qi "arch" /etc/os-release 2>/dev/null; then
    print_warn "Похоже, это не Arch Linux. Скрипт оптимизирован под Arch/pacman."
    read -rp "Продолжить всё равно? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || exit 1
fi

# --- 2. Устанавливаем системные зависимости ---
print_step "Устанавливаю системные пакеты через pacman..."
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    python-pyside6 \
    python-requests \
    mpv \
    qt6-declarative \
    qt6-quickcontrols2 \
    2>&1 | tail -20

print_ok "Системные пакеты установлены"

# --- 3. Устанавливаем python-mpv через pip (если не в репах) ---
print_step "Проверяю python-mpv…"
if python -c "import mpv" 2>/dev/null; then
    print_ok "python-mpv уже установлен"
else
    print_step "Ставлю python-mpv через pip…"
    pip install --user python-mpv 2>&1 | tail -5 || {
        print_warn "pip не смог установить python-mpv."
        print_warn "Попробуйте вручную: yay -S python-mpv  (если установлен yay)"
    }
fi

# --- 4. (опционально) Собираем Arch-пакет через makepkg ---
if [ -f PKGBUILD ]; then
    print_step "PKGBUILD найден — собираю .pkg.tar.zst (makepkg -si)…"
    if command -v makepkg >/dev/null 2>&1; then
        makepkg -si --noconfirm 2>&1 | tail -25 || {
            print_warn "Сборка пакета не удалась — это не критично, скрипт ниже запустит плеер напрямую."
        }
    else
        print_warn "makepkg не найден (нужен пакет pacman-contrib). Пропускаю сборку."
    fi
else
    print_warn "PKGBUILD не найден в текущей директории — пропускаю сборку пакета."
fi

# --- 5. Готово ---
echo
print_ok "Установка завершена!"
echo
echo -e "  ${CYAN}Запустить плеер:${NC}"
echo -e "    iptv-player           (если пакет установлен)"
echo -e "    python main.py        (напрямую из исходников)"
echo
echo -e "  ${CYAN}База данных:${NC}"
echo -e "    ~/.local/share/iptv-player/premium.db"
echo
echo -e "  ${CYAN}Если libmpv не найден:${NC}"
echo -e "    sudo pacman -S mpv"
echo
