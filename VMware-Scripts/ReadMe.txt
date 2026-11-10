Prerequisites & Initialization (NY)
Before running any scripts, ensure you have the VMware.PowerCLI module installed and configured to bypass untrusted SSL certificates:

# Install PowerCLI for the current user
Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force

# Bypass self-signed certificate warnings
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
