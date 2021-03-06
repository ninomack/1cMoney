
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма              = ПараметрыВыполненияКоманды.Источник;
	ВыделенныеСтроки   = Форма.Элементы.Список.ВыделенныеСтроки;

	ВсегоСтрок        = ВыделенныеСтроки.Количество();
	Отказов           = 0;
	Счетчик           = 0;
	ОписаниеПроблемы  = "";
	ТекстСостояния    = НСтр("ru='Запись черновиков %1 из %2'"); 
	ТекстПояснения    = НСтр("ru='Отказов: %1'");
	КартинкаСостояния = БиблиотекаКартинок.Провести;
	
	Для каждого Ссылка Из ВыделенныеСтроки Цикл
		
		Счетчик = Счетчик + 1;
		Если Не ОбслуживаниеДокументовВызовСервера.ЗаписатьЧерновикПоСсылке(Ссылка, ОписаниеПроблемы) Тогда
			
			Отказов = Отказов + 1;
			Если ВсегоСтрок > 1 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеПроблемы, Ссылка);
			Иначе
				ПоказатьПредупреждение(, ОписаниеПроблемы);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВсегоСтрок > 1 Тогда
			Состояние(СтрШаблон(ТекстСостояния, Счетчик, ВсегоСтрок), 
						Счетчик/ВсегоСтрок * 100, 
						СтрШаблон(ТекстПояснения, Отказов), 
						КартинкаСостояния);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
