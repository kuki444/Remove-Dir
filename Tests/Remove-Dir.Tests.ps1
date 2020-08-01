# Remove-Dir.Tests
# 
BeforeAll {
    $exePath = Split-Path (Split-Path $PSCommandPath -Parent)
    $commandName = Split-Path $PSCommandPath.Replace('.Tests.ps1','.ps1') -Leaf
}

Describe "Remove-Dir" {
    BeforeAll {
        function Create-Data {
            # create test Directory and file
            New-Item "$PSScriptRoot\temp" -type directory -Force 
            New-Item "$PSScriptRoot\temp\dir1" -type directory -Force 
            New-Item "$PSScriptRoot\temp\dir2" -type directory -Force 
            New-Item "$PSScriptRoot\temp\dir2\dir21" -type directory -Force 
            New-Item "$PSScriptRoot\temp\dir2\dir22" -type directory -Force 
            New-Item "$PSScriptRoot\temp\testfile1.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\testfile2.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\testfile3.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\testfile4.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\testfile5.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\testfile6.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\filekeep.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir1\testfile4.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir1\testfile5.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir1\testfile6.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir2\testfile7.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" -type file -Force 
            New-Item "$PSScriptRoot\temp\dir2\dir22\testfile9.txt" -type file -Force 
        }
    }
    AfterAll {
        Remove-Item "$PSScriptRoot\temp" -Recurse
    }
    
    Context "check delete Directory option" {
          It "check delete " {
            Create-Data
            . $exePath\$commandName -v -f -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\testfile1.txt" | Should -Exist
            "$PSScriptRoot\temp\dir1" | Should -Not -Exist
            "$PSScriptRoot\temp\dir2" | Should -Not -Exist
        }
        It "check delte option -r " {
            Create-Data
            . $exePath\$commandName  -v -r -f -include dir21 -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\dir1" | Should -Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should -Exist
            "$PSScriptRoot\temp\dir2" | Should -Exist
            "$PSScriptRoot\temp\dir2\testfile7.txt" | Should -Exist
            "$PSScriptRoot\temp\dir2\dir21" | Should -Not -Exist
        }
        It "check delte option -include " {
            Create-Data
            . $exePath\$commandName -v -r -f -include dir1 -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\filekeep.txt" | Should -Exist
            "$PSScriptRoot\temp\dir1" | Should -Not -Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir2" | Should -Exist
            "$PSScriptRoot\temp\dir2\dir21" | Should -Exist
            "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" | Should -Exist
        }
    }
}
