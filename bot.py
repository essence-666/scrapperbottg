import telebot
from telebot import types 
from selenium import webdriver
from selenium.webdriver.common.by import By
import time 

def parser(key):
    url = 'https://raspisanie.rusoil.net/?page=schedule&search=%7B%22value%22%3A%22%D0%91%D0%93%D0%91-22-02%22%2C%22id%22%3A103480%2C%22FILIAL%22%3A1%2C%22GRUPPA%22%3A%22%D0%91%D0%93%D0%91-22-02%22%2C%22BELLFAK%22%3A1%2C%22FOB%22%3A1%7D'
    driver = webdriver.Chrome()

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
    

    for keys in dict:
        key -= 1
        if key == -1:
            key = keys
            break

    text = key + ' '
    for i in range(len(dict[key])):
        for z in range(len(dict[key][i])):
            text += f'\n{str(dict[key][i][z])}'

    driver.quit()
    return text if (len(text) - len(key) - 1) != 0 else f'{key} \nYou are free'


def parser_new(key):
    url = "link will be here"
    driver = webdriver.Chrome()

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
    

    for keys in dict:
        key -= 1
        if key == -1:
            key = keys
            break

    text = key + ' '
    for i in range(len(dict[key])):
        for z in range(len(dict[key][i])):
            text += f'\n{str(dict[key][i][z])}'

    driver.quit()
    return text if (len(text) - len(key) - 1) != 0 else f'{key} \nYou are free'


token = "{your token}"

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
        text = parser_new(0)
        bot.send_message(message.chat.id, text)
    if message.text == "Расписание на зaвтра":
        text = parser_new(1)
        bot.send_message(message.chat.id, text)
    if message.text == "Расписание на пoслезавтра":
        text = parser_new(2)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на сегодня':
        text = parser(0)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на завтра':
        text = parser(1)
        bot.send_message(message.chat.id, text)
    if message.text == 'Расписание на послезавтра':
        text = parser(2)
        bot.send_message(message.chat.id, text)


bot.infinity_polling()
