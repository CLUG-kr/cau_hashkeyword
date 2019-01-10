
# coding: utf-8

# In[120]:


from bs4 import BeautifulSoup
from urllib.request import urlopen
from selenium import webdriver
import re


# In[121]:


options = webdriver.ChromeOptions()
options.add_argument('headless')
options.add_argument('window-size=1920x1080')
options.add_argument('disable-gpu')


# In[131]:


cau_list = []
cau_url_list = []
cau_date_list = []

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://www.cau.ac.kr/cms/FR_CON/index.do?MENU_ID=100")
driver.implicitly_wait(3)

#caunotice_page = driver.page_source
#caunotice_soup = BeautifulSoup(caunotice_page,'lxml')

cau_base_url = "https://www.cau.ac.kr/cms/FR_CON/BoardView.do?MENU_ID=100&CONTENTS_NO=1&SITE_NO=2&P_TAB_NO=&TAB_NO=&BOARD_SEQ=4&BOARD_CATEGORY_NO=&BBS_SEQ="
# BBS_SEQ=19642 (id=board_19642)

title_list = driver.find_elements_by_class_name("txtL")
for item in range(len(title_list)):
    cau_list.append(title_list[item].find_element_by_tag_name('a').text)

url_list = driver.find_element_by_id("tbody").find_elements_by_tag_name("li")
for item in url_list:
    cau_url_list.append(cau_base_url + item.get_attribute("id").replace("board_",""))

date_list = driver.find_elements_by_class_name("txtInfo")
for item in range(len(date_list)):
    cau_date_list.append(date_list[item].find_element_by_class_name("date").text)

driver.close()


# In[182]:


lib_list = []
lib_url_list = []
lib_date_list = []

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20")
driver.implicitly_wait(3)

#제목 크롤링 부분
#title_list = driver.find_elements_by_class_name("ikc-item-title")
#for line in range(len(title_list)):
#    lib_list.append(title_list[line].text)

board_list = driver.find_elements_by_class_name("ikc-item")
#회색 상단 공지 부분으로 아래 공지 중에서 중요한 것들만 올려놓은듯. 즉, 겹치는 내용임.
#for item in board_list[0].find_elements_by_tag_name("tr"):
#    print(item.find_elements_by_tag_name("td")[3].find_elements_by_tag_name("span")[1].text)

try:
    for item in board_list: # tbody 검색후, ikc-item 검색시, 가끔씩 IndexError: list index out of range 발생
        lib_list.append(item.find_elements_by_tag_name("td")[2].find_element_by_tag_name('a').text) # 대체
        lib_date_list.append(item.find_elements_by_tag_name("td")[3].find_elements_by_tag_name("span")[1].text)
except IndexError:
    print("IndexError")
    pass

lib_base_url = "https://library.cau.ac.kr/#/bbs/notice/"
# 사이에 id 추가
lib_sub_url = "?offset=0&max=20"

# url id는 어떻게 가져올까..

driver.close()


# In[58]:


# 노란색 공지 부분만 가져온다
dorm_list = []
dorm_url_list = []
dorm_date_list = []

dormnotice_url = "https://dormitory.cau.ac.kr/bbs/bbs_list.php?bbsID=notice"
dormnotice_page = urlopen(dormnotice_url)
dormnotice_soup = BeautifulSoup(dormnotice_page, "lxml")

#print(dormnotice_soup.prettify())
dormnotice_list = dormnotice_soup.find(id='content').find('div').find_all('tr',{'bgcolor':'#fffcdb'})
if dormnotice_list == []:
    print("No data")
else :
    for item in dormnotice_list:
        dorm_list.append(item.find('span',class_='bbsTitle').get_text())
        dorm_url_list.append(item.find('a')['href'])
        dorm_date_list.append(item.find_all('td',class_='t_c')[3].get_text())

#try-except 적용하기?


# In[141]:


ict_list = []
ict_url_list = []
ict_date_list = []

ictnotice_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php"
ictnotice_page = urlopen(ictnotice_url)
ictnotice_soup = BeautifulSoup(ictnotice_page, "lxml")

ict_base_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php?cmd=view&cpage=1&idx="
# 사이에 id 작성
ict_sub_url = "&search_gbn=1&search_keyword="

ictnotice_list = ictnotice_soup.find('tbody').find_all('tr')
if ictnotice_list == []:
    print("No data")
else:
    for item in ictnotice_list:
        ict_list.append(item.find('td',class_='cont').find('a').get_text())
        ict_url_list.append(ict_base_url + item.find('td',class_='cont').find('a')['href'][-7:-3] + ict_sub_url)
        ict_date_list.append(item.find_all('td')[2].get_text())


# In[118]:


cse_list = []
cse_url_list = []
cse_date_list = []

csenotice_url = "http://cse.cau.ac.kr/20141201/sub05/sub0501.php"
csenotice_page = urlopen(csenotice_url)
csenotice_soup = BeautifulSoup(csenotice_page, "lxml")

csenotice_list = csenotice_soup.find('table',class_='nlist').find_all('tr')

if csenotice_list == []:
    print("No data")
else:
    for item in csenotice_list:
        cse_list.append(re.sub('[\n\t\xa0]','',item.find('a').get_text())) # sub메소드 사용법 검토하기
        cse_url_list.append(csenotice_url + item.find_all('td')[2].find('a')['href'])
        cse_date_list.append(item.find_all('td')[4].get_text())


# In[18]:


result = []
keyword = input("알림 받고자 하는 키워드를 입력해주세요! # ")
result = [string for string in dorm_list if keyword in string]
result
