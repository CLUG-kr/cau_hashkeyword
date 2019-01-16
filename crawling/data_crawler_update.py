
# coding: utf-8

# In[1]:


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


# In[2]:


from bs4 import BeautifulSoup
from urllib.request import urlopen
from selenium import webdriver
import re


# In[3]:


options = webdriver.ChromeOptions()
options.add_argument('headless')
options.add_argument('window-size=1920x1080')
options.add_argument('disable-gpu')


# In[4]:


# 추가된 게시글을 하나하나 update 하는 version1 (현재사용:x)
import time
start_time = time.time()

ref = db.reference('server/saving-data/crawling/webpages/caunotice/url')
cau_db_url = ref.get() # 다 가져오면 무리 아닐까. 만약 최신 게시글의 index가 더 빠르면 0으로 체크하면 돼서 필요x

new_cau_title_list = []
new_cau_date_list = []
new_cau_url_list = []

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://www.cau.ac.kr/cms/FR_CON/index.do?MENU_ID=100")
driver.implicitly_wait(3)

cau_base_url = "https://www.cau.ac.kr/cms/FR_CON/BoardView.do?MENU_ID=100&CONTENTS_NO=1&SITE_NO=2&P_TAB_NO=&TAB_NO=&BOARD_SEQ=4&BOARD_CATEGORY_NO=&BBS_SEQ="
# BBS_SEQ=19642 (id=board_19642)

ref = db.reference('server/saving-data/crawling/webpages/caunotice')
title_ref = ref.child('title')
date_ref = ref.child('date')
url_ref = ref.child('url')

length = len(cau_db_url)

board_list = driver.find_element_by_id("tbody").find_elements_by_tag_name("li")
for item in board_list:
    if cau_db_url[length - 1] == cau_base_url + item.get_attribute("id").replace("board_",""): break
    new_cau_title_list.insert(0, item.find_element_by_class_name("txtL").find_element_by_tag_name('a').text)
    new_cau_date_list.insert(0, item.find_element_by_class_name("txtInfo").find_element_by_class_name("date").text)
    new_cau_url_list.insert(0, cau_base_url + item.get_attribute("id").replace("board_",""))

for index in range(len(new_cau_title_list)):
    cau_data = OrderedDict()

    cau_data[length + index] = new_cau_title_list[index]
    cau_json = json.dumps(cau_data, ensure_ascii=False, indent="\t")
    title_ref.update(json.loads(cau_json))

    cau_data[length + index] = new_cau_date_list[index]
    cau_json = json.dumps(cau_data, ensure_ascii=False, indent="\t")
    date_ref.update(json.loads(cau_json))

    cau_data[length + index] = new_cau_url_list[index]
    cau_json = json.dumps(cau_data, ensure_ascii=False, indent="\t")
    url_ref.update(json.loads(cau_json))

print("--- %s seconds ---" %(time.time() - start_time))

driver.close()


# In[5]:


# 모든 데이터를 한꺼번에 다시 update 하는 version2 (현재사용:o)
# version1과 성능 및 효율성 비교해보기

# 나중에 불러오는 것이 많아질 수록 느려질 것?
ref = db.reference('server/saving-data/crawling/webpages/caunotice')
cau_title_list = ref.child('title').get()
cau_date_list = ref.child('date').get()
cau_url_list = ref.child('url').get()

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://www.cau.ac.kr/cms/FR_CON/index.do?MENU_ID=100")
driver.implicitly_wait(3)

cau_base_url = "https://www.cau.ac.kr/cms/FR_CON/BoardView.do?MENU_ID=100&CONTENTS_NO=1&SITE_NO=2&P_TAB_NO=&TAB_NO=&BOARD_SEQ=4&BOARD_CATEGORY_NO=&BBS_SEQ="
# BBS_SEQ=19642 (id=board_19642)

length = len(cau_url_list)

board_list = driver.find_element_by_id("tbody").find_elements_by_tag_name("li")
for item in board_list:
    if cau_url_list[length - 1] == cau_base_url + item.get_attribute("id").replace("board_",""): break
    cau_title_list.insert(length, item.find_element_by_class_name("txtL").find_element_by_tag_name('a').text)
    cau_date_list.insert(length, item.find_element_by_class_name("txtInfo").find_element_by_class_name("date").text)
    cau_url_list.insert(length, cau_base_url + item.get_attribute("id").replace("board_",""))

driver.close()


# In[6]:


ref = db.reference('server/saving-data/crawling/webpages/library')
lib_title_list = ref.child('title').get()
lib_date_list = ref.child('date').get()

driver = webdriver.Chrome("/usr/local/bin/chromedriver", chrome_options=options)
driver.get("https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20")
driver.implicitly_wait(3)

length = len(lib_title_list)
try:
    board_list = driver.find_elements_by_tag_name("tbody")[1].find_elements_by_class_name("ikc-item")
    for item in board_list:
        if lib_title_list[length - 1] == item.find_elements_by_tag_name("td")[2].find_element_by_tag_name('a').text: break
        lib_title_list.insert(length, item.find_elements_by_tag_name("td")[2].find_element_by_tag_name('a').text)
        lib_date_list.insert(length, item.find_elements_by_tag_name("td")[3].find_elements_by_tag_name("span")[1].text)
