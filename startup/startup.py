from datetime import datetime, timedelta, date, time
import geocoder
import os
from pytz import timezone
import requests
import sys

def draw_ascii_line(char='*'):
    try:
        screen_width = int(sys.argv[1])
    except:
        screen_width = 100
    pprint(char * screen_width)


def get_display_width(text):
    """
    Calculate the display width of the given text, accounting for double-width characters.
    """
    width = 0
    for char in text:
        if ord(char) > 0x1100 and (
            ord(char) < 0x115f or ord(char) > 0x11a2) and not (0x2329 <= ord(char) <= 0x232a):
            width += 2  # Korean and some other double-width characters
        else:
            width += 1
    return width

def pprint(text=""):
    for line in text.split("\n"):
        if not line:
            line = " "
        actual_width = get_display_width(line)
        padding = int(sys.argv[1]) - 2 - actual_width

        if line[0] == "*":
            print(line.ljust(int(sys.argv[1]), "*"))
        else:
            print(" " + line + " " * padding + " ")


# Holiday lengths in weeks
HOLIDAYS = [1, 4, 1]  # Holidays between terms

def print_progress_bar(percentage, length):
    filled_length = int(length * percentage)
    bar = '=' * filled_length + ' ' * (length - filled_length)
    return f'[{bar}] {percentage:6.1%}'

def get_school_term_and_week(today):
    # Assuming the school year starts on the first Monday of January
    start_of_year = date(today.year, 1, 1)
    start_of_school_year = start_of_year + timedelta(days=(7 - start_of_year.weekday()) % 7)
    
    if today < start_of_school_year:
        start_of_school_year = start_of_school_year.replace(year=today.year - 1)

    # Define term lengths including holidays
    term_lengths = [10, 10, 10, 8]  # Last term is 8 weeks long
    holidays = [timedelta(weeks=length) for length in HOLIDAYS]
    
    current_day = start_of_school_year
    term = 1

    while term <= 4:
        term_end = current_day + timedelta(weeks=term_lengths[term - 1])

        if current_day <= today < term_end:
            week_number = (today - current_day).days // 7 + 1
            return term, week_number
        else:
            current_day = term_end + holidays[term - 1] if term < 4 else term_end
            term += 1

    # If today is after the last term ends
    return "Holiday after term 4"

def get_timezone_and_country():
    try:
        # Use an alternative method to get timezone and country
        # Using an IP geolocation service
        response = requests.get('https://ipapi.co/json/')
        ip_info = response.json()
        country = ip_info.get('country_name', 'Unknown')
        timezone_str = ip_info.get('timezone', 'UTC')
        tz = timezone(timezone_str)
        gmt_offset = tz.utcoffset(datetime.now()).total_seconds() / 3600
        gmt_offset_str = f"GMT{'+' if gmt_offset >= 0 else '-'}{int(abs(gmt_offset)):02d}"
        return f"{ip_info.get('city', 'Unknown')}, {country}", f"UTC ({gmt_offset_str})"
    except:
        return "Singapore, Singapore", "UTC (GMT+8)"

def print_attribute_with_progress(attr, value, progress=None, width=100):
    # Calculate the width for the progress bar
    progress_bar_width = width - 60  # 38 spaces for attr + 20 spaces for value + 2 for formatting

    # Format the output
    attr_formatted = f"{attr}".ljust(20).lower() + ": "
    value_formatted = f"{value}".ljust(20).lower()
    progress_bar = print_progress_bar(progress, progress_bar_width) if progress is not None else ""

    pprint(f"{attr_formatted}{value_formatted} {progress_bar}") 

def get_weekday_progress(today):
    # Calculate the start of the week (Sunday) and the end of the week (Saturday)
    start_of_week = today - timedelta(days=(today.weekday() if today.weekday() != 6 else -1) + 1)  # Adjust so that week starts on Sunday
    end_of_week = start_of_week + timedelta(days=6)  # End of the week is 6 days after the start
    week_progress = (today - start_of_week) / (end_of_week - start_of_week + timedelta(days=1)) + time_progress / 7
    return week_progress 

# Example usage of the function
today = date.today()
year_progress = (today - date(today.year, 1, 1)) / (date(today.year + 1, 1, 1) - date(today.year, 1, 1))
today_text = today.strftime("%Y.%m.%d")
now = datetime.now()
current_time = now.strftime("%H:%M:%S")
time_progress = (now - datetime.combine(today, time(0, 0, 0))) / timedelta(days=1)

draw_ascii_line()

# Print date and year progress
print_attribute_with_progress("today's date", today_text, year_progress, width=int(sys.argv[1]))
pprint()

# Example school term and week logic (assuming you have these functions)
school_term_info = get_school_term_and_week(today)

if isinstance(school_term_info, tuple):
    term, week = school_term_info
    
    # Define term lengths including holidays
    term_lengths = [10, 10, 10, 8]  # Last term is 8 weeks long
    
    # Base progress calculations
    if term < 4:
        base_term_progress = (week % 10) / 10
        base_school_year_progress = (term - 1) * 10 / 38 + base_term_progress / 4
    else:
        base_term_progress = (week % 8) / 8  # For Term 4
        base_school_year_progress = (term - 1) * 10 / 38 + base_term_progress / 4
    
    # Incorporate weekday progress into the term and school year progress
    weekday_progress = get_weekday_progress(today)
    
    # Adjust the progress by incorporating weekday progress
    school_year_progress = base_school_year_progress + (weekday_progress / 7) * (1 / 38)
    term_progress = base_term_progress + (weekday_progress / 7) * (1 / 8 if term == 4 else 1 / 10)

    print_attribute_with_progress("term", f"{term}", school_year_progress, width=int(sys.argv[1]))
    print_attribute_with_progress("week", f"{week}", term_progress, width=int(sys.argv[1]))
