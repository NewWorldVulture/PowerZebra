Function getOnlinePrinters {
    # Create empty array to add printer names
    $printer_names = @()
    # Use WQL to filter for zebra printers that are online now
    $printers_online_raw = Get-WmiObject -query "SELECT Name FROM Win32_Printer WHERE (PortName LIKE 'USB%') AND (WorkOffline = False) AND (Name LIKE 'ZDesigner%')" 
    foreach ($printer in $printers_online_raw) {
        $printer_names += $printer.Name
    }
    return $printer_names
}

Function sendToPrinter($commands) {
    $program = @()
    # Assemble program from byte codes of each character
    foreach ($char in $commands.ToCharArray()) {
        $program += ,[byte][char]$char
    }
    $printer = getOnlinePrinters
    $program | Out-Printer -Name $printer
}

$zplCommands = '~JR'
sendToPrinter($zplCommands)
