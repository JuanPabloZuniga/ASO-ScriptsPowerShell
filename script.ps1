function letrasDisponibles{
	$global:letraD = Get-Partition -DiskNumber $global:valor1 | ForEach-Object { $_.DriveLetter }

	$global:letras = Get-Partition | ForEach-Object { $_.DriveLetter }

}
function redimensionar{
	do{
	letrasDisponibles
	clear-Host
		Write-Host "====================================="
		write-Host "`nLETRAS DISPONIBLES`n"
		Write-Host "====================================="
		$global:letraD
		Write-Host "=====================================`n"
		$letraR = read-host "`nIndique la letra que desea redimensionar"
        if ($letraR -notmatch "^[a-zA-Z]$") {
			Write-Host "La letra no es correcta..."
			pause
		} else {
		    $letraR = $letraR.ToUpper()
		    if ($global:letraD -contains $letraR) {

			        $info = Get-PartitionSupportedSize -DriveLetter $letraR
			        $maxTotal = [math]::Round($info.SizeMax / 1GB, 2)
			        $minTotal = [math]::Round($info.SizeMin / 1GB, 2)
			        write-Host "`nEl tamayo maximo de la particion puede ser $maxTotal y el minimo $minTotal"
					$tamanyoP = Get-Partition -DriveLetter $letraR | ForEach-Object {$_.Size / 1GB}
			        write-Host "`nEl tamayo actual de la particion $letraR es $tamanyoP"
			        $Ntamayo = read-host "`nIndique el nuevo tamanyo de la particion:"

			        if ($Ntamayo -match '^\d+(\.\d{1,2})?$') {
			            $Ntamayo = [decimal]$Ntamayo
					if ($Ntamayo -gt $maxTotal){
						$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
						$error = "Espacio superior al permitido"
						& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
					} elseif ($Ntamayo -lt $minTotal){
						$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
						$error = "El numero introducido debe ser mayor"
						& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
					} else {
			        $Ntamayo = $Ntamayo * 1GB
			        Resize-Partition -DriveLetter $letraR -Size $Ntamayo | Out-Null
			        write-Host "`nSe ha cambiado el tamayo de la particion $letraR"
			        pause
			        Particiones1

					}
		} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
			$error = "Introduuzca un formato correcto"
			& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
			}else {
	$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
	$error = "Debe introducir una letra correcta"
	& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
}
} 
}while($true)
}
function tamayoDisco{
	$global:EspacioLibreGB = 0
	$InfoDisco = Get-Disk -Number $global:valor1
	
	$tamayoTotalGB = [math]::Round($InfoDisco.Size / 1GB, 2)

	$partitions = Get-Partition -DiskNumber $global:valor1

    $EspacioTUtilizado = 0

    foreach ($partition in $partitions) {
        $EspacioTUtilizado += $partition.Size
    }
    $EspacioTUtilizado = [math]::Round($EspacioTUtilizado / 1GB, 2)

	$global:EspacioLibreGB = $tamayoTotalGB - $EspacioTUtilizado

	Write-Host "`nEspacio total en el disco $global:valor1 : $tamayoTotalGB GB"
	Write-Host "`nEspacio utilizado en el disco $global:valor1 : $EspacioTUtilizado GB"

	if ($global:EspacioLibreGB -le 0){
		Write-Host "`nNo hay espacio libre en el disco $global:valor1`n"
	} else { 
		Write-Host "`nEspacio libre en el disco $global:valor1 : $EspacioLibreGB GB`n"
	}

	Write-Host "==============================================================================`n"
    if ($global:EspacioLibreGB -le 5){
			Write-Host "`AVISO: POCO ESPACIO EN EL DISCO $global:valor1`n"
	}
}

function cifrar{
	do {
		clear-Host
		Write-Host "====================================="
		Write-Host "	LETRAS DISPOIBLES PARA CIFRAR"
		Write-Host "====================================="
		$letraCifrar = Get-BitLockerVolume | Where-Object { $_.VolumeStatus -match 'FullyDecrypted' } | ForEach-Object { $_.MountPoint }
		$letraCifrar
		Write-Host "====================================="
        $letraC = Read-Host "`nElija una letra de las letras mostradas"
        
        if ($letraC -notmatch "^[a-zA-Z]$") {
        Write-Host "La letra no es correcta."
			pause
		} else {

		$letraC = $letraC + ":"
						$letraC = $letraC.ToUpper()

						if ($letraCifrar -contains $letraC) {
							write-Host "`nSe va a cifrar la partici�n $letraC`n"
							Enable-BitLocker -MountPoint "$letraC" -PasswordProtector

							write-Host "`nSe ha cifrar el volumen $letraC`n"
							do{
								$sn = read-host "`nSe debe reiniciar para aplicar los cambios, ¿desea hacerlo ahora? [SN]"
								if ($sn -ieq "s"){
									Restart-Computer -Force

								}elseif ($sn -ieq "n"){
									return

								}else{
									write-Host "`nPor favor, introduzca S o N`n"
									pause
								}
							}while($true)
							
						} else {
							write-Host "`nNo se ha encontrado la particion a cifrar`n"
							pause
						}
}
		}while($true)
}

