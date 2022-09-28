from deutschland.bundesanzeiger import Bundesanzeiger
ba = Bundesanzeiger()
# search term
data = ba.get_reports("Deutsche Bahn AG")
# returns a dictionary with all reports found as fulltext reports
print(data.keys())
# dict_keys(['Jahresabschluss zum Geschäftsjahr vom 01.01.2020 bis zum 31.12.2020', 'Konzernabschluss zum Geschäftsjahr vom 01.01.2020 bis zum 31.12.2020\nErgänzung der Veröffentlichung vom 04.06.2021',