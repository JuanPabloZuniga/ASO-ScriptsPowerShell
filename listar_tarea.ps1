Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Función para mostrar el formulario
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Tareas Registradas En el sistema'
    $form.Size = New-Object System.Drawing.Size(520,300)
    $form.StartPosition = 'CenterScreen'
	
	$backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\imagen.jpg')
    $form.BackgroundImage = $backgroundImage
    $form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tamaño del formulario

    $textBox = New-Object System.Windows.Forms.RichTextBox
    $textBox.Location = New-Object System.Drawing.Point(10, 10)
    $textBox.Size = New-Object System.Drawing.Size(380, 200)
    $form.Controls.Add($textBox)

    $button = New-Object System.Windows.Forms.Button
    $button.Location = New-Object System.Drawing.Point(150, 220)
    $button.Size = New-Object System.Drawing.Size(100, 30)
    $button.Text = 'Cerrar'
    $button.Add_Click({
        $form.Close()
		& 'C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1'
        break
    })
    $form.Controls.Add($button)


    $tasks = Get-ScheduledTask | Where-Object {$_.State -eq 'Ready'} | Select-Object TaskName
	$textBox.Text = $tasks | Out-String

    # Mostrar el formulario
    $form.ShowDialog()	