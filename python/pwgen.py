import random
import string

def getpassword(pwlength, extrachars):
    password = []
    for i in range(pwlength):
        password.append(random.choice(string.ascii_letters + string.digits + string.punctuation + extrachars))
    return "".join(password)

def getpassword2(nr_letters, nr_symbols, nr_numbers):
    letters = [
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
        'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
        'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ]
    numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    symbols = ['!', '#', '$', '%', '&', '(', ')', '*', '+']

    password_list = []

    for char in range(1, nr_letters + 1): password_list.append(random.choice(letters))
    for char in range(1, nr_symbols + 1): password_list.append(random.choice(numbers))
    for char in range(1, nr_numbers + 1): password_list.append(random.choice(symbols))

    random.shuffle(password_list)

    password = ""
    for char in password_list:
        password += char

    pwd = ''.join(password_list)
    return pwd

## getpassword examples
print("English password: " + getpassword(20, ""))
print("German password:  " + getpassword(20, "äöüßÄÖÜẞ"))
print("Italian password: " + getpassword(20, "ÀÈÉÌÒÙàèéìòù"))
print("French password:  " + getpassword(20, "ÀÂÄÆÇÈÉÊËÎÏÔŒÙÛÜàâäæçrèéêëîïôœùûü"))
print("Spanish password: " + getpassword(20, "¡¿ÁÉÍÑÓÚÜáéíñóúü"))

## getpassword2 examples
print("Your random password to use is: " + getpassword2(10,2,2))