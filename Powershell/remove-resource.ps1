# Pergunta ao usuário se ele deseja remover um recurso ou um grupo de recursos
$choice = Read-Host "Digite '1' para remover um RECURSO ou '2' para remover um GRUPO DE RECURSOS"

# Remove um grupo de recursos
if ($choice -eq "2") {

    # Lista os grupos de recursos existentes
    Get-AzResourceGroup | Select-Object ResourceGroupName

    # Pede ao usuário para selecionar o grupo de recursos a ser removido
    $groupName = Read-Host "Digite o nome do grupo de recursos a ser removido"

    # Remove o grupo de recursos selecionado
    Remove-AzResourceGroup -Name $groupName -Force

    Write-Host "Grupo de recursos $groupName removido com sucesso!"

# Remove um recurso
} elseif ($choice -eq "1") {

    # Lista os grupos de recursos existentes
    Get-AzResourceGroup | Select-Object ResourceGroupName

    # Pede ao usuário para selecionar o grupo de recursos do recurso a ser removido
    $groupName = Read-Host "Digite o nome do grupo de recursos que contém o recurso a ser removido"

    # Lista os recursos do grupo selecionado
    Get-AzResource -ResourceGroupName $groupName | Select-Object Name

    # Pede ao usuário para escolher qual recurso deve ser removido
    $resourceName = Read-Host "Digite o nome do recurso a ser removido"

    # Remove o recurso selecionado
    Remove-AzResource -ResourceGroupName $groupName -Name $resourceName -Force

    Write-Host "Recurso $resourceName removido com sucesso!"

}

# Pergunta ao usuário se ele deseja remover mais algum recurso
$continue = Read-Host "Deseja remover mais algum recurso ou grupo de recursos? (S/N)"

# Repete o processo se o usuário deseja remover mais algum recurso
while ($continue -eq "S") {

    # Pergunta ao usuário se ele deseja remover um recurso ou um grupo de recursos
    $choice = Read-Host "Digite '1' para remover um recurso ou '2' para remover um grupo de recursos"

    # Remove um grupo de recursos
    if ($choice -eq "2") {

    # Lista os grupos de recursos existentes
    Get-AzResourceGroup | Select-Object ResourceGroupName

    # Pede ao usuário para selecionar o grupo de recursos a ser removido
    $groupName = Read-Host "Digite o nome do grupo de recursos a ser removido"

    # Remove o grupo de recursos selecionado
    Remove-AzResourceGroup -Name $groupName -Force

    Write-Host "Grupo de recursos $groupName removido com sucesso!"

    # Remove um recurso
    } elseif ($choice -eq "1") {

    # Lista os grupos de recursos existentes
    Get-AzResourceGroup | Select-Object ResourceGroupName

    # Pede ao usuário para selecionar o grupo de recursos do recurso a ser removido
    $groupName = Read-Host "Digite o nome do grupo de recursos que contém o recurso a ser removido"

    # Lista os recursos do grupo selecionado
    Get-AzResource -ResourceGroupName $groupName | Select-Object Name

    # Pede ao usuário para escolher qual recurso deve ser removido
    $resourceName = Read-Host "Digite o nome do recurso a ser removido"

    # Remove o recurso selecionado
    Remove-AzResource -ResourceGroupName $groupName -Name $resourceName -Force

    Write-Host "Recurso $resourceName removido com sucesso!"
    }
    # Pergunta ao usuário se ele deseja remover mais algum recurso
    $continue = Read-Host "Deseja remover mais algum recurso ou grupo de recursos? (S/N)"
}
