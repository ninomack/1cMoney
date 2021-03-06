&НаСервере 
Перем ЭтотОтчет;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	КонтейнерДокумента = Параметры.СтрокаДокумента;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонтейнерДокумента, СтрокаСвойствКонтейнера());
	НалогоплательщикСтатус = Параметры.НалогоплательщикСтатус;
	ГодОтчета              = Параметры.ГодОтчета;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонтейнерДокумента.ШапкаДокумента, СтрокаСвойствШапкиДокумента());
	
	Если ТипЗнч(КонтейнерДокумента.ДоходыТоварищества) = Тип("СписокЗначений") Тогда
		Для каждого СтрокаТабЧасти Из КонтейнерДокумента.ДоходыТоварищества Цикл
			НоваяСтрока = ДоходыТоварищества.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабЧасти.Значение);
			УстановитьНаименованиеОперации(НоваяСтрока);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

 

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьДокументКлиент();

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСвойствКонтейнера()

	Возврат "СтавкаНалога,СуммаДохода,СуммаНалогаНачислено,
				|ИДДокумента,СуммаНалогаУдержано,СуммаВычета,ПредставлениеДокумента";

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСвойствШапкиДокумента()

	Возврат "ИсточникНаименование,ИсточникИНН,
				|ИсточникКПП,ИсточникОКАТО,
				|СуммаВкладаВТоварищество";

КонецФункции

&НаКлиенте
Процедура ЗаписатьДокументКлиент()

	ПредставлениеДокумента = НСтр("ru='Доход от инвест.товарищества'");
	Если ЗначениеЗаполнено(ИсточникНаименование) Тогда
		ПредставлениеДокумента = ПредставлениеДокумента + " " + ИсточникНаименование;
	КонецЕсли; 
	
	СуммаДохода = ДоходыТоварищества.Итог("СуммаДохода");
	СуммаВычета = ДоходыТоварищества.Итог("ДоляВРасходах") 
				+ ДоходыТоварищества.Итог("ВознаграждениеУправляющим") 
				+ ДоходыТоварищества.Итог("УбытокПрошлыхЛет")
				+ СуммаВкладаВТоварищество;
	
	Если НЕ ДанныеЗаполненыКорректно() Тогда
		ПоказатьВопросНаЗаписьСОшибками();
	Иначе
		ЗаписатьДокументЗавершение();
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура УстановитьНаименованиеОперации(СтрокаТаблицы)

	Если СтрокаТаблицы.КодДохода = "9911" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Операции с ценными бумагами, обращающимися на организованном рынке'");
	ИначеЕсли СтрокаТаблицы.КодДохода = "9912" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Операции с ценными бумагами, НЕ обращающимися на организованном рынке'");
	ИначеЕсли СтрокаТаблицы.КодДохода = "9913" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Операции с инструментами срочн. сделок, не обращающимися на организованном рынке'");
	ИначеЕсли СтрокаТаблицы.КодДохода = "9914" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Операции с долями участия в уставном капитале организаций'");
	ИначеЕсли СтрокаТаблицы.КодДохода = "9915" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Прочие операции, осуществляемые товариществом'");
	ИначеЕсли СтрокаТаблицы.КодДохода = "9916" Тогда
		СтрокаТаблицы.НаименованиеДохода = НСтр("ru='Доход, полученный при выходе из товарищества'");
	КонецЕсли;

КонецПроцедуры
 

// Проверка и запись изменений

&НаКлиенте
Процедура ЗаписатьДокументЗавершение()

	СтрокаСвойств = СтрокаСвойствКонтейнера();
	Результат = Новый Структура(СтрокаСвойств);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект, СтрокаСвойств);
	
	СтрокаСвойств = СтрокаСвойствШапкиДокумента();
	Результат.Вставить("ШапкаДокумента", Новый Структура(СтрокаСвойств));
	ЗаполнитьЗначенияСвойств(Результат.ШапкаДокумента, ЭтотОбъект, СтрокаСвойств);
	
	Результат.Вставить("ДоходыТоварищества", Новый СписокЗначений);
	Для каждого СтрокаТабЧасти Из ДоходыТоварищества Цикл
		СтруктураСтроки = Новый Структура("КодДохода,СуммаДохода,ДоляВРасходах,ВознаграждениеУправляющим,УбытокПрошлыхЛет");
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаТабЧасти);
		ЭлементСтроки = Результат.ДоходыТоварищества.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	Модифицированность = Ложь;
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Функция ДанныеЗаполненыКорректно()

	ОчиститьСообщения();
	
	КоллекцияОшибок = Неопределено;
	
	Если ЗначениеЗаполнено(ИсточникИНН) ИЛИ ЗначениеЗаполнено(ИсточникКПП) ИЛИ Найти(ИсточникНаименование, """") > 0 Тогда
		
		Если СтрДлина(ИсточникИНН) <> 10 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникИНН", 
					НСтр("ru = 'ИНН указан неверно (длина ИНН должна быть равной 10 символам)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		Если СтрДлина(ИсточникКПП) <> 9 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникКПП", 
					НСтр("ru = 'КПП указан неверно (длина КПП должна быть равной 9 символам)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ИсточникОКАТО) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникОКАТО", 
				НСтр("ru = 'Не указан код ОКТМО товарищества'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ИсточникНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникНаименование", 
				НСтр("ru = 'Не указано наименование инвестиционного товарищества'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 

	Если КоллекцияОшибок = Неопределено Тогда
		Возврат Истина;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КоллекцияОшибок, Ложь);
		Возврат Ложь;
	КонецЕсли; 
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВопросНаЗаписьСОшибками()

	ТекстВопроса = НСтр("ru = 'При проверке обнаружены ошибки, которые не позволят заполнить машиночитаемый бланк декларации.
		|Хотите записать информацию с ошибками, чтобы исправить их в будущем?'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить("Записать", НСтр("ru = 'Записать с ошибками'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	Кнопки.Добавить("Отмена", НСтр("ru = 'Исправить ошибки сейчас'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьВопросНаЗаписьСОшибкамиЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , "Отмена", НСтр("ru = 'Помощник заполнения 3-НДФЛ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())); 

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросНаЗаписьСОшибкамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = "Записать" Тогда
		ЗаписатьДокументЗавершение();
	КонецЕсли; 

КонецПроцедуры


#КонецОбласти


