from datetime import datetime, timedelta, date, time
import geocoder
import os
from pytz import timezone
import requests

# Holiday lengths in weeks
HOLIDAYS = [1, 4, 1]  # Holidays between terms

def print_attribute(attr, value):
    return f"{attr}: {value}".lower()

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

today = date.today()
now = datetime.now()

# Example usage of the function
school_term_info = get_school_term_and_week(today)
term_info = f"Term: {school_term_info}" if isinstance(school_term_info, tuple) else school_term_info

# Output to be displayed on Polybar
print(print_attribute("Date", today.strftime("%Y-%m-%d")))
print(print_attribute("Time", now.strftime("%H:%M:%S")))
print(print_attribute("Country", get_timezone_and_country()[0]))
print(print_attribute("Timezone", get_timezone_and_country()[1]))
print(print_attribute("School Term", term_info))
