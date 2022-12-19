#!/bin/bash

otkuda="/app/"

kuda="/mnt/backup"

which_dir="dir1 dir2 dir3 dir4 dir5"

mkdir -p $kuda/$(date +"%Y-%m-%d")

backup_dir="$kuda/$(date +"%Y-%m-%d")"

for dir in $which_dir;
do
	echo копируем $otkuda$dir в $backup_dir
	rsync -avh $otkuda$dir $backup_dir
done

tar -cvzf $kuda/backup_$(date +"%Y-%m-%d").tar.gz $backup_dir

cp $kuda/backup_$(date +"%Y-%m-%d").tar.gz /root/Yandex.Disk

rm -rf $backup_dir

yandex-disk stop
yandex-disk start

ls -l /root/Yandex.Disk

# Получаем список бекапов из папки, в которой они хранятся.
backup_list=$(ls /root/Yandex.Disk/ | grep backup)

# Создаем переменную с текущим месяцем
month=$(date +"%m")

# Задаем дату, когда бекап будет считаться устаревшим.
expire_date=$(date +"%d" -d '-3 day')
echo "Удаляем бекапы, старше $(date +"%d.%m.%Y" -d '-3 day')"

for file in $backup_list; do

# Получаем дату бекапа
backup_date=$(echo $file | awk -F"-" '{print $2}')

echo "backup_2022-$backup_date-$month.tar.gz"

# Создаем условие, если переменная backup_date меньше чем expire_date
# тогда удаляем файл бекапа
if [[ $backup_date < $expire_date ]]
then
    echo "Удаляем файл  backup_2022-$backup_date-$month.tar.gz"
    rm -f /root/Yandex.Disk/backup_2022-$backup_date-$month.tar.gz
fi

done


curl -s -H "Authorization: OAuth y0_AgAAAAAjHR9gAAh_rQAAAADRVtzhetPsQ56kR1yXYQB2FlJE735g_KM" -X "DELETE" https://cloud-api.yandex.net/v1/disk/trash/resources/?path=
