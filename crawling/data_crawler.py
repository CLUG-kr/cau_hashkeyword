
# coding: utf-8

# In[12]:


from bs4 import BeautifulSoup
from urllib.request import urlopen
from selenium import webdriver


# In[13]:


options = webdriver.ChromeOptions()
options.add_argument('headless')
options.add_argument('window-size=1920x1080')
options.add_argument('disable-gpu')


# In[14]:


driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://www.cau.ac.kr/cms/FR_CON/index.do?MENU_ID=100")
driver.implicitly_wait(3)

#caunotice_page = driver.page_source
#caunotice_soup = BeautifulSoup(caunotice_page,'lxml')

board_list = driver.find_elements_by_class_name("txtL")
for line in range(len(board_list)):
    print(board_list[line].find_element_by_tag_name('a').text)

driver.close()


# In[15]:


driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20")
driver.implicitly_wait(3)

#libnotice_url = ""
#libnotice_page = urlopen(libnotice_url)
#libnotice_soup = BeautifulSoup(libnotice_page, "lxml")

board_list = driver.find_elements_by_class_name("ikc-item-title")
for line in range(len(board_list)):
    print(board_list[line].text)

driver.close()


# In[16]:


dorm_list = []

dormnotice_url = "https://dormitory.cau.ac.kr/bbs/bbs_list.php?bbsID=notice"
dormnotice_page = urlopen(dormnotice_url)
dormnotice_soup = BeautifulSoup(dormnotice_page, "lxml")

dormnotice_list = dormnotice_soup.find_all('span',class_='bbsTitle')
if dormnotice_list == []:
    print("No data")
else :
    for item in dormnotice_list:
        print(item.get_text())
        dorm_list.append(item.get_text())
#try-except 적용하기?


# In[17]:


ictnotice_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php"
ictnotice_page = urlopen(ictnotice_url)
ictnotice_soup = BeautifulSoup(ictnotice_page, "lxml")

ictnotice_list = ictnotice_soup.find_all('td',class_='cont')
if ictnotice_list == []:
    print("No data")
else:
    for item in ictnotice_list:
        print(item.find('a').get_text())


# In[35]:


csenotice_url = "http://cse.cau.ac.kr/20141201/sub05/sub0501.php"
csenotice_page = urlopen(csenotice_url)
csenotice_soup = BeautifulSoup(csenotice_page, "lxml")

csenotice_list = csenotice_soup.find('table',class_='nlist').find_all('tr')
if csenotice_list == []:
    print("No data")
else:
    for item in csenotice_list:
        print(item.find('a').get_text())


# In[18]:


result = []
keyword = input("알림 받고자 하는 키워드를 입력해주세요! # ")
result = [string for string in dorm_list if keyword in string]
result

