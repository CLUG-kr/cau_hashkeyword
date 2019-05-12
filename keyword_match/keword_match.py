#!/usr/bin/env python
# coding: utf-8

# In[257]:


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db


# Fetch the service account key JSON file contents
cred = credentials.Certificate('/Users/Solomon/Desktop/cau-hashkeyword-serviceAccountKey.json')

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://cau-hashkeyword.firebaseio.com'
})


# In[258]:


from firebase_admin import db


# In[264]:


class Info_webpage:
    def setData(self, title, date, url):
        self.title = title
        self.date = date
        self.url = url
    def getData(self):
        self.dataSet = []
        for i in range(len(self.title)):
            self.dataSet.append((self.title[i], self.date[i], self.url[i]))
        return self.dataSet
    def getTitle(self):
        return self.title
    def getDate(self):
        return self.date
    def getUrl(self):
        return self.url


# In[265]:


class Info_user:
    def __init__(self):
        self.match = []
    def setData(self, user, keywords, selectedWebsite): # 나중에 uid 부분은 빼도 무방
        self.uid = user
        self.keywords = keywords
        self.selectedWebsite = selectedWebsite
    def setSelectedWebsite(self, selectedWebsite): # parsing한 웹페이지 이름 저장
        self.selectedWebsite = selectedWebsite
    def getUid(self):
        return self.uid
    def getKeywords(self):
        return self.keywords
    def getSelectedWebsite(self):
        return self.selectedWebsite
    def setPushData(self, matchKeyword, matchTitle, matchDate, matchURL):
        self.match.append((matchKeyword, matchTitle, matchDate, matchURL))
    def getPushData(self):
        return self.match
    def initPushData(self): # Push 알림을 보낸 후 초기화 과정
        self.match = []


# In[266]:


ref = db.reference('crawling/webpages')

dorm = Info_webpage()
ict = Info_webpage()

webpages = {'dormitory': dorm, 'ict': ict}

for (name, page) in webpages.items():
    page.setData(ref.child(name).child('title').get(),
                 ref.child(name).child('date').get(),
                 ref.child(name).child('url').get())


# In[267]:


ref = db.reference('users')

users = ref.get() # 유저의 uid 가져옴
# users_uid = ref.get().keys()
users_info = []

for user in users:
    infoUser = Info_user() # 객체를 유저 하나씩 만듬
    infoUser.setData(user,
                     ref.child(user).child('keywords').get(),
                     ref.child(user).child('selectedWebsite').get())
    user_parseSelectedWebsite = []
    for selected in infoUser.getSelectedWebsite():
        user_parseSelectedWebsite.append(selected.split('(')[1][:-1].split('.')[0])
    infoUser.setSelectedWebsite(user_parseSelectedWebsite)
    users_info.append(infoUser)


# In[269]:


result = []
# 4중 for문 최적화 요망 (추후 업데이트) - 물론 크롤링 주기를 짧게하면 title을 도는 부분이 적게 걸림
# 유저를 순차적으로 선택하며 해당 유저가 선택한 웹사이트에서 키워드를 공지사항의 제목과 비교

for user in users_info:
    for site in user.getSelectedWebsite():
        for keyword in user.getKeywords():
            for (title, date, url) in webpages[site].getData():
                if keyword in title:
                    user.setPushData(keyword, title, date, url)
    print(user.getUid())
    print(user.getPushData())


# In[ ]:


# ios Application에 push notification 전송


# In[ ]:


# user별로 push할 데이터를 담아둔 match 리스트 초기화 (match는 이번 실행에 보낼 데이터만을 저장해 둠)
# for user in users_info:
#     user.initPushData()

