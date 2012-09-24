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
	* QiwiPost при запросах нахождения постоматов не проверяет телефон/пароль на правильность
	* get_all_packages выдает 100 позиций(???)
	* Получение информации о наложенных платежах выдает не те данные о которых говориться в документации
		пример:
		
		    <payment>
		        <boxmachinename>MSC_008</boxmachinename>
		        <comissionforcod>0.00</comissionforcod>
		        <dateofparceldelivered>2012-09-17 13:55:17</dateofparceldelivered>
		        <id>6154546</id>
		        <parcelbarcode>11755600070420</parcelbarcode>
		        <pricefordelivery>111.00</pricefordelivery>
		        <receivedcod>0</receivedcod>
		    </payment>

	* change_customer_ref	должен по документации возвращать pdf файл, но на самом деле этого не делает


