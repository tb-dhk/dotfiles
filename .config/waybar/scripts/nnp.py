import sys

# Precompute these as sets/tuples for faster lookups
NUMBERS = [
    "󱤂", "󱥳", "󱥮", "󱥮‍󱥳", "󱥮‍󱥮", "󱤭", "󱤭‍󱥳", "󱤭‍󱥮", 
    "󱤭‍󱥮‍󱥳", "󱤭‍󱥮‍󱥮", "󱤭‍󱤭", "󱤭‍󱤭‍󱥳", "󱤭‍󱤭‍󱥮",
    "󱤭‍󱤭‍󱥮‍󱥳", "󱤭‍󱤭‍󱥮‍󱥮", "󱤭‍󱤭‍󱤭", "󱤭‍󱤭‍󱤭‍󱥳",
    "󱤭‍󱤭‍󱤭‍󱥮", "󱤭‍󱤭‍󱤭‍󱥮‍󱥳", "󱤭‍󱤭‍󱤭‍󱥮‍󱥮"
]

MUTES = ["󱤂", "󱤼", "󱤼‍󱤼", "󱤼‍󱤼󱤼", "󱤼‍󱤼󱤼‍󱤼"]

A_CHAR = "󱤄"

def convert(num, noala=False):
    """Convert number to special character representation"""
    if num >= 100:
        return convert(num // 100, noala=True) + A_CHAR + convert(num % 100, noala=True)
    elif num >= 20:
        return MUTES[num // 20] + convert(num % 20, noala=noala)
    else:
        if not num:
            if noala:
                return ""
        return NUMBERS[num]

def split_tokens_optimized(string):
    """Optimized token splitting - single pass"""
    if not string:
        return []
    
    ls = []
    current_type = string[0].isnumeric()
    current_token = string[0]
    
    for char in string[1:]:
        char_type = char.isnumeric()
        if char_type != current_type:
            ls.append(current_token)
            current_token = char
            current_type = char_type
        else:
            current_token += char
    ls.append(current_token)
    return ls

def findlength(string):
    """Calculate display length excluding zero-width joiners"""
    return len(string) - 2 * string.count("‍")

def lpad(string, length, filler):
    """Left pad string to specified display length"""
    current_len = findlength(string)
    if current_len >= length:
        return string
    
    # Build padding more efficiently
    padding_needed = length - current_len
    return filler * padding_needed + string

def main():
    if len(sys.argv) > 1:
        data = sys.argv[1]
        
        # Get paddings if provided
        paddings = []
        if len(sys.argv) > 2:
            try:
                paddings = [int(i) for i in sys.argv[2].split(".")]
            except ValueError:
                pass
        
        # Single pass processing
        tokens = split_tokens_optimized(data)
        result_parts = []
        padding_index = 0
        
        for token in tokens:
            if token.isnumeric():
                try:
                    num = int(token)
                    converted = convert(num)
                    
                    # Apply padding if needed
                    if padding_index < len(paddings):
                        converted = lpad(converted, paddings[padding_index], "󱤂")
                        padding_index += 1
                    
                    result_parts.append(converted)
                except (ValueError, IndexError):
                    result_parts.append(token)
            else:
                result_parts.append(token)
        
        out = "".join(result_parts)
        sys.stdout.write(out)
        sys.stdout.flush()

if __name__ == "__main__":
    main()
