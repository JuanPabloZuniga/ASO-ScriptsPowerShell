 function Volver {
    $confirm = Read-Host "¿Estás seguro de que deseas volver al Menú Principal? (si/no)"
    if ($confirm -eq "si") {
        & 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1'
    }
    else {
        & 'C:\Users\TFG\Desktop\TfG\Eventos.ps1'
    }
}

function ESAR {
    $securityEvents = Get-WinEvent -LogName $opcion -MaxEvents 10
    $securityEvents | Format-Table -AutoSize
}

function EventoID {
    $eventId = Read-Host "Introduce el ID del evento a buscar (deja en blanco para mostrar todos los eventos):"
    if ([string]::IsNullOrWhiteSpace($eventId)) {
        $events = Get-WinEvent -LogName $opcion -MaxEvents 10
    } else {
        try {
            $events = Get-WinEvent -LogName $opcion | Where-Object { $_.Id -eq $eventId }
        }
        catch {
            Write-Host "Error al buscar eventos: $_"
        }
    }

    if ($events) {
        $events | Format-Table -AutoSize
    } else {
        Write-Host "No se encontraron eventos con el ID $eventId."
    }
}

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
$label.Text = 'Monitorear Eventos de Sistema'
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


[void] $listBox.Items.Add('Mostrar Eventos Recientes')
[void] $listBox.Items.Add('Buscar Evento por ID')
[void] $listBox.Items.Add('Volver al Menú Principal')

$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()
$opcion = "System"
#Poner una ruta lo más genérica posible

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    switch ($listBox.SelectedItem) {
        'Mostrar Eventos Recientes' {
            try {
                ESAR
            }
            catch {
                Write-Host "Error al obtener eventos: $_"
            }
            Read-Host "Presiona Enter para continuar..."
            & 'C:\Users\TFG\Desktop\TfG\Eventos.ps1'
        }
        'Buscar Evento por ID' {
            EventoID
            Read-Host "Presiona Enter para continuar..."
            & 'C:\Users\TFG\Desktop\TfG\Eventos.ps1'
        }
        'Volver al Menú Principal' {
            Volver
            exit
        }
    }
}

