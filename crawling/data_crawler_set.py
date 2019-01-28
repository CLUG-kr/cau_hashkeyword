
# coding: utf-8

# In[2]:


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

# Fetch the service account key JSON file contents
cred = credentials.Certificate('/Users/Solomon/Desktop/cau-hashkeyword-serviceAccountKey.json')

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://cau-hashkeyword.firebaseio.com'
})

ref = db.reference('server/saving-data/crawling')


# In[3]:


from bs4 import BeautifulSoup
from urllib.request import urlopen
from selenium import webdriver
import re


# In[3]:


options = webdriver.ChromeOptions()
options.add_argument('headless')
options.add_argument('window-size=1920x1080')
options.add_argument('disable-gpu')


# In[10]:


cau_title_list = []
cau_date_list = []
cau_url_list = []

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://www.cau.ac.kr/cms/FR_CON/index.do?MENU_ID=100")
driver.implicitly_wait(3)

cau_base_url = "https://www.cau.ac.kr/cms/FR_CON/BoardView.do?MENU_ID=100&CONTENTS_NO=1&SITE_NO=2&P_TAB_NO=&TAB_NO=&BOARD_SEQ=4&BOARD_CATEGORY_NO=&BBS_SEQ="
# BBS_SEQ=19642 (id=board_19642)

board_list = driver.find_element_by_id("tbody").find_elements_by_tag_name("li")
board_list.reverse()
# count = 0
for item in board_list:
    # if count < 10: pass # 테스트용
    # else:
    cau_title_list.append(item.find_element_by_class_name("txtL").find_element_by_tag_name('a').text)
    cau_date_list.append(item.find_element_by_class_name("txtInfo").find_element_by_class_name("date").text)
    cau_url_list.append(cau_base_url + item.get_attribute("id").replace("board_",""))
    # count += 1
driver.close()

# list 앞에 원소를 추가할 때, insert(0,data) 사용 시 O(n)
# class collections.deque([iterable[, maxlen]])의 dequeue() 사용 시 O(1)
# High Performance를 원한다면 사용하자.

# 혹은 list reverse 후, append 계속 사용 (단, reverse의 경우 O(n))


# In[11]:


lib_title_list = []
lib_date_list = []
lib_url_list = []

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20")
driver.implicitly_wait(3)

try:
    # tbody[0]는 회색 상단 공지 부분으로 아래 공지 중에서 중요한 것들만 올려놓은듯. 즉, 겹치는 내용임.
    board_list = driver.find_elements_by_tag_name("tbody")[1].find_elements_by_class_name("ikc-item")
    board_list.reverse()
    for item in board_list: # tbody 검색후 ikc-item 검색시, 가끔씩 IndexError: list index out of range 발생 (이유 모름)
        lib_title_list.append(item.find_elements_by_tag_name("td")[2].find_element_by_tag_name('a').text) # 대체
        lib_date_list.append(item.find_elements_by_tag_name("td")[3].find_elements_by_tag_name("span")[1].text)
except IndexError:
    print("IndexError")
    pass

lib_base_url = "https://library.cau.ac.kr/#/bbs/notice/"
# 사이에 id 추가
lib_sub_url = "?offset=0&max=20"
# url id는 어떻게 가져올까..

driver.close()


# In[14]:


# 노란색 공지 부분만 가져온다
dorm_title_list = []
dorm_date_list = []
dorm_url_list = []

dormnotice_url = "https://dormitory.cau.ac.kr/bbs/bbs_list.php?bbsID=notice"
dormnotice_page = urlopen(dormnotice_url)
dormnotice_soup = BeautifulSoup(dormnotice_page, "lxml")

dormnotice_list = dormnotice_soup.find(id='content').find('div').find_all('tr',{'bgcolor':'#fffcdb'})
dormnotice_list.reverse()

if dormnotice_list == []:
    print("No data")
else :
    for item in dormnotice_list:
        dorm_title_list.append(item.find('span',class_='bbsTitle').get_text())
        dorm_url_list.append(item.find('a')['href'])
        dorm_date_list.append("20" + item.find_all('td',class_='t_c')[3].get_text())

#try-except 적용하기?


# In[13]:


ict_title_list = []
ict_date_list = []
ict_url_list = []

ictnotice_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php"
ictnotice_page = urlopen(ictnotice_url)
ictnotice_soup = BeautifulSoup(ictnotice_page, "lxml")

ict_base_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php?cmd=view&cpage=1&idx="
# 사이에 id 작성
ict_sub_url = "&search_gbn=1&search_keyword="

ictnotice_list = ictnotice_soup.find('tbody').find_all('tr')
ictnotice_list.reverse()

if ictnotice_list == []:
    print("No data")
else:
    for item in ictnotice_list:
        ict_title_list.append(item.find('td',class_='cont').find('a').get_text())
        ict_url_list.append(ict_base_url + item.find('td',class_='cont').find('a')['href'][-7:-3] + ict_sub_url)
        ict_date_list.append(item.find_all('td')[2].get_text())


# In[10]:


# 공지표시 되어있는 게시글 제목도 수집? (겹치는 내용임)
cse_title_list = []
cse_date_list = []
cse_url_list = []

csenotice_url = "http://cse.cau.ac.kr/20141201/sub05/sub0501.php"
csenotice_page = urlopen(csenotice_url)
csenotice_soup = BeautifulSoup(csenotice_page, "lxml")

csenotice_list = csenotice_soup.find('table',class_='nlist').find_all('tr')
csenotice_list.reverse()

if csenotice_list == []:
    print("No data")
else:
    for item in csenotice_list:
        if item.find('td').get_text() != '':
            cse_title_list.append(re.sub('[\n\t\xa0]','',item.find('a').get_text())) # sub메소드 사용법 검토하기
            cse_url_list.append(csenotice_url + item.find_all('td')[2].find('a')['href'])
            cse_date_list.append(item.find_all('td')[4].get_text())


# In[15]:


# Firebase에 크롤링한 데이터 저장하기
import json
from collections import OrderedDict

crawling_data = OrderedDict()

crawling_data['caunotice'] = {'title':cau_title_list, 'date':cau_date_list, 'url':cau_url_list}
crawling_data['library'] = {'title':lib_title_list, 'date':lib_date_list, 'url':"https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20"}
crawling_data['dorm'] = {'title':dorm_title_list, 'date':dorm_date_list, 'url':dorm_url_list}
crawling_data['ict'] = {'title':ict_title_list, 'date':ict_date_list, 'url':ict_url_list}
crawling_data['cse'] = {'title':cse_title_list, 'date':cse_date_list, 'url':cse_url_list}

crawling_json = json.dumps(crawling_data, ensure_ascii=False, indent="\t")
webpage_ref = ref.child('webpages')
webpage_ref.set(json.loads(crawling_json))
