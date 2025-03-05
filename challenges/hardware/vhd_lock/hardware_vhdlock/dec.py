def xor_decrypt(data_pairs, key):
    decrypted = bytearray()
    key_len = len(key)
    
    for i, pair in enumerate(data_pairs):
        # Use only the second value in the pair for XOR operation
        value = pair[1]
        decrypted_byte = value ^ key[i % key_len]
        decrypted.append(decrypted_byte & 0xFF)  # Keep only the least significant byte
    
    return decrypted

def read_key(file_path):
    with open(file_path, 'r') as f:
        key = f.read().strip()
    # Convert key characters to bytes for XOR operation
    return bytearray(key.encode())

def decrypt_custom(data, key_path, output_path):
    key = read_key(key_path)
    decrypted_data = xor_decrypt(data, key)
    
    with open(output_path, 'wb') as f:
        f.write(decrypted_data)

if __name__ == "__main__":
    data_pairs = [
        (35, 307), (17, 33), (33, 53), (183, 2103), (35, 563), (17, 32817), 
        (33, 4145), (63, 54), (179, 115), (57, 57), (17, 32817), (23, 119), 
        (35, 307), (33, 33), (33, 4145), (23, 32823), (115, 55), (177, 17), 
        (177, 33), (23, 32823), (35, 4147), (33, 32817), (177, 113), (119, 23), 
        (19, 32819), (113, 8241), (177, 561), (23, 32823), (59, 19), (177, 177), 
        (57, 57), (63, 63), (179, 35), (113, 305), (113, 17), (119, 53), 
        (179, 55), (57, 177), (17, 32817), (119, 8247), (59, 50), (177, 53), 
        (113, 17), (183, 8247)
    ]
    key_path = "out.txt"
    output_path = "decrypted_lock.vhd"
    
    decrypt_custom(data_pairs, key_path, output_path)
    print(f"Decrypted file saved as {output_path}")

