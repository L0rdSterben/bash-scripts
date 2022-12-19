#!/bin/bash

# Возвращение вывода к стандартному форматированию
NORMAL='\033[0m'      # ${NORMAL}

# Цветом текста (жирным) (bold) :
WHITE='\033[1;37m'    # ${WHITE}

# Цвет фона
BGRED='\033[41m'      # ${BGRED}
BGGREEN='\033[42m'    # ${BGGREEN}
BGBLUE='\033[44m'     # ${BGBLUE}

tg="/root/telegram.sh"
# Получаем статус веб-сервера через systemd  записываем его в переменную.
nginxstatus=`systemctl status nginx | grep -Eo "running|dead|failed"`
			if [[ $nginxstatus = 'running' ]]
				then
					echo -en  "${WHITE} ${BGGREEN} Веб сервер работает ${NORMAL}\n"
				else
					$tg "Nginx не работает" > /dev/null
					echo -en "${WHITE} ${BGRED} nginx не работает ${NORMAL}\n"
					systemctl restart nginx # Перезапуск nginx
					sleep 1 #  Ожидаем 1 секунду, чтобы сервер точно запустился.
					echo -en "${WHITE} ${BGGREEN} Статус Nginx после перезапуска $(systemctl status nginx | grep -Eo "running|dead|failed") ${NORMAL}\n"
					echo $(curl -I 100.70.7.255 | grep OK) # Проверяем отдает ли веб-сервер http код 200
					$tg "Статус Nginx после перезапуска $(systemctl status nginx | grep -Eo "running|dead|failed")!!" > /dev/null
			fi
# Получаем статус php через systemd  записываем его в переменную.
phpfpmstatus=`systemctl status php8.1-fpm | grep -Eo "running|dead|failed"`

			if [[ $phpfpmstatus = 'running' ]]
				then
					echo -en  "${WHITE} ${BGGREEN} php8.1-fpm работает ${NORMAL}\n"
				else
					$tg "Статус php8.1-fpm $phpfpmstatus. Пробуем перезапустить..." > /dev/null
					echo -en "${WHITE} ${BGRED} Статус php8.1-fpm $phpfpmstatus Пробуем перезапустить. ${NORMAL}\n"
					systemctl restart php8.1-fpm # Перезапуск php7.2-fpm
					sleep 1 #  Ожидаем 1 секунду, чтобы php7.2-fpm точно запустился.
					echo -en "${WHITE} ${BGGREEN} Статус php8.1-fpm после перезапуска $(systemctl status php8.1-fpm | grep -Eo "running|dead|failed") ${NORMAL}\n"
					$tg "Статус php8.1-fpm после перезапуска $(systemctl status php8.1-fpm | grep -Eo "running|dead|failed")!!" > /dev/null
			fi