except IndexError:
    print("IndexError")
    pass

lib_base_url = "https://library.cau.ac.kr/#/bbs/notice/"
# 사이에 id 추가
lib_sub_url = "?offset=0&max=20"

# url id는 어떻게 가져올까..

driver.close()


# In[7]:


# 노란색 공지 부분만 가져온다
ref = db.reference('server/saving-data/crawling/webpages/dorm')
dorm_title_list = ref.child('title').get()
dorm_date_list = ref.child('date').get()
dorm_url_list = ref.child('url').get()

dormnotice_url = "https://dormitory.cau.ac.kr/bbs/bbs_list.php?bbsID=notice"
dormnotice_page = urlopen(dormnotice_url)
dormnotice_soup = BeautifulSoup(dormnotice_page, "lxml")

dormnotice_list = dormnotice_soup.find(id='content').find('div').find_all('tr',{'bgcolor':'#fffcdb'})

length = len(dorm_url_list)
if dormnotice_list == []:
    print("No data")
else :
    # url로 비교하기.
    for item in dormnotice_list:
        if dorm_url_list[length - 1] == item.find('a')['href']: break
        dorm_title_list.insert(length, item.find('span',class_='bbsTitle').get_text())
        dorm_date_list.insert(length, "20" + item.find_all('td',class_='t_c')[3].get_text())
        dorm_url_list.insert(length, item.find('a')['href'])


# In[8]:


ref = db.reference('server/saving-data/crawling/webpages/ict')
ict_title_list = ref.child('title').get()
ict_date_list = ref.child('date').get()
ict_url_list = ref.child('url').get()

ictnotice_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php"
ictnotice_page = urlopen(ictnotice_url)
ictnotice_soup = BeautifulSoup(ictnotice_page, "lxml")

ict_base_url = "http://ict.cau.ac.kr/20150610/sub05/sub05_01_list.php?cmd=view&cpage=1&idx="
# 사이에 id 작성
ict_sub_url = "&search_gbn=1&search_keyword="

ictnotice_list = ictnotice_soup.find('tbody').find_all('tr')
length = len(ict_url_list)

if ictnotice_list == []:
    print("No data")
else:
    for item in ictnotice_list:
        if ict_url_list[length - 1] == ict_base_url + item.find('td',class_='cont').find('a')['href'][-7:-3] + ict_sub_url: break
        ict_title_list.insert(length, item.find('td',class_='cont').find('a').get_text())
        ict_date_list.insert(length, item.find_all('td')[2].get_text())
        ict_url_list.insert(length, ict_base_url + item.find('td',class_='cont').find('a')['href'][-7:-3] + ict_sub_url)


# In[9]:


ref = db.reference('server/saving-data/crawling/webpages/cse')
cse_title_list = ref.child('title').get()
cse_date_list = ref.child('date').get()
cse_url_list = ref.child('url').get()

csenotice_url = "http://cse.cau.ac.kr/20141201/sub05/sub0501.php"
csenotice_page = urlopen(csenotice_url)
csenotice_soup = BeautifulSoup(csenotice_page, "lxml")

csenotice_list = csenotice_soup.find('table',class_='nlist').find_all('tr')

length = len(cse_url_list)
if csenotice_list == []:
    print("No data")
else:
    for item in csenotice_list:
        if cse_url_list[length - 1] == csenotice_url + item.find_all('td')[2].find('a')['href']: break
        # 근데 cse 페이지는 특이사항이라서, 파란 공지 부분을 비교하면 안될텐데..
        cse_title_list.insert(length, re.sub('[\n\t\xa0]','',item.find('a').get_text()))
        cse_date_list.insert(length, item.find_all('td')[4].get_text())
        cse_url_list.insert(length, csenotice_url + item.find_all('td')[2].find('a')['href'])


# In[10]:


# Firebase에 새로 추가된 게시물 업데이트
import json
from collections import OrderedDict

new_crawling_data = OrderedDict()

new_crawling_data['caunotice'] = {'title':cau_title_list, 'date':cau_date_list, 'url':cau_url_list}
new_crawling_data['library'] = {'title':lib_title_list, 'date':lib_date_list, 'url':"https://library.cau.ac.kr/#/bbs/notice?offset=0&max=20"}
new_crawling_data['dorm'] = {'title':dorm_title_list, 'date':dorm_date_list, 'url':dorm_url_list}
new_crawling_data['ict'] = {'title':ict_title_list, 'date':ict_date_list, 'url':ict_url_list}
new_crawling_data['cse'] = {'title':cse_title_list, 'date':cse_date_list, 'url':cse_url_list}

new_crawling_json = json.dumps(new_crawling_data, ensure_ascii=False, indent="\t")
webpage_ref = ref.child('webpages')
webpage_ref.set(json.loads(new_crawling_json))
