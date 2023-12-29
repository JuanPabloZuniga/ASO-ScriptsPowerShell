Clear-Host

$currentUser = $env:USERNAME
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
} else {
	Write-Host "El script NO se estÃ¡ ejecutando como administrador. Por favor, ejecutelo como Administrador"
	pause
	exit
}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Menú Principal'
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
$label.Text = 'Menu Principal'
$label.Font = New-Object System.Drawing.Font("Arial",12) # Cambiar la fuente y el tamaño del texto
$label.BackColor = [System.Drawing.Color]::Transparent
$label.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(480,90)
$listBox.SelectionMode = 'MultiExtended'
$listBox.Font = New-Object System.Drawing.Font("Arial",12)
$listBox.BackColor = [System.Drawing.Color]::Black
$listBox.ForeColor = [System.Drawing.Color]::White


[void] $listBox.Items.Add('Tareas')
[void] $listBox.Items.Add('Eventos')
[void] $listBox.Items.Add('Monitorear Registros de Seguridad')
[void] $listBox.Items.Add('Monitorear Registros de Aplicaciones')
[void] $listBox.Items.Add('AdministraciÃ³n del almacenamiento')
[void] $listBox.Items.Add('Funciones Adicionales')

$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

#Poner una ruta lo mÃ¡s genÃ©rica posible

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    switch ($listBox.SelectedItem) {
        'Tareas' {
            & 'C:\Users\TFG\Desktop\TfG\menu_tareas.ps1'
        }
		'Eventos' {
            & 'C:\Users\TFG\Desktop\TfG\Eventos.ps1'
        }
        'Monitorear Registros de Seguridad' {
            & 'C:\Users\TFG\Desktop\TfG\Seguridad.ps1'
        }
        'Monitorear Registros de Aplicaciones' {
            & 'C:\Users\TFG\Desktop\TfG\Aplicaciones.ps1'
        }
		 'AdministraciÃ³n del almacenamiento' {
            & 'C:\Users\TFG\Desktop\TfG\script.ps1'
        }
		'Funciones Adicionales' {
            & 'C:\Users\TFG\Desktop\TfG\OtrasFunciones.ps1'
        }
   }
}
