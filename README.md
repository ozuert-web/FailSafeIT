FailSafe IT


FailSafe IT:s databas hanterar kunder, konsulter och uppdrag. Varje uppdrag kopplar en kund till en konsult och innehåller startdatum, slutdatum och rollbeskrivning. En kund eller konsult kan ha noll eller flera uppdrag. ER-diagrammet finns som PNG i repot.

Kör skriptet

Öppna `FailSafeIT.sql` i SQL Server Management Studio (SSMS), välj en tom databas och kör hela filen. Skriptet skapar tabellerna, lägger in testdata och kör frågorna A–E.

Normalisering

- 1NF.Varje kolumn innehåller ett värde per rad. En konsult har en huvudsaklig specialitet och varje uppdrag får en egen rad.

- 2NF. Alla kandidatnycklar består av en enda kolumn. Varje attribut som inte ingår i en kandidatnyckel beror därför på hela nyckeln.

- 3NF. Attribut som inte ingår i en kandidatnyckel har inga transitiva beroenden via andra sådana attribut. Kundens företagsnamn och kontaktuppgifter finns i `Kund`, konsultens namn och timpris finns i `Konsult`, och uppdragets datum och rollbeskrivning finns i `Uppdrag`. Främmande nycklar länkar uppdraget till rätt kund och konsult.

DevSecOps

Sec.Jag använder parametriserade SQL-frågor så att värden från webbformulär behandlas som data. Webbapplikationens databaskonto får bara de behörigheter som appen behöver.

Ops.Den unika begränsningen på `Kund.Organisationsnummer` skapar ett unikt index som SQL Server kan använda för att snabbt hitta en kund via organisationsnumret. Indexet på `Uppdrag.KundID` hjälper sedan SQL Server att hitta den kundens uppdrag.

Aktiva uppdrag och borttagning

Ett uppdrag räknas som aktivt från startdatum till slutdatum, inklusive båda dagarna. Fråga E tar bort testkunden Bergdala eftersom kunden saknar kopplade uppdrag. Villkoret bevarar även kunder med avslutade eller planerade uppdrag så att deras uppgifter finns kvar.
