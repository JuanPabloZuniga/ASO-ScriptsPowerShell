function Volver {
    $confirm = Read-Host "¿Estás seguro de que deseas volver al Menú Principal? (si/no)"
    if ($confirm -eq "si") {
        & 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1'
    }
    else {
        & 'C:\Users\TFG\Desktop\TfG\OtrasFunciones.ps1'
    }
}
Clear-Host
<#while ($true) {
    Clear-Host
    Write-Host "Funciones Adicionales"
    Write-Host "1. Registro de Errores"
    Write-Host "2. Configuración de Políticas de Seguridad"
    Write-Host "3. Volver a Menú Principal"
        
    $additionalChoice = Read-Host "Selecciona una opción (1-3):"
        
    switch ($additionalChoice) {
        "1" {
            # Definir la ruta donde se guardará el archivo de registro
            $archivoRegistro = ".\errores.txt"
            
            if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
                Exit
            }

            # Filtrar y recoger eventos de registro de aplicaciones, seguridad y sistema
            Get-WinEvent -LogName Application, Security, System| Where-Object { $_.level -eq 2 } | Out-File -FilePath $archivoRegistro

            # Preguntar al usuario si desea abrir el archivo de registro
            $respuesta = Read-Host "¿Deseas abrir el archivo de registro? (Sí/No)"
            if ($respuesta -eq "Sí") {
                notepad.exe $archivoRegistro
            }
        }
        "2" {
            # Submenú de Configuración de Políticas de Seguridad
            # Configurar la Política de Ejecución

            $ejecucionConfigurada = $false

            while (-not $ejecucionConfigurada) {
                $respuestaPolítica = Read-Host "¿Deseas configurar la Política de Ejecución? (Sí/No)"
                if ($respuestaPolítica -eq "Sí") {
                    $nuevaPolítica = Read-Host "Introduce la nueva Política de Ejecución (por ejemplo, 'RemoteSigned' o 'Unrestricted'):"
                    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $nuevaPolítica
                    Write-Host "Política de Ejecución configurada correctamente."
                    $ejecucionConfigurada = $true
                } elseif ($respuestaPolítica -eq "No") {
                    Write-Host "Política de Ejecución no configurada."
                    $ejecucionConfigurada = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }

            # Configurar la ejecución de scripts sin firmar
            $ejecucionScriptsSinFirmar = $false

            while (-not $ejecucionScriptsSinFirmar) {
                $respuestaScriptsSinFirmar = Read-Host "¿Deseas permitir la ejecución de scripts sin firmar? (Sí/No)"
                if ($respuestaScriptsSinFirmar -eq "Sí") {
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -Value "Unrestricted"
                    Write-Host "La ejecución de scripts sin firmar está permitida."
                    $ejecucionScriptsSinFirmar = $true
                } elseif ($respuestaScriptsSinFirmar -eq "No") {
                    Write-Host "La ejecución de scripts sin firmar no está permitida."
                    $ejecucionScriptsSinFirmar = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }

            # Configurar el módulo de ejecución de scripts
            $moduloEjecucionScripts = $false

            while (-not $moduloEjecucionScripts) {
                $respuestaModuloScripts = Read-Host "¿Deseas configurar el módulo de ejecución de scripts? (Sí/No)"
                if ($respuestaModuloScripts -eq "Sí") {
                    $nuevoModuloScripts = Read-Host "Introduce el nombre del módulo de ejecución de scripts (por ejemplo, 'Restricted' o 'AllSigned'):"
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "Module" -Value $nuevoModuloScripts
                    Write-Host "Módulo de ejecución de scripts configurado correctamente."
                    $moduloEjecucionScripts = $true
                } elseif ($respuestaModuloScripts -eq "No") {
                    Write-Host "Módulo de ejecución de scripts no configurado."
                    $moduloEjecucionScripts = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }
            # Configurar la política de ejecución de scripts remotos
            $politicaEjecucionRemota = $false

            while (-not $politicaEjecucionRemota) {
                $respuestaEjecucionRemota = Read-Host "¿Deseas configurar la política de ejecución de scripts remotos? (Sí/No)"
                if ($respuestaEjecucionRemota -eq "Sí") {
                    $nuevaPoliticaRemota = Read-Host "Introduce la nueva Política de Ejecución de scripts remotos (por ejemplo, 'Bypass' o 'AllSigned'):"
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "RemoteSigned" -Value $nuevaPoliticaRemota
                    Write-Host "Política de ejecución de scripts remotos configurada correctamente."
                    $politicaEjecucionRemota = $true
                } elseif ($respuestaEjecucionRemota -eq "No") {
                    Write-Host "Política de ejecución de scripts remotos no configurada."
                    $politicaEjecucionRemota = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }
            Write-Host "Configuración completada."
        }
        "3" {
            Volver
            exit
        }
        default {
            & '.\error_comando.ps1'
        }
    }
}#>
Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Monitoreo'
$form.Size = New-Object System.Drawing.Size(520,300) # Cambiar el tamaño de la ventana
$form.StartPosition = 'CenterScreen'

$backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\imagen.jpg')
$form.BackgroundImage = $backgroundImage
$form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tamaño del formulario

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(175,220)
$OKButton.Size = New-Object System.Drawing.Size(75,30)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(250,220)
$CancelButton.Size = New-Object System.Drawing.Size(75,30)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(480,20)
$label.Text = 'Funciones Adicionales'
$label.Font = New-Object System.Drawing.Font("Arial",12) # Cambiar la fuente y el tamaño del texto
$label.BackColor = [System.Drawing.Color]::Transparent
$label.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(480,90)
$listBox.SelectionMode = 'MultiExtended'
$listBox.BackColor = [System.Drawing.Color]::Black
$listBox.ForeColor = [System.Drawing.Color]::White


[void] $listBox.Items.Add('Registro de Errores')
[void] $listBox.Items.Add('Configuración de Políticas de Seguridad')
[void] $listBox.Items.Add('Volver al Menú Principal')

$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()
$opcion = "Application"
#Poner una ruta lo más genérica posible

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    switch ($listBox.SelectedItem) {
        'Registro de Errores' {
            # Definir la ruta donde se guardará el archivo de registro
            $archivoRegistro = "C:\Users\TFG\Desktop\TfG\errores.txt"
            
            if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
                Exit
            }

            # Filtrar y recoger eventos de registro de aplicaciones, seguridad y sistema
			Write-Host "Se está ejecutando el comando. Por favor, espere..."
            Get-WinEvent -LogName Application, Security, System| Where-Object { $_.level -eq 2 } | Out-File -FilePath $archivoRegistro

            # Preguntar al usuario si desea abrir el archivo de registro
            $respuesta = Read-Host "¿Deseas abrir el archivo de registro? (Sí/No)"
            if ($respuesta -eq "Sí") {
                notepad.exe $archivoRegistro
            }
            & 'C:\Users\TFG\Desktop\TfG\OtrasFunciones.ps1'
        }
        'Configuración de Políticas de Seguridad' {
            # Submenú de Configuración de Políticas de Seguridad
            # Configurar la Política de Ejecución

            $ejecucionConfigurada = $false

            while (-not $ejecucionConfigurada) {
                $respuestaPolítica = Read-Host "¿Deseas configurar la Política de Ejecución? (Sí/No)"
                if ($respuestaPolítica -eq "Sí") {
                    $nuevaPolítica = Read-Host "Introduce la nueva Política de Ejecución (por ejemplo, 'RemoteSigned' o 'Unrestricted'):"
                    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $nuevaPolítica
                    Write-Host "Política de Ejecución configurada correctamente."
                    $ejecucionConfigurada = $true
                } elseif ($respuestaPolítica -eq "No") {
                    Write-Host "Política de Ejecución no configurada."
                    $ejecucionConfigurada = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }

            # Configurar la ejecución de scripts sin firmar
            $ejecucionScriptsSinFirmar = $false

            while (-not $ejecucionScriptsSinFirmar) {
                $respuestaScriptsSinFirmar = Read-Host "¿Deseas permitir la ejecución de scripts sin firmar? (Sí/No)"
                if ($respuestaScriptsSinFirmar -eq "Sí") {
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -Value "Unrestricted"
                    Write-Host "La ejecución de scripts sin firmar está permitida."
                    $ejecucionScriptsSinFirmar = $true
                } elseif ($respuestaScriptsSinFirmar -eq "No") {
                    Write-Host "La ejecución de scripts sin firmar no está permitida."
                    $ejecucionScriptsSinFirmar = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }

            # Configurar el módulo de ejecución de scripts
            $moduloEjecucionScripts = $false

            while (-not $moduloEjecucionScripts) {
                $respuestaModuloScripts = Read-Host "¿Deseas configurar el módulo de ejecución de scripts? (Sí/No)"
                if ($respuestaModuloScripts -eq "Sí") {
                    $nuevoModuloScripts = Read-Host "Introduce el nombre del módulo de ejecución de scripts (por ejemplo, 'Restricted' o 'AllSigned'):"
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "Module" -Value $nuevoModuloScripts
                    Write-Host "Módulo de ejecución de scripts configurado correctamente."
                    $moduloEjecucionScripts = $true
                } elseif ($respuestaModuloScripts -eq "No") {
                    Write-Host "Módulo de ejecución de scripts no configurado."
                    $moduloEjecucionScripts = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }
            # Configurar la política de ejecución de scripts remotos
            $politicaEjecucionRemota = $false

            while (-not $politicaEjecucionRemota) {
                $respuestaEjecucionRemota = Read-Host "¿Deseas configurar la política de ejecución de scripts remotos? (Sí/No)"
                if ($respuestaEjecucionRemota -eq "Sí") {
                    $nuevaPoliticaRemota = Read-Host "Introduce la nueva Política de Ejecución de scripts remotos (por ejemplo, 'Bypass' o 'AllSigned'):"
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "RemoteSigned" -Value $nuevaPoliticaRemota
                    Write-Host "Política de ejecución de scripts remotos configurada correctamente."
                    $politicaEjecucionRemota = $true
                } elseif ($respuestaEjecucionRemota -eq "No") {
                    Write-Host "Política de ejecución de scripts remotos no configurada."
                    $politicaEjecucionRemota = $true
                } else {
                    Write-Host "Por favor, responde 'Sí' o 'No'."
                }
            }
            Write-Host "Configuración completada."
            & 'C:\Users\TFG\Desktop\TfG\OtrasFunciones.ps1'
        }
        'Volver al Menú Principal' {
            Volver
            exit
        }
    }
}
