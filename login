#!/usr/bin/env python
# -*- coding: utf-8 -*-
import unittest
import time
import sys

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

class TestMusicPortal(unittest.TestCase):

    # setUp driver
    def setUp(self):
        
        print "Login Testing:setUp_:begin"
        
        self.driver = webdriver.Firefox()
        self.driver.get("https://testmusic.force.com/")
        
        testName = self.shortDescription()
        if (testName == "test_valid_Login"):
            print "setting up for test_valid_Login"
        else:
            print "setting up for test_invalid_Login"
        
        print "Login test:setUp_:end"
    
    # ending the test
    def tearDown(self):

        self.driver.close()

        print "Login test:tearDown_:begin"

        testName = self.shortDescription()
        if (testName == "test_valid_Login"):
            print "cleaning up for test_valid_Login"
        else:
            print "cleaning up for test_invalid_Login"

        print "Login test:tearDown_:end"

    # valid Login
    def test_valid_Login(self):
        driver = self.driver
        self.assertIn("Homepage of TestMusic", driver.title)

        signIn_bIn = driver.find_element_by_id('unauthenticated')
        signIn_bIn.click()
        time.sleep(5)
        
        logIn_bIn = driver.find_element_by_xpath("//*[@id='unauthenticated']/ul/li[1]/a")
        hover = ActionChains(driver).move_to_element(logIn_bIn)
        hover.perform()
        wait = WebDriverWait(driver, 10)
        
        # read username/password from file
        lines = open("validData.txt", "r").read() # data file format: <username>,<password>
        
        #print lines
        var_username = lines.split(",")[0]
        var_password = lines.split(",")[1]
        print "userName = "+ var_username + " , " + "passWord = "+var_password
        
        userName = wait.until(EC.element_to_be_clickable((By.ID,'emailField')))
        userName.send_keys(var_username)
        
        passWord = driver.find_element_by_id("passwordField")
        passWord.send_keys(x2)
        
        logIn_key = driver.find_element_by_id("send2Dsk")
        logIn_key.click()
        
        wait = WebDriverWait(driver, 10)
        
        userAccount = wait.until(EC.visibility_of_element_located((By.ID,'authenticated')))
        hover = ActionChains(driver).move_to_element(userAccount)
        hover.perform()
        
        myAccount = driver.find_element_by_xpath("//*[@id='authenticated']/ul/li[2]/a")
        myAccount.click()
        time.sleep(5)
        
        #wait = WebDriverWait(driver, 10)
        #myAccount = wait.until(EC.text_to_be_present_in_element((By.xpath,"//*[@id='join-conversation']/div[2]/div/div[2]/fieldset/div/div[3]/div[1]/div/p")))
        user_email = driver.find_element_by_xpath("//*[@id='join-conversation']/div[2]/div/div[2]/fieldset/div/div[3]/div[1]/div/p").text
        self.assertEqual("chenfei@testmusic.com", user_email)

    #invalid Login
    def test_invalid_Login(self):

        driver = self.driver
        #self.assertIn("TestMusic", driver.title)

        lines = open("invalidData.txt", "r").read()

        var_username = lines.split(",")[0]
        var_password = lines.split(",")[1]
        print "userName = "+ var_username + " , " + "passWord = "+var_password
        signIn_bIn = driver.find_element_by_id('unauthenticated')
        signIn_bIn.click()
        time.sleep(5)

        logIn_bIn = driver.find_element_by_xpath("//*[@id='unauthenticated']/ul/li[1]/a")
        hover = ActionChains(driver).move_to_element(logIn_bIn)
        hover.perform()
        wait = WebDriverWait(driver, 10)
        
        # read username/password from file
        userName = wait.until(EC.element_to_be_clickable((By.ID,'emailField')))
        userName.send_keys(var_username)
        
        passWord = driver.find_element_by_id("passwordField")
        passWord.send_keys(var_password)
        
        logIn_key = driver.find_element_by_id("send2Dsk")
        logIn_key.click()
        
        assert "Invalid username or password" in driver.page_source
        #assert "No results found." not in driver.page_source

if __name__ == "__main__":
    unittest.main()

