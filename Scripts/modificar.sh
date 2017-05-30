#!/bin/bash

echo "Nombre de usuario" #Pregunta por el nombre
read nombre

if [ -z $nombre ] #Revisa que el mismo no sea vacio
then

	echo "El nombre no puede ser vacio"
else
	passwdRead=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`

	if [ -z $passwdRead ] #Revisa que exista previamente
	then

		echo "El nombre de usuario no existe"

	else #Si existe continua

		echo "Cambiar Grupo Primario"
		read grupo
		if [ -z $grupo ]
		then

			grupo=""
		else


		groupReadName=`cat /etc/group | cut -d ':' -f 1 | grep "$grupo"`
		groupReadGID=`cat /etc/group | cut -d ':' -f 3 | grep "$grupo"`

		if [ -z $groupReadName ] && [ -z $groupReadGID ]
		then
			echo "El grupo no existe, se mantiene el anterior"

		else

			grupo=" -g $grupo"
		fi
		fi
			echo "Cambiar Home"
			read home

			if [ -r $home ]
			then
				home=""
			else
				home=" -d $home"
			fi

			echo "Cmabiar Grupo Secundario"
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
			echo "Cambiar comentario"
			read comentario

			if [ -r $comentario ]
			then
				comentario=""
			else
				comentario="-c $comentario"
			fi

			echo "Cambiar Tipo de shell"
			read shell

			if [ -r $shell ]
			then
				shell="-s /bin/bash"
			else
				shell=" -s $shell"
			fi

			PassWD=`cat /etc/passwd | cut -d ':' -f 1 | grep $nombre`
			cambiar="$nombre $grupo $home $secundario $comentario $shell" 
			usermod $cambiar



			echo "Usuario modificado satisfactoriamente"

			echo "$UID;$USER;$DATE;$TIME;$SHELL;$SSH_CONNECTION;usermod $cambiar" >> /var/log/ScriptLogic.log

			#echo "Ocurrio un error el usuario no fue agregado correctamente, intentelo nuevamente"


	fi #Fin, existe previamente

fi #Fin, nombre vacio

