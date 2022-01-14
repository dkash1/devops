
# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Решение:
```json
{
    "info": "Sample JSON output from our service\t",
    "elements": [
        {
            "name": "first",
            "type": "server",
            "ip": "7175" # <
        }, # <
        {
            "name": "second",
            "type": "proxy",
            "ip": "71.78.22.43" # <
        }
    ]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import socket
import time
import datetime
import logging
import json
import yaml


def save_data_json(data: dict):
    with open("service.json", "w", encoding="utf-8") as file:
        file.write(json.dumps(data, indent=4, ensure_ascii=False))


def save_data_yml(data: dict):
    with open("service.yml", "w", encoding="utf-8") as file:
        file.write(yaml.safe_dump(data))


i = 1
wait = 2  # интервал проверки в секундах
data_check = "json"  # or yml
if data_check == "json":
    with open("service.json", encoding="utf-8") as file:
        srv = json.loads(file.read())
else:
    with open("service.yml", encoding="utf-8") as file:
        srv = yaml.full_load(file.read())

print(f"Run\nCheck hosts {srv}\n")

while True:
    for host in srv:
        ip = socket.gethostbyname(host)
        if ip != srv[host]:
            logging.error(
                f'{datetime.datetime.now()} {host} IP mistmatch: {srv[host]} -> {ip}')
            srv[host] = ip
            print(f"запись в файл {data_check}")
            if data_check == "json":
                save_data_json(srv)
            else:
                save_data_yml(srv)
    time.sleep(wait)

```

### Вывод скрипта при запуске при тестировании:
```
$ python main.py 
Start script
Check hosts {'drive.google.com': '0.0.0.0', 'google.com': '142.250.74.142', 'mail.google.com': '142.250.74.101'}

ERROR:root:2022-01-14 14:01:39.720735 drive.google.com IP mistmatch: 0.0.0.0 -> 142.250.74.46
Запись в файл yml
--------------------
$ python main.py 
Start script
Check hosts {'drive.google.com': '0.0.0.0', 'mail.google.com': '142.250.74.101', 'google.com': '142.250.74.142'}

ERROR:root:2022-01-14 14:03:11.497721 drive.google.com IP mistmatch: 0.0.0.0 -> 142.250.74.46
Запись в файл json
```


### json-файл(ы), который(е) записал ваш скрипт:
```json
{
    "drive.google.com": "142.250.74.46",
    "mail.google.com": "142.250.74.101",
    "google.com": "142.250.74.142"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 142.250.74.46
google.com: 142.250.74.142
mail.google.com: 142.250.74.101
```

