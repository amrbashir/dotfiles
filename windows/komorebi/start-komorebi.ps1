if (!(Get-Process whkd -ErrorAction SilentlyContinue))
{
   Start-Process whkd -WindowStyle Hidden -ArgumentList "-c","$env:USERPROFILE\dotfiles\windows\komorebi\whkdrc"
}

Start-Process komorebic -WindowStyle Hidden -ArgumentList "start"