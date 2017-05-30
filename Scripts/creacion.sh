#!/bin/bash

echo "Nombre de usuario" #Pregunta por el nombre
read nombre

if [ -z $nombre ] #Revisa que el mismo no sea vacio
then

	echo "El nombre no puede ser vacio"
else
	passwdRead=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`

	if [ ! -z $passwdRead ] #Revisa que no exista previamente
	then

		echo "El nombre de usuario ya existe"

	else #Si no existe continua

		echo "Grupo Primario"
		read grupo

		if [ -r $grupo ]
		then
			echo "El grupo primario no puede ser vacio"
		else
		groupReadName=`cat /etc/group | cut -d ':' -f 1 | grep "$grupo"`
		groupReadGID=`cat /etc/group | cut -d ':' -f 3 | grep "$grupo"`

		if [ -z $groupReadName ] && [ -z $groupReadGID ]
		then
			echo "El grupo no existe"

		else

			grupo=" -g $grupo"

			echo "Home (por defecto /home/NombreDeUsuario)"
			read home

			if [ -r $home ]
			then
				home=""
			else
				home=" -d $home"
			fi

			echo "Grupo Secundario (opcional)"
			read secundario

			if [ -r $secundario ]
			then
				secundario=""
			else
				groupReadName=`cat /etc/group | cut -d ':' -f 1 | grep $secundario`
				groupReadGID=`cat /etc/group | cut -d ':' -f 3 | grep $secundario`

				if [ -r $groupReadName] && [ -r $groupReadGID ]
				then
					echo "El grupo elegido no existe"
				else
					secundario=" -G $secundario"
				fi

			fi
			echo "Comentario (opcional)"
			read comentario

			if [ -r $comentario ]
			then
				comentario=""
			else
				comentario="-c $comentario"
			fi

			echo "Tipo de shell (por defecto bash)"
			read shell

			if [ -r $shell ]
			then
				shell="-s /bin/bash"
			else
				shell=" -s $shell"
			fi

			PassWD=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`
			agregar="$nombre $grupo $home $secundario $comentario $shell -m" 
			useradd $agregar


			if [ -r $PassWD ]
		        then
					echo "Usuario agregado satisfactoriamente"
					echo "Eliga un contraseña"
					passwd $nombre
					echo "$UID;$USER;$DATE;$TIME;$SHELL;$SSH_CONNECTION;useradd $agregar passwd $nombre" >> /var/log/ScriptLogic.log
       			else
					echo "Ocurrio un error el usuario no fue agregado correctamente, intentelo nuevamente"
       			fi

		fi #Fin, grupo primario

		fi #Fin, grupo primario vacio
	fi #Fin, existe previamente

fi #Fin, nombre vacio

