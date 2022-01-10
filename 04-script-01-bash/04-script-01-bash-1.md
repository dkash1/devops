

# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | строка |
| `d`  | 1+2  | строка |
| `e`  | 3  | () |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```
Решение:
В операциях с циклами используются квадратными скобки. Для проверки доступности раз в минуту добавим sleep 60
```bash
while [ 1=1 ]
do
        curl https://localhost:4757
        if [ $? != 0 ]
                then
                    date >> curl.log
                fi
        sleep 60
done
```
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
while [ 1=1 ]
do  
    
    for i in 192.168.0.1 173.194.222.113 87.250.250.242
    do 
        for ((j=0;j < 5;j++))
        do
        curl http://$i
            
        if [ $? != 0 ]
                then
                    date >> curl.log
                    echo $i >> curl.log
                fi
        sleep 1
        done
    done
    sleep 20
done 
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
while [ 1=1 ]
do  
    
    for i in 192.168.0.1 173.194.222.113 87.250.250.242
    do 
        for ((j=0;j < 5;j++))
        do
        curl http://$i
            
        if [ $? != 0 ]
            then
                date >> curl.log
                echo ERROR $i  >> curl.log
                exit
            fi
        sleep 1
        done
    done
    sleep 20
done
```
