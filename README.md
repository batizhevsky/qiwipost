# QiwiPost api

## Описание
Ruby API для (qiwipost.ru)

## Использование

* Обычный режим

	qiwipost = QiwiPost.new(number: 9876543210, password: 'test')

* Тестовый режит

	qiwipost = QiwiPost.new(number: 9876543210, password: 'test', test: true)
