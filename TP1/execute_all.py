
import glob
import os
import sys

print(sys.argv)


modeles = glob.glob("./Modeles/*")
datas = glob.glob("./LNH/*")

time_limit = 30000
if(len(sys.argv) >= 2):
    time_limit = int(sys.argv[1])

for m in modeles:
    modele_name = m.split("/")[-1].split(".")[0]
    for d in datas:
        data_name = d.split("/")[-1].split(".")[0]
        os.makedirs("output/{}/".format(modele_name), exist_ok=True)
        os.system("minizinc {} -d {} -s -a --output-time --solver-time-limit {} > output/{}/{}.txt".format(m, d, time_limit, modele_name, data_name))

# minizinc Modeles/Modele2.mzn -d LNH/LNH8a.dzn -s -a --output-time --solver-time-limit