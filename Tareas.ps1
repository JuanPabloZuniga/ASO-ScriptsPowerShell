function CrearTarea {
	clear-Host
	write-Host "`nSe va a proceder a la creación de la tarea`n"
	$Action = New-ScheduledTaskAction -Execute $global:accion
	Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $global:Ntarea
	"`nTarea programada $Ntarea creada para ejecutarse a las $global:horaUsuario.`n"
	pause
	& 'C:\Users\TFG\Desktop\TfG\menu_tareas.ps1'
}

function horas{
	do{
		clear-Host
		$global:horaUsuario = Read-Host "`nIndique la hora que desea realizar la tarea"
		if ($global:horaUsuario -match "^([0-1][0-9]|2[0-3]):([0-5][0-9])$") {
			Write-Host "`nHora válida: $horaUsuario`n"
			return
		} else {
			Write-Host "`nHora no válida. Introduzca una hora en formato HH:MM.`n"
			pause
		}
	}while($true)
}

function Mes {
	do {
		clear-host
		$diasM = Read-Host "`nIngrese los días del mes que desee ejecutar la tarea separados por comas (por ejemplo, 1,2,3)(c para volver)"
		# Verificar entrada
		if ($diasM -match '^(0?[1-9]|1[0-9]|2[0-9]|3[0-1])(,(0?[1-9]|1[0-9]|2[0-9]|3[0-1]))*$') {
			break
		} elseif ($diasM -ieq "c"){
				& "C:\Users\TFG\Desktop\TfG\menu_tareas.ps1"
			} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
			$error = "Formato de listado incorrecto"
			& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
	} while ($true)
	
	
	$nums = $diasM -split ","
	
	
	foreach ($numero in $nums) {
		$nombreTarea = "$global:Ntarea" + "$numero"  # Nombre de la tarea
		
		
		$comando = "schtasks /create /tn $nombreTarea /tr `"$global:accion`" /sc monthly /mo 1 /d $numero /st $global:horaUsuario"
		
		
		Invoke-Expression $comando | Out-Null
	}
	
	
	write-Host "`nTarea programada $Ntarea creada para ejecutarse a las $global:horaUsuario.`n"
	pause
	& 'C:\Users\TFG\Desktop\TfG\menu_tareas.ps1'
}

function Semana{
		do {
			clear-host
		write-Host "========================================"
		write-Host "	DIAS DE SEMANA"
		write-Host "========================================"
		write-Host "1. Lunes"
		write-Host "2. Martes"
		write-Host "3. Miércoles"
		write-Host "4. Jueves"
		write-Host "5. Viernes"
		write-Host "6. Sábado"
		write-Host "7. Domingo"
		write-Host "========================================"
		$dias = @{
			"1" = "Monday"
			"2" = "Tuesday"
			"3" = "Wednesday"
			"4" = "Thursday"
			"5" = "Friday"
			"6" = "Saturday"
			"7" = "Sunday"
		}
			$entrada = Read-Host "Introduce una lista de números separados por comas (por ejemplo, 1,2,3,5) (c para volver)"
			# Verificar si la entrada cumple con el formato deseado y el rango de números (1-7)
			if ($entrada -match '^([1-7])(,([1-7]))*$') {
				break
			} elseif ($entrada -ieq "c"){
				& "C:\Users\TFG\Desktop\TfG\menu_tareas.ps1"
			} else {
				$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Formato de listado incorrecto"
				& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
			}
		} while ($true)
		
		
		# Reemplaza comas por espacios
		$entrada = $entrada -replace ",", " "
		
		
		# Divide la entrada en números y busca su correspondencia en $dias
		$global:seleccion = $entrada -split " " | ForEach-Object { $dias[$_] }
		return
	
}

function frecuencia{
	do{
		clear-host
		write-Host "========================================"
		write-Host "	FRECUENCIA DE LA TAREA"
		write-Host "========================================"
		write-Host "1. Diariamente"
		write-Host "2. Una vez"
		write-Host "3. Semanalmente"
		write-Host "4. Mensualmente"
		write-Host "5. Volver"
		write-Host "========================================"
		$global:frec = 0
		$global:frec = Read-Host "`nIndique la frecuencia de la tarea (1-5)"
		if($global:frec -eq 1){
			& 'C:\Users\TFG\Desktop\TfG\hora.ps1'
			$Trigger = New-ScheduledTaskTrigger -Daily -At $global:horaUsuario
			$global:frec2 = "Diariamente a las $global:horaUsuario"
			CrearTarea
		} elseif ($global:frec -eq 2){
			& 'C:\Users\TFG\Desktop\TfG\hora.ps1'
			$Trigger = New-ScheduledTaskTrigger -Once -At $global:horaUsuario
			$global:frec2 = "Una vez a las $global:horaUsuario"
			CrearTarea
		} elseif ($global:frec -eq 3){
			Semana
			& 'C:\Users\TFG\Desktop\TfG\hora.ps1'
			$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $global:seleccion -At $global:horaUsuario
			$global:frec2 = "Semanalmente"
			CrearTarea
		}elseif ($global:frec -eq 4){
			& 'C:\Users\TFG\Desktop\TfG\hora.ps1'
			$global:frec2 = "Mensualmente"
			Mes
			return
		} elseif ($global:frec -eq 5){
			& 'C:\Users\TFG\Desktop\TfG\menu_tareas.ps1'
		}
		else {
				$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir un número correcto"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
            }
	}while($true)
	
}