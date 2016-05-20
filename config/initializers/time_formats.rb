Time::DATE_FORMATS[:weekday] = lambda { |time| time.strftime("%A") }
Time::DATE_FORMATS[:ordinal_weekday_month_day] = lambda { |time| time.strftime("%A, %B #{time.day.ordinalize}") }
Time::DATE_FORMATS[:ordinal_weekday_month_day_short] = lambda { |time| time.strftime("%a, %b #{time.day.ordinalize}") }
Time::DATE_FORMATS[:weekday_month_day_short] = lambda { |time| time.strftime("%a, %b %-d") }
Time::DATE_FORMATS[:weekday_month_short_day] = lambda { |time| time.strftime("%A, %b %-d") }
Time::DATE_FORMATS[:ordinal_month_day] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
Time::DATE_FORMATS[:short_time] = lambda { |time| time.min == 0 ? time.strftime("%-I%P") : time.strftime("%-I:%M%P") }

Date::DATE_FORMATS[:ordinal_weekday_month_day] = Time::DATE_FORMATS[:ordinal_weekday_month_day]
Date::DATE_FORMATS[:ordinal_month_day] = Time::DATE_FORMATS[:ordinal_month_day]
