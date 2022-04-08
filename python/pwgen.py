import random
import string

def getpassword(pwlength, extrachars):
    password = []
    for i in range(pwlength):
        password.append(random.choice(string.ascii_letters + string.digits + string.punctuation + extrachars))
    return "".join(password)

print("English password: " + getpassword(20, ""))
print("German password:  " + getpassword(20, "äöüßÄÖÜẞ"))
print("Italian password: " + getpassword(20, "ÀÈÉÌÒÙàèéìòù"))
print("French password:  " + getpassword(20, "ÀÂÄÆÇÈÉÊËÎÏÔŒÙÛÜàâäæçrèéêëîïôœùûü"))
print("Spanish password: " + getpassword(20, "¡¿ÁÉÍÑÓÚÜáéíñóúü"))
