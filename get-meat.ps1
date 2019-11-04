
function get-meat
<#
.SYNOPSIS
    Gets bacon ipsum
.DESCRIPTION

.PARAMETER type
    Required parameter. The type of content to return. Can be either "all-meat" (think all you can BBQ Rib buffet, with a side of Donner).
    Or, can be meat-and-filler. Where ipsum filler is included.

.PARAMETER paras
    Specifes the number of paragraphs to return. Default is 1.

.PARAMETER MakeItSpicy
    Have a spicy entree with your meat.

.EXAMPLE
    Get-Meat -paras 3 -type all-meat
    This example will return a mass of meat. Donner, Ribs, Salami. Pretty much everything you can think of (thankfully no tripe)

.EXAMPLE
    Get-Meat -Paras 2 -Type meat-and-filler -MakeItSpicy
    This will return 2 paragraphs of meat with ipsum filler, with a spicy entree.

.NOTES
    Author: Andrew Clure
    Date:   October 29th 2019
#>
{
# Define parameters 
param(
    [Parameter(Mandatory=$True)]
    [ValidateSet("all-meat", "meat-and-filler")]
    [String]$Type,
    [Parameter(Mandatory=$false)]
    [switch]$makeItSpicy,
    [Parameter(Mandatory=$false)]
    [switch]$genHTML,
    [Parameter(Mandatory=$false)]
    [int]$Paras = 1
    )

# Main function block
Process
    {
        Try
        {    # Request a Spicy jalapeno starter
            if ($makeItSpicy){
                $spicy = "1"
            }
            else {
                $spicy = "0"
            }
            if ($genHTML) {
                Remove-Item ./images/index.html -ErrorAction Ignore
                cd ./images
                $image = Get-ChildItem -name | Select-Object -index $(Random $((Get-ChildItem).count))
                cd ..
                $url = "https://baconipsum.com/api/?type=$type&paras=$paras&make-it-spicy=1&format=text"
                $data = Invoke-WebRequest $url
                $htmldata = @"
                  <div>
                  <h1>Bacon Ipsum</h1>
                  <img src=$image alt="Meat portrait" />
                  </body>
                  <p>$data</p>
                  </div>
"@
                New-Item ./images/index.html -ItemType File
                add-Content ./images/index.html -value $htmldata
            }
            # If no starter, then just return meat and filler
            else {
                $url = "https://baconipsum.com/api/?type=$type&paras=$paras&make-it-spicy=$spicy&format=text"
                $data = Invoke-WebRequest $url
                write-host $data
            }         
        }
    
        Catch
        {
            write-warning “Error digesting all that meat”  
        }
    }
}

