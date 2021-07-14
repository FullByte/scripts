# Check groups for Würfel game:
# Step 1 create all possible options for 3x D6 dice
# Step 2 remove doubles -> if total is 1 = Dreifaltigkeit, 2 = Wunsch
# Step 3 with all remaining sort numbers and count min distance between all three values. If min distance is 1 = Unvermeidlich, else Einhorn

from itertools import product # pip install itertools
from collections import OrderedDict
import math

# Dice settings
diceFaces = 6
diceSmallestNumber = 1
diceHighestNumber = 6
diceAmount = 3

# Counter
Dreifaltigkeit = 0
Wunsch = 0
Unvermeidlich = 0
Einhorn = 0

# Create a list of all possible roll attempts
rolls = list(product(range(diceSmallestNumber,diceHighestNumber+1), repeat=diceAmount))

# Iterate roll attempts and check result
for roll in rolls:
    # Prepare list
    removedDoubleRoll = tuple(OrderedDict.fromkeys(roll).keys())
    sortedRoll = list(removedDoubleRoll)
    sortedRoll.sort() 

    # Count and print result
    if (len(sortedRoll)==2):
        print(roll, " Wunsch")
        Wunsch += 1
    elif (len(sortedRoll)==1):
        print(roll, " Dreifaltigkeit")
        Dreifaltigkeit += 1
    else:
        if ((sortedRoll[1]-sortedRoll[0]==1) or (sortedRoll[2]-sortedRoll[1]==1)):
            print(sortedRoll, " Unvermeidlich")
            Unvermeidlich += 1
        else:
            print(sortedRoll, " Einhorn")
            Einhorn += 1

# Print stats
print("\nTotal amount of possible rolls: ", len(rolls))
print("Total amount of distint rolls: ", int((math.factorial(diceFaces+diceAmount-1))/(math.factorial(diceAmount)*(math.factorial(diceFaces-1)))))

print("\nDreifaltigkeit: ", Dreifaltigkeit, "({:.1f}".format(Dreifaltigkeit / len(rolls) * 100), "%)")
print("Wunsch: ", Wunsch, "({:.1f}".format(Wunsch / len(rolls) * 100), "%)")
print("Unvermeidlich: ", Unvermeidlich, "({:.1f}".format(Unvermeidlich / len(rolls) * 100), "%)")
print("Einhorn: ", Einhorn, "({:.1f}".format(Einhorn / len(rolls) * 100), "%)")
