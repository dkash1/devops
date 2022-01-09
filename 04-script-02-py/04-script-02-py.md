### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | ошибка т.к. складывают число и строку |
| Как получить для переменной `c` значение 12?  | c = str(a) + b |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
import os

def check_git(dir):
    bash_command = [f"cd {dir}", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
    prepare_result = []
    print(f"Директория {dir}")
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result.append(result.replace('\tmodified:   ', ''))
            is_change = True

    if is_change:
        print("Изменено:\n" + "\n".join(prepare_result))

work_dir = "C:\Users\dkash\Desktop\devops\devops-netology"
check_git(work_dir)
```

### Вывод скрипта при запуске при тестировании:
```
$ python 04-script-02-py/script/main.py 
Директория C:\Users\dkash\Desktop\devops\devops-netology
Изменено
.gitignore
04-script-01-bash/04-script-01-bash.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
import os
import sys

def check_dir(dir):
    try:
        os.chdir(dir)
    except FileNotFoundError:
        print("Директория не найдена")
        sys.exit(1)

def check_git(dir):
    print(f"Директория {dir}")
    check_dir(dir)
    result_os = os.popen("git status").read()
    if not result_os:
        print("В папке не обнаружена инициализация git")
        sys.exit(1)
    is_change = False
    prepare_result = []
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result.append(result.replace('\tmodified:   ', ''))
            is_change = True
    if is_change:
        print("Изменено:\n" + "\n".join(prepare_result))
    else:
        print("Изменений не найдено")

check_git(sys.argv[1])
```

### Вывод скрипта при запуске при тестировании:
```
devops@dkash MINGW64 ~/Desktop/devops-netology (main)
$ python 04-script-02-py/script/main.py "C:\Users\dkash\Desktop"
Директория C:\Users\dkash\Desktop
fatal: not a git repository (or any of the parent directories): .git
В папке не обнаружена инициализация git

devops@dkash MINGW64 ~/Desktop/devops/devops-netology (main)
$ python 04-script-02-py/script/main.py "C:\Users\dkash\Desktop\devops\devops-netology"
Директория C:\Users\dkash\Desktop\devops\devops-netology
Изменено:
.gitignore
04-script-01-bash/04-script-01-bash.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import socket
import time
import datetime
import logging
i = 1
wait = 2 
srv = {
    'drive.google.com': '0.0.0.0',
    'mail.google.com': '0.0.0.0',
    'google.com': '0.0.0.0'
}

print(f"Run\nCheck hosts {srv}\n")

while True:
    for host in srv:
        ip = socket.gethostbyname(host)
        if ip != srv[host]:
            logging.error(f'{datetime.datetime.now()} {host} IP mistmatch: {srv[host]} -> {ip}')
            srv[host] = ip
    time.sleep(wait)
```

### Вывод скрипта при запуске при тестировании:
```
Run
Check machines {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}

ERROR:root:2022-01-09 10:02:38.752174 drive.google.com IP mistmatch: 0.0.0.0 -> 142.250.190.14
ERROR:root:2022-01-09 10:02:38.764264 mail.google.com IP mistmatch: 0.0.0.0 -> 172.217.1.197
ERROR:root:2022-01-09 10:02:38.776444 google.com IP mistmatch: 0.0.0.0 -> 142.250.191.142
ERROR:root:2022-01-09 10:02:40.790746 drive.google.com IP mistmatch: 142.250.190.14 -> 142.250.188.206
ERROR:root:2022-01-09 10:02:40.803517 mail.google.com IP mistmatch: 172.217.1.197 -> 142.251.111.18
ERROR:root:2022-01-09 10:02:40.815512 google.com IP mistmatch: 142.250.191.142 -> 172.217.9.206
ERROR:root:2022-01-09 10:02:42.829096 drive.google.com IP mistmatch: 142.250.188.206 -> 142.251.33.206
ERROR:root:2022-01-09 10:02:42.841491 mail.google.com IP mistmatch: 142.251.111.18 -> 142.250.191.229
ERROR:root:2022-01-09 10:02:42.854766 google.com IP mistmatch: 172.217.9.206 -> 142.250.188.206
ERROR:root:2022-01-09 10:02:44.868624 drive.google.com IP mistmatch: 142.251.33.206 -> 142.251.45.110