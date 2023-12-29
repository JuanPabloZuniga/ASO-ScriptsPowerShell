function Volver {
    $confirm = Read-Host "¿Estás seguro de que deseas volver al Menú Principal? (si/no)"
    if ($confirm -eq "si") {
        & 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1'
    }
    else {
        & 'C:\Users\TFG\Desktop\TfG\Seguridad.ps1'
    }
}

function ESAR {
    $securityEvents = Get-WinEvent -LogName $opcion -MaxEvents 10
    $securityEvents | Format-Table -AutoSize
}
function SeguridadID {
    $showAll = Read-Host "¿Deseas mostrar todos los eventos de inicio de sesión exitoso? (si/no)"
    if ($showAll -eq "si") {
        try {
            $loginEvents = Get-WinEvent -LogName $opcion | Where-Object { $_.Id -eq 4624 }
            if ($loginEvents) {
                $loginEvents | Format-Table -AutoSize
            } else {
                Write-Host "No se encontraron eventos de inicio de sesión exitoso."
            }
        }
        catch {
            Write-Host "Error al buscar eventos de inicio de sesión exitoso: $_"
        }
    } elseif ($showAll -eq "no") {
        try {
            $loginEvents = Get-WinEvent -LogName $opcion -MaxEvents 10
            $loginEvents | Format-Table -AutoSize
        }
        catch {
            Write-Host "Error al obtener eventos de seguridad: $_"
        }
    } else {
      #  Write-Host "Respuesta no válida. Por favor, responde 'si' o 'no'."
       # Read-Host "Presiona Enter para continuar..."
        $ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
				$error = "Debe introducir 'si' o 'no'"
                & "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		continue
    }
}

<#while ($true) {
    Clear-Host
    Write-Host "Menú de Monitoreo de Registros de Seguridad"
    Write-Host "1. Mostrar Eventos Recientes de Seguridad"
    Write-Host "2. Buscar Evento de Inicio de Sesión Exitoso"
    Write-Host "3. Volver al Menú Principal"

    $securityChoice = Read-Host "Selecciona una opción (1-3):"
    $opcion = "Security"
    switch ($securityChoice) {
        "1" {
            if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
                Exit
            }
            try {
                ESAR
            }
            catch {
                Write-Host "Error al obtener eventos de seguridad: $_"
            }
            Read-Host "Presiona Enter para continuar..."
        }
        "2" {
            SeguridadID
            Read-Host "Presiona Enter para continuar..."
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
$label.Text = 'Monitorear Registros de Seguridad'
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


[void] $listBox.Items.Add('Mostrar Eventos Recientes de Seguridad')
[void] $listBox.Items.Add('Buscar Evento de Inicio de Sesión Exitoso')
[void] $listBox.Items.Add('Volver al Menú Principal')

$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()
$opcion = "Security"
#Poner una ruta lo más genérica posible

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    switch ($listBox.SelectedItem) {
        'Mostrar Eventos Recientes de Seguridad' {
            if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
                Exit
            }
            try {
                ESAR
            }
            catch {
                Write-Host "Error al obtener eventos de seguridad: $_"
            }
            Read-Host "Presiona Enter para continuar..."
            & 'C:\Users\TFG\Desktop\TfG\Seguridad.ps1'
        }
        'Buscar Evento de Inicio de Sesión Exitoso' {
            SeguridadID
            Read-Host "Presiona Enter para continuar..."
            & 'C:\Users\TFG\Desktop\TfG\Seguridad.ps1'
        }
        'Volver al Menú Principal' {
            Volver
            exit
        }
    }
}