function BorrarParticion {
	letrasDisponibles
do {
		clear-Host
		Write-Host "====================================="
		write-Host "`nLETRAS DISPONIBLES`n"
		Write-Host "====================================="
		#$letraUsadaB = Get-Partition -DiskNumber $global:valor1 | ForEach-Object { $_.DriveLetter }
		#$letraUsadaB
		$global:letraD
		Write-Host "====================================="
		$letraB = read-host "`nIndique la letra que desea borrar (c para cancelar)"
        if ($letraB -notmatch "^[a-zA-Z]$") {
			Write-Host "La letra no es correcta.."
			pause
		} elseif ($letraB -ieq "c"){
			Particiones1
		} else {
		$letraB = $letraB.ToUpper()
		if ($global:letraD -contains $letraB) {
			Remove-Partition -DriveLetter $letraB -Confirm:$false | Out-Null
			write-Host "`nSe ha borrado de forma correcta la particiOn $letraB`n"
			pause
			return
		} else {
			write-Host "`nNo se ha encontrado la letra $letraB`n"
			pause
		}
			}
} while ($true)
}

function CrearParticion{
	if ($global:EspacioLibreGB -le 0){
	Write-Host "`nNo hay espacio libre en el disco $global:valor1`n"
	pause
	} else {
	do{
		clear-Host
		tamayoDisco
		$opp1 = Read-Host "`nIndique el tamanyo de la particion que desea Crear en GB (xx.xx)(c para cancelar)"
		if ($opp1 -match '^\d+(\.\d{1,2})?$') {
		$opp1 = [decimal]$opp1
		if ($opp1 -gt $global:EspacioLibreGB) {
				$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Espacio insuficiente"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		} else {
		$opp1 = $opp1 * 1GB
		
				do {
					letrasDisponibles
					#$letraUsada = Get-Partition | ForEach-Object { $_.DriveLetter } | Where-Object { $_ -ne $null }
					clear-Host
					Write-Host "====================================="
					Write-Host "	LETRAS DE UNIDAD EN USO"
					Write-Host "====================================="
					$global:letras
					Write-Host "====================================="
					do{
						$letra = Read-Host "`nElija una letra de unidad diferente a las mostradas"
						if ($letra -notmatch "^[a-zA-Z]$") {
							Write-Host "La letra no es correcta."
							pause
						} else {
							break
						}
					}while($true)					
					$letra = $letra.ToUpper()
					if ($global:letras -contains $letra) {
						Write-Host "`nLetra en uso, por favor, elija una diferente."
						Pause
					} else {
						$Etiqueta = read-host "`nIndique un nombre para la etiqueta`n"
						New-Partition -DiskNumber $global:valor1 -DriveLetter $letra -Size $opp1 | Out-Null
						Format-Volume -DriveLetter $letra -FileSystem NTFS -Confirm:$false | Out-Null
						Set-Volume -DriveLetter $letra -NewFileSystemLabel $Etiqueta
						write-Host "`nSe ha creado una particion de $(([math]::Round($opp1 / 1GB, 2))) GB con la letra $letra`n"
						pause
						return
					}
				}  while ($true)
		break
		}
		} elseif ($opp1 -ieq "c"){
			Particiones1
		} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
			$error = "Debe introducir un numero correto"
			& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
	}while($true)
	}
	return
}

function Particiones1{
	
do {
	clear-Host
	write-Host "=============================================="
	write-Host "      PARTICIONES"
	write-Host "=============================================="
	write-Host "1. Informacion de particiones"
	write-Host "2. Crear particion"
	write-Host "3. Borrar particiones"
	write-Host "4. Cifrar particion"
	write-Host "5. Redimensionar"
	write-Host "6. Volver"
	write-Host "7. Salir"
	write-Host "=============================================="

	$opc2 = Read-Host "`nEscoja una opción [1-7] "

	if ($opc2 -eq "1"){
		$particiones = Get-Partition -DiskNumber $global:valor1 | Select-Object Type, Size, DriveLetter

		foreach ($particion in $particiones) {
			$tipo = $particion.Type
			$tamayo = $particion.Size
			$tamayo = [math]::Round(($tamayo / 1GB), 2)
			$letra = $particion.DriveLetter
			
			write-Host "`n============================="
			write-Host "Tipo: $tipo"
			write-Host "Tamayo: $tamayo GB"
			write-Host "Letra de unidad: $letra"
			write-Host "============================="
		}
		pause
	}
		elseif ($opc2 -eq "2"){
			tamayoDisco	
			CrearParticion
		}
		elseif ($opc2 -eq "3"){
			$global:ParticionDisco = 0
			$global:ParticionDisco = Get-Partition -DiskNumber $global:valor1 | ForEach-Object { $_.DriveLetter }
            $global:ParticionDisco = $global:ParticionDisco.Count
            if ($global:ParticionDisco -eq 1) {
                Write-Host "`nNo hay particiones en el disco $global:valor1 para eliminar.`n"
			    pause
            } else {
			    BorrarParticion
            }
		} elseif ($opc2 -eq "4"){
			cifrar
		} elseif ($opc2 -eq "5"){
			redimensionar
		} 
		elseif ($opc2 -eq "6"){
			return 
		} elseif ($opc2 -eq "7"){
			$valor = & "C:\Users\TFG\Desktop\TfG\salir.ps1"
			if ($valor -eq 100){
				exit
			} 
		}
		else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir un numero entre 1 y 7"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
	} while ($true)
}

