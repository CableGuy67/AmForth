
def convert_number( aString ):
    if aString.startswith("0x") or aString.startswith("0X"):
        return int(aString,16)
    elif aString.startswith("0"):
        return int(aString,8)
    else:
        return int(aString)
