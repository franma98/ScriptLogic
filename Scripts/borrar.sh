#!/bin/bash

echo "Nombre de usuario a eliminar"
read nombre

echo "Desea conservar los archivos del usuario"
echo "Si"
echo "No"
read opcion

if [ $opcion = "Si" ]
then
	userdel $nombre
	PassWD=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`

	if [ -r $PassWD ] 
	then
		echo "Usuario borrado satisfactoriamente"
		echo "$UID;$USER;$DATE;$TIME;$SHELL;$SSH_CONNECTION;userdel $nombre" >> /var/log/ScriptLogic.log
	else
		echo "Ocurrio un error el usuario no fue eliminado correctamente, intentelo nuevamente"
	fi
elif [ $opcion = "No" ]
then
	userdel -r $nombre
	PassWD=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`

	if [ -r $PassWD ]
	then
		echo "Usuario borrado satisfactoriamente"
		echo "$UID;$USER;$DATE;$TIME;$SHELL;$SSH_CONNECTION;userdel -r $nombre" >> /var/log/ScriptLogic.log
	else
		echo "Ocurrio un error el usuario no fue eliminado correctamente, intentelo nuevamente"
	fi

else

echo "Debe seleccionar una de las opciones"

fi


