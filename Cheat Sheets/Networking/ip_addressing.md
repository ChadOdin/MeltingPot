# Converting Binary to Decimal and Hex for IPv4 Addressing

## Converting Binary to Decimal

1. **Divide the Binary Address into Octets (8 bits each):**
   - Example: `11000000.10101000.00000001.00000001`

2. **Convert Each Octet to Decimal:**
   - `11000000` -> `192`
   - `10101000` -> `168`
   - `00000001` -> `1`
   - `00000001` -> `1`

3. **Combine the Decimal Values:**
   - Result: `192.168.1.1`

## Converting Binary to Hexadecimal

1. **Divide the Binary Address into Octets (8 bits each):**
   - Example: `11000000.10101000.00000001.00000001`

2. **Split Each Octet into Nibbles (4 bits each):**
   - `11000000` -> `1100` `0000`
   - `10101000` -> `1010` `1000`
   - `00000001` -> `0000` `0001`
   - `00000001` -> `0000` `0001`

3. **Convert Each Nibble to Hex:**
   - `1100` -> `C`
   - `0000` -> `0`
   - `1010` -> `A`
   - `1000` -> `8`
   - `0000` -> `0`
   - `0001` -> `1`
   - `0000` -> `0`
   - `0001` -> `1`

4. **Combine the Hex Values:**
   - Result: `C0.A8.01.01`