function menu2{
	do {
		Clear-Host
		write-Host "=============================================="
		write-Host "		ADMINISTRACION DE DISCOS"
		write-Host "=============================================="
		Write-Host "1. Informacion del disco"
		Write-Host "2. Particiones"
		Write-Host "3. Volver"
		write-Host "=============================================="
		$opc1 = Read-Host "`nEscoja una opción [1-3] "

			if ($opc1 -eq "1"){
				clear-Host
				Write-Host "`n==============================================================================`n"
				Write-Host "		INFORMACION DE DISCO $global:valor1"
				Write-Host "`n==============================================================================`n"
				Get-Disk -Number $global:valor1
				tamayoDisco
				Write-Host "`n==============================================================================`n"
				pause
			}
			elseif ($opc1 -eq "2"){
				Particiones1
			}
			elseif ($opc1 -eq "3"){
				return
				}
			else {
				$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir un numero entre 1 y 3"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
			}
		} while ($true)
}

function Discos{
	do {
		Clear-Host
		Write-Host "`n================================================================"
		Write-Host "		Discos Disponibles"
		Write-Host "================================================================`n"

		$discos = Get-Disk | Where-Object { $_.PartitionStyle -ne 'RAW' } | Select-Object Number, SerialNumber, PartitionStyle, @{Name='SizeGB'; Expression={[math]::Round($_.Size / 1GB, 2)}}

		$i = 1
		foreach ($disco in $discos) {
			Write-Host "$i : Disco $($disco.Number) - Serial: $($disco.SerialNumber), Size: $($disco.SizeGB) GB`n"
			$i++
			}
		
		Write-Host "`n================================================================`n"
		$op6 = Read-Host "`nIndique el numero del disco con el que desea trabajar [1-$($i - 1)]("c" para cancelar)"
		if ($op6 -ge 1 -and $op6 -le ($i - 1)) {
			$global:valor1 = $discos[$op6 - 1].Number
			menu2
		} elseif ($op6 -ieq "c") {
			& "C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1"
            break
		} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir un numero dentro del rango"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
	} while ($true)
}
 
function iniciar {
	do {
	clear-host
	Write-Host "`n========================================================================"
	Write-Host "Disco Disponibles para inicializar"
	Write-Host "==========================================================================`n"
	$i = 1
	foreach ($disco in $prueba3) {
    Write-Host "$i : Disco $($disco.Number) - Serial: $($disco.SerialNumber), Size: $($disco.SizeGB) GB`n"
	$i++
	}
	Write-Host "==========================================================================`n"
			
			$op4 = Read-Host "`nIndique el numero del disco que desea iniciar (1 - $($i - 1)) o 'C' para cancelar"
			if ($op4 -ge 1 -and $op4 -le ($i - 1))
			{
				$global:valor1 = $prueba3[$op4 - 1]
				
				Initialize-Disk -Number $global:valor1.Number -PartitionStyle GPT
				
				Write-Host "`nEl disco se ha iniciado de forma correcta!!`n"
				pause
				NumDiscos
			} elseif ($op4 -ieq "c") {
				Discos
			} else {
				$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir un numero dentro del rango"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
			}
		} while ($true)
}
function NumDiscos{
	clear-host

	write-Host "Por favor, espere"

	$prueba3 = Get-Disk | Where-Object { $_.PartitionStyle -match 'RAW' } | Select-Object Number, SerialNumber, PartitionStyle, @{Name='SizeGB'; Expression={[math]::Round($_.Size / 1GB, 2)}}

	$Tlinea = ($prueba3 | Measure-Object).Count

	if ($Tlinea -eq 0) {
		Discos
	} else {
		& 'C:\Users\TFG\Desktop\TfG\pregunta_discos.ps1'
	}
}
NumDiscos