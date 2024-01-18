import telebot
from telebot import types 
from selenium import webdriver
from selenium.webdriver.common.by import By
import time 

def text_convert(key, group):
    global global_time1, global_time2
    global dict1, dict2
    if group == 1:
        if time.time() - global_time1 > 60*60*3:
            dict1 = parser()
    else:
        if time.time() - global_time2 > 60*60*3:
            dict2 = parser()

    if group == 1:
        for keys in dict1:
            key -= 1
            if key == -1:
                key = keys
                break

        text = key + ' '
        for i in range(len(dict1[key])):
            for z in range(len(dict1[key][i])):
                text += f'\n{str(dict1[key][i][z])}'

        return text if (len(text) - len(key) - 1) != 0 else f'{key} \nYou are free'
    else:
        for keys in dict2:
            key -= 1
            if key == -1:
                key = keys
                break

        text = key + ' '
        for i in range(len(dict2[key])):
            for z in range(len(dict2[key][i])):
                text += f'\n{str(dict2[key][i][z])}'

        return text if (len(text) - len(key) - 1) != 0 else f'{key} \nYou are free'


def parser():
    
    url = 'https://raspisanie.rusoil.net/?page=schedule&search=%7B%22value%22%3A%22%D0%91%D0%93%D0%91-22-02%22%2C%22id%22%3A103480%2C%22FILIAL%22%3A1%2C%22GRUPPA%22%3A%22%D0%91%D0%93%D0%91-22-02%22%2C%22BELLFAK%22%3A1%2C%22FOB%22%3A1%7D'
    driver = webdriver.Firefox()

    driver.get(url=url)
    time.sleep(2)

    temp = []
    dict = {}

    lessons = driver.find_elements(By.CLASS_NAME, "flex-col")
    for i in range(0, len(lessons), 2):
        try:
            date = lessons[i].find_element(By.CLASS_NAME, 'sticky').text
            try:
                main_info = lessons[i].find_elements(By.CLASS_NAME, 'select-text')
                for z in range(len(main_info)):
                    temp1 = main_info[z].text.split('\n')
                    temp.append(temp1)
                dict[date] = temp
                temp = []

            except Exception:
                dict[date] = ["You're free today"]
                temp = []


        except Exception:
            pass
    
    return dict

def parser_new():
    url = 'https://raspisanie.rusoil.net/?page=schedule&search=%7B%22value%22%3A%22%D0%91%D0%9D%D0%9F-23-01%22%2C%22id%22%3A110684%2C%22FILIAL%22%3A1%2C%22GRUPPA%22%3A%22%D0%91%D0%9D%D0%9F-23-01%22%2C%22BELLFAK%22%3A1%2C%22FOB%22%3A1%7D'
    driver = webdriver.Firefox()

    driver.get(url=url)
    time.sleep(2)

    temp = []
    dict = {}

    lessons = driver.find_elements(By.CLASS_NAME, "flex-col")
    for i in range(0, len(lessons), 2):
        try:
            date = lessons[i].find_element(By.CLASS_NAME, 'sticky').text
            try:
                main_info = lessons[i].find_elements(By.CLASS_NAME, 'select-text')
                for z in range(len(main_info)):
                    temp1 = main_info[z].text.split('\n')
                    temp.append(temp1)
                dict[date] = temp
                temp = []

            except Exception:
                dict[date] = ["You're free today"]
                temp = []


        except Exception:
            pass
    

    return dict

dict1 = parser()
dict2 = parser_new()
global_time1 = time.time()
global_time2 = time.time()
print(dict2)




token = "5468277697:AAFs60Sej6AagSZwKIrRRUdUkilh2PANhy4"

bot = telebot.TeleBot(token)


@bot.message_handler(commands=["start"])
def button_message(message):
    bot.send_message(message.chat.id, 'q, выбери ниже')
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    item1 = types.KeyboardButton("Расписание БГБ-22-02")
    item2 = types.KeyboardButton("Расписание БНП-23-01")
    markup.add(item1)
    markup.add(item2)
    bot.send_message(message.chat.id, "Choose:", reply_markup=markup)




@bot.message_handler(content_types=['text'])
def meshand(message):
    if message.text == 'Расписание БГБ-22-02':
        markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
        item1 = types.KeyboardButton("Расписание на сегодня")
        item2 = types.KeyboardButton("Расписание на завтра")
        item3 = types.KeyboardButton("Расписание на послезавтра")
        markup.add(item1)
        markup.add(item2)
        markup.add(item3)
        bot.send_message(message.chat.id, "Choose:", reply_markup=markup)
    if message.text == "Расписание БНП-23-01":
        markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
        item1 = types.KeyboardButton("Расписание на сегoдня")
        item2 = types.KeyboardButton("Расписание на зaвтра")
        item3 = types.KeyboardButton("Расписание на пoслезавтра")
        markup.add(item1)
        markup.add(item2)
        markup.add(item3)
        bot.send_message(message.chat.id, "Choose:", reply_markup=markup)
    if message.text == "Расписание на сегoдня":
        text = text_convert(0,2)
        bot.send_message(message.chat.id, text)
    if message.text == "Расписание на зaвтра":
        text = text_convert(1,2)
        bot.send_message(message.chat.id, text)
    if message.text == "Расписание на пoслезавтра":
        text = text_convert(2,2)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на сегодня':
        text = text_convert(0,1)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на завтра':
        text = text_convert(1,1)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на послезавтра':
        text = text_convert(2,1)
        bot.send_message(message.chat.id, text)


bot.infinity_polling()