else:
    pprint(school_term_info)  # This will print "Holiday after term x"

# Print progress through the week
day_of_week = today.strftime("%A")
week_progress = get_weekday_progress(today)
print_attribute_with_progress("day of week", day_of_week, week_progress, width=int(sys.argv[1]))
pprint()

# Print time and day progress
print_attribute_with_progress("time now", current_time, time_progress, width=int(sys.argv[1]))
pprint()

# Print location
g = geocoder.ip('me')
latitude, longitude = g.latlng
print_attribute_with_progress("current location", f"{latitude}°N, {longitude}°E", width=int(sys.argv[1]))

# Print country and timezone
country, tz = get_timezone_and_country()
print_attribute_with_progress("location", country, width=int(sys.argv[1]))
print_attribute_with_progress("timezone", tz, width=int(sys.argv[1]))

# Print hostname and IP address
hostname = os.uname()[1]
ip_address = geocoder.ip('me').ip
print_attribute_with_progress("hostname", hostname, width=int(sys.argv[1]))
print_attribute_with_progress("ip address", ip_address, width=int(sys.argv[1]))
pprint()

def combine_ascii_art(ascii_cube, tripleS):
    try:
        screen_width = int(sys.argv[1])
    except:
        screen_width = 100

    if screen_width < 150:
        # If ascii_cube is empty or only contains whitespace, use only tripleS
        ascii_cube = ""
        
    # Split the ASCII art into lines
    cube_lines = ascii_cube.splitlines()[1:] if ascii_cube else []
    tripleS_lines = tripleS.splitlines()[1:]

    if not ascii_cube:
        # If ascii_cube is None, just center the tripleS
        max_tripleS_width = max(get_display_width(line) for line in tripleS_lines)
        combined_lines = [line.center(screen_width).rstrip() for line in tripleS_lines]
    else:
        # Shift lines to the right by 10 spaces
        cube_lines = [' ' * 10 + line for line in cube_lines]
        tripleS_lines = [' ' * 10 + line for line in tripleS_lines]

        # Find the maximum width of both ASCII arts, accounting for double-width characters
        max_cube_width = max(get_display_width(line) for line in cube_lines)
        max_tripleS_width = max(get_display_width(line) for line in tripleS_lines)

        # Calculate the vertical centering for tripleS
        total_height = max(len(cube_lines), len(tripleS_lines))
        tripleS_start_row = (total_height - len(tripleS_lines)) // 2

        # Prepare the combined art lines
        combined_lines = []
        for i in range(total_height):
            # Get the current line for both ASCII arts, or use an empty string if the line doesn't exist
            cube_line = cube_lines[i] if i < len(cube_lines) else ''
            tripleS_line = tripleS_lines[i - tripleS_start_row] if tripleS_start_row <= i < tripleS_start_row + len(tripleS_lines) else ''

            # Calculate the combined width
            combined_line = cube_line + tripleS_line
            combined_width = get_display_width(combined_line)

            # Adjust for screen width and center align
            if combined_width < screen_width:
                padded_line = combined_line.ljust(screen_width)
            else:
                padded_line = combined_line[:screen_width]  # Truncate if it exceeds screen width

            combined_lines.append(padded_line.rstrip())
        
    # Return the combined ASCII art
    return "\n".join(combined_lines)

ascii_cube = """
                @@                
             @@@@@@@@             
         @@@@       @@@@          
      @@@@      @       @@@@      
   @@@@@@       @@@@@      @@@@   
@@@@    @@@@@      @@@@@      @@@@
@@@@@      @@@@@      @@@@@  @@@@@
@@  @@@@      @@@@@      @@@@@  @@
@@     @@@@            @@@@     @@
@@        @@@@      @@@@      @@@@
@@   @@       @@@@@@       @@@@-@@
@@    @@@@@     @@     @@@@@    @@
@@@      @@@@@  @@   @@@@       @@
@@@@@@      @@@@@@   @      @   @@
@@  @@@@@      @@@       @@@@   @@
@@     @@@@@    @@    @@@@@     @@
@@@@      @@@   @@ @@@@       @@@@
    @@@         @@@@      @@@@    
       @@@@     @@     @@@@       
          @@@@  @@  @@@@          
             @@@@@@@@             
                @@                                
""" 
tripleS = """
  _        _       _      ____  
 | |_ _ __(_)_ __ | | ___/ ___| 
 | __| '__| | '_ \| |/ _ \___ \ 
 | |_| |  | | |_) | |  __/___) |
  \__|_|  |_| .__/|_|\___|____/ 
            |_|                 
  모든 가능성의 아이돌      
  the idol of all possibilities
"""

# Combine and center the ASCII art
combined_art = combine_ascii_art(ascii_cube, tripleS)
pprint(combined_art)

draw_ascii_line()
