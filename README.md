# Company register

[![Build Status](https://travis-ci.org/internetee/company_register.svg?branch=master)](https://travis-ci.org/internetee/company_register)
[![Maintainability](https://qlty.sh/gh/internetee/projects/company_register/maintainability.svg)](https://qlty.sh/gh/internetee/projects/company_register)
[![Code Coverage](https://qlty.sh/gh/internetee/projects/company_register/coverage.svg)](https://qlty.sh/gh/internetee/projects/company_register)


A Ruby interface to the Estonian company register (Äriregister) API.

How to use in test purposes:
```
CompanyRegister.configure do |config|
  config.username ='username'
  config.password ='password'
  config.test_mode = false
end

c = CompanyRegister::Client.new
c.simple_data(registration_number: '666')
```


```

Currently only implements #7 "Rights of representation of all persons related to the company" from
v6 (https://www.rik.ee/sites/www.rik.ee/files/elfinder/article_files/xml_descriptionv6_eng.pdf).

Check [the official API specification of Äriregister](https://www.rik.ee/en/e-business-registry/xml-service) 
for details.
