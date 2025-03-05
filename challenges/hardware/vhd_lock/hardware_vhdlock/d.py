def xor_decrypt(encrypted_data, key):
    key_length = len(key)
    decrypted_data = bytearray()
    
    for i in range(len(encrypted_data)):
        decrypted_data.append(encrypted_data[i] ^ key[i % key_length])
    
    return decrypted_data

def try_decrypt_with_key(encrypted_data, key):
    try:
        decrypted_data = xor_decrypt(encrypted_data, key)
        # Perform any checks to validate decrypted file if needed
        return decrypted_data
    except Exception as e:
        print(f"Error decrypting with key: {e}")
        return None

def main():
    encrypted_file_path = 'lock.vhd'
    output_directory = 'decrypted_files'
    key_file_path = 'out.txt'
    
    # Ensure the output directory exists
    import os
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    
    # Read the encrypted file
    with open(encrypted_file_path, 'rb') as file:
        encrypted_data = file.read()
    
    # Read potential keys from out.txt
    with open(key_file_path, 'r') as key_file:
        keys = key_file.readlines()
    
    # Try decrypting with each key
    for i, key_hex in enumerate(keys):
        key_hex = key_hex.strip()  # Remove any extra whitespace or newlines
        try:
            key = bytes.fromhex(key_hex)
        except ValueError:
            print(f"Invalid key format: {key_hex}")
            continue
        
        decrypted_data = try_decrypt_with_key(encrypted_data, key)
        
        if decrypted_data:
            # Save the decrypted data to a file
            decrypted_file_path = os.path.join(output_directory, f'decrypted_file_{i}.vhd')
            with open(decrypted_file_path, 'wb') as file:
                file.write(decrypted_data)
            print(f'Decrypted file saved as {decrypted_file_path}')
        else:
            print(f"Failed to decrypt with key {key_hex}")

if __name__ == "__main__":
    main()

