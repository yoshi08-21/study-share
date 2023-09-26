server "3.115.171.176", user: "ec2-user", roles: %w{app db web}

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/adr33wHESW134DwdgerrfBNEw532Hygrdadabg.pem)')]
}
