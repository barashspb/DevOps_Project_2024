#!/bin/bash

#проверка, установлен ли black
if ! [ -x "$(command -v black)" ]; then
  echo 'Error: black is not installed. Install it via `pip install black`.' >&2
  exit 1
fi

#путь к папке с файлами
FILES_DIR="/devops-examples/EXAMPLE_APP"

#применение форматирования через black ко всем файлам в папке
find "$FILES_DIR" -name "*.py" -exec black {} \;
