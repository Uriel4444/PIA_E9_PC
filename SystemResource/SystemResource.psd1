@{
    RootModule = 'SystemResource.psm1'
    ModuleVersion = '1.0.0'
    Author = 'Edwin Uriel Santiago Camacho'
    CompanyName = 'Facultad de Ciencias Físico Matemáticas'
    Description = 'Este módulo realiza una revisión del uso de recursos del sistema, incluyendo CPU, memoria, disco y red.'
    FunctionsToExport = @('Get-SystemResourceUsage')
    PowerShellVersion = '5.1'
}
