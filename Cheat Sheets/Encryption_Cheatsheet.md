# Encryption Cheat Sheet

## Encryption Types and Use Cases

### AES (Advanced Encryption Standard)

AES is a symmetric encryption algorithm widely used for securing sensitive data. It supports key sizes of 128, 192, and 256 bits, providing strong encryption. AES is commonly used for encrypting files, messages, and data at rest.

### RSA (Rivest-Shamir-Adleman)

RSA is an asymmetric encryption algorithm used for secure communication and digital signatures. It uses a pair of keys: a public key for encryption and a private key for decryption. RSA is commonly used in scenarios where secure communication between parties is required, such as secure email communication and SSL/TLS encryption.

### GPG (GNU Privacy Guard)

GPG is a hybrid encryption software that combines symmetric-key encryption (such as AES) with public-key encryption (such as RSA). It provides data encryption, digital signatures, and key management. GPG is commonly used for securing email communication, file encryption, and software distribution.


## PowerShell

### Encrypting with AES:

```powershell
# Using a password
$Credential = Get-Credential
$password = Read-Host | ConvertTo-SecureString -AsPlainText -Force
$encrypted = $Credential | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Key $password
$encrypted | Out-File "Encrypted.txt"

# Using a certificate
$Credential = Get-Credential
$cert = Get-ChildItem -Path "YourCertificate.pfx" | Import-PfxCertificate -CertStoreLocation Cert:\CurrentUser\My
$encrypted = $plaintext | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -Certificate $cert
$encrypted | Out-File "Encrypted.txt"
```

### Decrypting with AES:

```powershell
# Using a password
$encrypted = Get-Content "Encrypted.txt" | ConvertTo-SecureString
$password = "YourPassword" | ConvertTo-SecureString -AsPlainText -Force
$plaintext = $encrypted | ConvertFrom-SecureString -Key $password
$plaintext

# Using a certificate
$encrypted = Get-Content "Encrypted.txt" | ConvertTo-SecureString
$cert = Get-ChildItem -Path "YourCertificate.pfx" | Import-PfxCertificate -CertStoreLocation Cert:\CurrentUser\My
$plaintext = $encrypted | ConvertFrom-SecureString -Certificate $cert
$plaintext
```

### Encrypting with RSA:

```powershell
# Using a public key
$plaintext = "YourPlainText"
$cert = Get-ChildItem -Path "PublicKey.cer"
$encrypted = $plaintext | ConvertTo-SecureString -AsPlainText -Force | Protect-CmsMessage -To $cert
$encrypted | Out-File "Encrypted.txt"
```

## Bash

### Encrypting with OpenSSL:

```bash
# Using symmetric encryption (AES) with password
plaintext="YourPlainText"
password="YourPassword"
echo -n "$plaintext" | openssl enc -aes-256-cbc -pass pass:"$password" -out encrypted.txt

# Using asymmetric encryption (RSA) with public key
plaintext="YourPlainText"
openssl rsautl -encrypt -inkey public_key.pem -pubin -in <(echo -n "$plaintext") -out encrypted.txt
```

### Decrypting with OpenSSL:

```bash
# Using symmetric encryption (AES) with password
password="YourPassword"
openssl enc -d -aes-256-cbc -pass pass:"$password" -in encrypted.txt

# Using asymmetric encryption (RSA) with private key
openssl rsautl -decrypt -inkey private_key.pem -in encrypted.txt
```

### Encrypting with GPG:

```bash
# Using symmetric encryption (AES) with password
plaintext="YourPlainText"
password="YourPassword"
echo -n "$plaintext" | gpg --batch --passphrase "$password" --symmetric --cipher-algo AES256 -o encrypted.txt

# Using asymmetric encryption (RSA) with public key
plaintext="YourPlainText"
gpg --batch --recipient "recipient@example.com" --encrypt --armor -o encrypted.txt <(echo -n "$plaintext")
```

### Decrypting with GPG:

```bash
# Using symmetric encryption (AES) with password
password="YourPassword"
gpg --batch --passphrase "$password" --decrypt encrypted.txt

# Using asymmetric encryption (RSA) with private key
gpg --batch --decrypt encrypted.txt
```