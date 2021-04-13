import time
start_time=time.time()
#######################################
from scipy import stats
import numpy as np

mydata=open(r'D:\Control.txt')
line=mydata.readline()
line=mydata.readline()

m=0
mydict={}
while line:
    mydict[line.split('\t')[0]]=line
    line=mydata.readline()
    m=m+1
    print m
mydata.close()
print "file finished"

myfile=open(r'D:\Case.txt')
output=open(r'D:\TtestResult.txt','w')
line1=myfile.readline()
line1=myfile.readline()
n=0
while line1:
    array1=np.array(line1.strip().split('\t')[1:]).astype(float)
    array2=np.array(mydict[line1.split('\t')[0]].strip().split('\t')[1:]).astype(float)
    mymean1=np.mean(array1)
    mymean2=np.mean(array2)
    mydiff=mymean1-mymean2
    myt,myp=stats.ttest_ind(array1,array2)
    output.write(line1.split('\t')[0]+'\t'+str(mymean1)+'\t'+str(mymean2)+'\t'+str(mydiff)+'\t'+str(myp)+'\n')
    line1=myfile.readline()
    n=n+1
    print 'n='+str(n)
###########################
end_time=time.time()
myUse_time=end_time-start_time
print myUse_time
