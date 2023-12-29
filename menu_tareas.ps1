Clear-Host
function Volver {
    $confirm = Read-Host "¿Estás seguro de que deseas volver al Menú Principal? (si/no)"
    if ($confirm -eq "si") {
        & 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1'
    }
    else {
        & 'C:\Users\TFG\Desktop\TfG\menu_tareas.ps1'
    }
}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'CreaciÃ³n de Tareas'
$form.Font = New-Object System.Drawing.Font("Arial",12)
$form.Size = New-Object System.Drawing.Size(520,300) # Cambiar el tamaÃ±o de la ventana
$form.StartPosition = 'CenterScreen'

$backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\imagen.jpg')
$form.BackgroundImage = $backgroundImage
$form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tamaÃ±o del formulario

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
$label.Text = 'Seleccione una opciÃ³n:'
$label.Font = New-Object System.Drawing.Font("Arial",12) # Cambiar la fuente y el tamaÃ±o del texto
$label.BackColor = [System.Drawing.Color]::Transparent
$label.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(480,90)
$listBox.SelectionMode = 'MultiExtended'
$listBox.BackColor = [System.Drawing.Color]::Black
$listBox.ForeColor = [System.Drawing.Color]::White
$listBox.Font = New-Object System.Drawing.Font("Arial",12)


[void] $listBox.Items.Add('Ejecutar script')
[void] $listBox.Items.Add('Ejecutar comando')
[void] $listBox.Items.Add('Listar Tareas Creadas')
[void] $listBox.Items.Add('Volver al Menú Principal')

$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

#Poner una ruta lo mÃ¡s genÃ©rica posible

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    switch ($listBox.SelectedItem) {
        'Ejecutar script' {
            & 'C:\Users\TFG\Desktop\TfG\ejecutar_script.ps1'
        }
        'Ejecutar comando' {
            & 'C:\Users\TFG\Desktop\TfG\ejecutar_comando.ps1'
        }
        'Listar Tareas Creadas' {
            & 'C:\Users\TFG\Desktop\TfG\listar_tarea.ps1'
        }
        'Volver al Menú Principal' {
            Volver
            exit
        }
    }

}else{
	& 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL'
}