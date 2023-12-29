#. $ruta
#. .\script.ps1
		$op3 = Read-Host "`nDesea salir del programa [SN] "
		if ($op3 -ieq "s"){
			$valor = 100
			} elseif ($op3 -ieq "n"){
				$valor = 200
			} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
			$error = "Valor incorrecto"
			& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
		return $valor

