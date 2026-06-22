# Pure IPTV Player — Arch Linux

Кроссплатформенный IPTV-плеер на **PySide6 (Qt 6)** + **libmpv**.
Исходная версия была заточена под Windows (хардкод `D:\mpv`, `libmpv-2.dll`).
Этот вариант — нативный для **Arch Linux** с сохранением 100% исходной логики:
M3U / Xtream / Stalker плейлисты, EPG, адаптивная вёрстка под ПК/Планшет/Телефон/ТВ,
HLS-прокси с автопереподключением, переключение качества 4K↔360p в реальном времени.

---

## 🚀 Быстрая установка (Arch Linux)

### Вариант 1: Через AUR / makepkg

```bash
# Системные зависимости
sudo pacman -S --needed python python-pip python-pyside6 mpv qt6-declarative qt6-quickcontrols2 python-requests

# Python-биндинг libmpv (если нет в официальных репах — ставим через pip)
pip install --user python-mpv

# Сборка и установка пакета
cd /path/to/this/folder
makepkg -si
```

После установки плеер появится в меню приложений (раздел **Аудио и видео**),
а в терминале запускается командой:

```bash
iptv-player
```

### Вариант 2: Из исходников (без упаковки)

```bash
sudo pacman -S --needed python python-pyside6 mpv python-requests
pip install --user PySide6 python-mpv

# Запуск из директории, где лежат main.py и main.qml
python main.py
```

> ⚠️ `python-mpv` иногда отсутствует в официальных репах Arch.
> В таком случае: `yay -S python-mpv` (AUR) или `pip install --user python-mpv`.

---

## 📁 Что изменилось по сравнению с Windows-версией

| Компонент | Было (Windows) | Стало (кроссплатформенно) |
|---|---|---|
| Загрузка libmpv | Хардкод `D:\mpv\libmpv-2.dll` | Поиск через `ctypes.util.find_library("mpv")` + стандартные пути `/usr/lib/libmpv.so.2`, … |
| Путь к БД `premium.db` | Всегда в CWD | **Умная совместимость:** CWD если файл уже есть → иначе `$XDG_DATA_HOME/iptv-player/premium.db` (т.е. `~/.local/share/iptv-player/premium.db`) |
| Подсказки при ошибке | Нет | На Linux пишет: `sudo pacman -S mpv` / `yay -S python-mpv` |
| Поддержка macOS | Нет | Добавлена (через Homebrew) |
| Вся остальная логика (M3U, EPG, MPV, HLS-прокси, GPU-масштабирование, TВ-пульт) | — | **Идентична, без изменений** |

Переопределить путь к БД можно переменной окружения:

```bash
IPTV_PLAYER_DB=/path/to/your.db iptv-player
```

---

## 🛠 Системные требования

- **Arch Linux** (или производные: Manjaro, EndeavourOS)
- **Python 3.10+**
- **Qt 6.5+** (`qt6-declarative`, `qt6-quickcontrols2`)
- **mpv ≥ 0.36** (для поддержки `demuxer_lavf_o` и GPU VO)
- **OpenGL / Vulkan** драйверы для аппаратного ускорения видео
- Для Wayland: `qt6-wayland` (опционально, для нативной прозрачности OSD-окна)

### Опциональные пакеты

```bash
# Wayland
sudo pacman -S qt6-wayland

# X11 (если не установлен)
sudo pacman -S xorg-xwayland

# Кодеки (H.265/HEVC, AV1) — для воспроизведения 4K
sudo pacman -S libhevc libaom
```

---

## 🎮 Горячие клавиши

В плеере (OSD-окно):
- **↑ / ↓** — громкость
- **← / →** — предыдущий / следующий канал
- **Enter / Return** — пауза / воспроизведение
- **R** — переподключить текущий канал

В главном окне (на ПК):
- **F1** — режим «Смартфон»
- **F2** — режим «Планшет»
- **F3** — режим «ПК»
- **F4** — режим «ТВ» (полноэкранный)

---

## 🗂 Структура пакета

```
.
├── main.py                 # ← переписан под Linux: кроссплатформенная загрузка libmpv
├── main.qml                # UI (QtQuick / QtQuick.Controls.Material) — без изменений
├── PKGBUILD                # Сборка пакета: makepkg -si
├── iptv-player.desktop     # Интеграция с меню приложений (XDG)
├── iptv-player.svg         # Иконка hicolor (256×256)
├── requirements.txt        # Python-зависимости для pip
├── install.sh              # Скрипт автоустановки (см. ниже)
└── README.md               # ← вы здесь
```

---

## 🐛 Если что-то пошло не так

```bash
# Запустить из терминала и посмотреть вывод
iptv-player

# Проверить, что libmpv найден
ldconfig -p | grep libmpv
# Ожидаемый вывод: libmpv.so.2

# Если libmpv нет:
sudo pacman -S mpv

# Если python-mpv не импортируется:
pip install --user python-mpv
python -c "import mpv; print(mpv.__version__)"
```

Сброс базы данных (⚠️ удалит все ваши плейлисты):

```bash
rm ~/.local/share/iptv-player/premium.db
```

---

## 📜 Лицензия

**Unlicense** — это публичное достояние (public domain dedication).
Делайте с кодом что хотите: копируйте, модифицируйте, продавайте, используйте в коммерческих проектах.
Полный текст: <https://unlicense.org>
