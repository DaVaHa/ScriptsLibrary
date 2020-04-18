'''

Significantie - Recuperatie


RecuperatieVJ20	Gosselies	BEBEFR	FOLDER	2459	315	0.1281008540056
RecuperatieVJ20	Gosselies	BEBEFR	RANDOM	273	28	0.1025641025641

'''

import numpy as np
import random

# parameters
length_1 = 14951
length_2 = 1657
respons_1 = 1847
respons_2 =  178

print("Respons Folder : {} ({})".format(round(respons_1 / length_1,4), length_1))
print("Respons Random : {} ({})".format(round(respons_2 / length_2,4), length_2))

## 
group_1 = [0 for i in range(length_1 + length_2 - respons_1 - respons_2)]
group_2 = [1 for i in range(respons_1 + respons_2)]

full_group = group_1 + group_2 # 0,0,0,0 ... ,1,1,1,1

#print(len(group_1))
#print(len(group_2))
#print(sum(full_group))

# Shuffle 10.000 times
distribution = []
for i in range(10000):
    #print("\nshuffle : {}".format(i))
    # shuffle all observations
    random.shuffle(full_group)  # 0,0,1,0,1,1,0,1
    # mean of two reshuffled samples
    sum_1 = np.sum(full_group[:length_1])
    sum_2 = np.sum(full_group[length_1:])
    resp_1 = sum_1 / length_1
    resp_2 = sum_2 / length_2
    #print(respons_1)
    #print(respons_2)
    
    # add difference to list
    distribution.append(abs(resp_1 - resp_2))
    
    #print(group[:5])
    #print(mean_1, mean_2)
    #print(distribution)


# Number of new statistics differences
original_mean = abs(respons_1 / length_1 - respons_2 / length_2)
print("Origineel verschil : {}".format(original_mean))
diffs = [d for d in distribution if d >= original_mean]
pvalue = len(diffs)/len(distribution)

print("P-value is : {} (HACKING WAY)".format(round(pvalue,10)))



