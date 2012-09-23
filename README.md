# QiwiPost api

## Описание
Ruby API для (qiwipost.ru)

## Использование

gem 'qiwipost', git: 'git://github.com/leonko/qiwipost.git'

* Обычный режим

	qiwipost = QiwiPost.new(number: 9876543210, password: 'test')

* Тестовый режим

	qiwipost = QiwiPost.new(number: 9876543210, password: 'test', test: true)

* Замечания
	QiwiPost при запросах нахождения постоматов не проверяет телефон/пароль на правильность
	get_all_packages выдает 100 позиций(???)

