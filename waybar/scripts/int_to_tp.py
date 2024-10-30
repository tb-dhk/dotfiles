import sys

# Define Toki Pona number words
toki_pona_numbers = {
    1: "wan",
    2: "tu",
    5: "luka",
    20: "mute",
    100: "ale"
}

def number_to_toki_pona(n):
    if n in toki_pona_numbers:
        return toki_pona_numbers[n]

    result = []
    if n >= 100:
        hundreds = n // 100
        result.extend(["ale"] * hundreds)
        n %= 100

    if n >= 20:
        twenties = n // 20
        result.extend(["mute"] * twenties)
        n %= 20

    if n >= 5:
        fives = n // 5
        result.extend(["luka"] * fives)
        n %= 5

    if n > 0:
        result.extend([toki_pona_numbers[1]] * n)

    # Join result with + if it's below 20, otherwise with spaces
    if int(sys.argv[1]) < 20:
        return "+".join(result)
    else:
        return " ".join(result)

# Main program
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python toki_pona_number.py <number>")
        sys.exit(1)

    try:
        num = int(sys.argv[1])
        print(number_to_toki_pona(num))
    except ValueError:
        print("Please provide a valid integer.")
