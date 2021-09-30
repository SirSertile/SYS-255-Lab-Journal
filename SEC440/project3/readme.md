# Ransomware Demo File
# Purpose
This is solely for educational purposes. Use only on machines that you own or have consent to attack. 
# Prerequisites
* Python3.7
* Cryptography version 3.4.8
  - Run the command ```pip3 install "cryptography==3.4.8"``` if using linux
# Attack methodology
The attacker runs attack1.py. This generates attackkey.txt and privkey.txt. Transfer attackkey.txt to the target. 

The target runs target1.py, which takes attackkey.txt, creates a symmetric key and encrypts it with the public key inside of attackkey.txt. target1.py then encrypts and overwrites target.txt and outputs the encrypted symmetric key as enckey.txt. Transfer enckey.txt and attackkey.txt back to the attacker. This is the point at which the attacker would send over the ransom note.

If the ransom is paid, the attacker runs attack2.py, which decrypts the encrypted symmetric key in enckey.txt with the private key inside of privkey.txt and outputs symmkey.txt. The attacker transfers symmkey.txt back to the target.

The target then runs target2.py, which takes symmkey.txt and uses the contained symmetric key to decrypt target.txt
# Demonstration
I have recorded a [demonstration](https://champlain.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=e5fe31bc-c6de-4079-b46c-adb001522f94) of this for SEC-440.
