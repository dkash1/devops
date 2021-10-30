# devops
TEST TEST TEST

.gitignore позволяет закоммитить все кроме  перечисленных типов файлов
указанных в данном файле.
*.html

# Игнорировать каталог node_modules 
node_modules/ 

# Игнорирование логов 
logs 
*.log 

# Игнорирование каталога со сборкой проекта
/dist 

# В этом файле можно оставлять комментарии
# Каждая строчка — это шаблон, по которому происходит игнорирование

# Игнорируется файл в любой директории проекта
access.log

# Игнорируется директория в любой директории проекта
node_modules

# Игнорируется директория в корне git-репозитория
/coverage

# Игнорируются все файлы с расширением sqlite3 в директории db,
# но не игнорируются такие же файлы внутри любого вложенного каталога в db
# например, /db/something/lala.sqlite3
/db/*.sqlite3

# игнорировать все .txt файлы в каталоге doc/
# на всех уровнях вложенности
doc/**/*.txt 
