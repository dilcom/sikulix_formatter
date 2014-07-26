sikulix_formatter
=================

Custom html formatter for Cucumber with images.

Based on Cucumber`s basic html formatter. 

Each image in report becomes surrounded with <a></a> tag. Hovering any name of image makes the image itself to appear near cursor.

Formatter itself is in ./features/support/Sikulix folder

usage:
cucumber ./features -f Sikulix::Html -o ./reports/report.html