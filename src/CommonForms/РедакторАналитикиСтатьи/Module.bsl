
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Статья", Статья);
	Параметры.Свойство("ПакетАналитики", ПакетАналитики);
	Если НЕ ЗначениеЗаполнено(Статья) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Аналитика статьи «%1»'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, Статья);
	
	// Разворачиваем пакет аналитики
	Для каждого СтрокаПакета Из ПакетАналитики.ВидыИЗначенияАналитики Цикл
		НоваяСтрока = ВидыИЗначенияАналитики.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПакета);
	КонецЦикла;
	
	// Дополним расширенной аналитикой для статьи
	Отбор = Новый Структура("ВидАналитики");
	РасширеннаяАналитикаСтатьи = АналитикаСтатей.ПолучитьРасширеннуюАналитикуДляСтатьи(Статья);
	Для каждого СтрокаРасширеннойАналитикиСтатьи Из РасширеннаяАналитикаСтатьи Цикл
		Отбор.ВидАналитики = СтрокаРасширеннойАналитикиСтатьи.ВидАналитики;
		Если ВидыИЗначенияАналитики.НайтиСтроки(Отбор).Количество() = 0 Тогда
			НоваяСтрока = ВидыИЗначенияАналитики.Добавить();
			НоваяСтрока.ВидАналитики      = СтрокаРасширеннойАналитикиСтатьи.ВидАналитики;
		КонецЕсли;
	КонецЦикла;
	
	ВидыИЗначенияАналитики.Сортировать("ВидАналитики");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	// Проверим ВидыИЗначенияАналитики
	ЕстьОшибки = Ложь;
	
	// Не должно быть одинаковых видов аналитики
	Отбор = Новый Структура("ВидАналитики");
	Для каждого Строка Из ВидыИЗначенияАналитики Цикл
		Отбор.ВидАналитики = Строка.ВидАналитики;
		Если ВидыИЗначенияАналитики.НайтиСтроки(Отбор).Количество() > 1 Тогда
			ЕстьОшибки = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Нельзя использовать один и тот же вид аналитики дважды'"), ,
				"ВидыИЗначенияАналитики[" + ВидыИЗначенияАналитики.Индекс(Строка) + "].ВидАналитики");
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьОшибки Тогда
		Закрыть(ПолучитьСсылкуНаНаборЗначенийАналитик());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуНаНаборЗначенийАналитик()
	
	// Важно. Таблица ВидыИЗначенияАналитики не должна быть пустой, 
	// и в ней не должно быть строк с пустым значением в поле ЗначениеАналитики
	
	// Удалим строки с пустыми значениями
	МассивСтрокДляУдаления = Новый Массив;
	Для каждого Строка Из ВидыИЗначенияАналитики Цикл
		Если Не ЗначениеЗаполнено(Строка.ЗначениеАналитики) Тогда
			МассивСтрокДляУдаления.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	Для каждого Строка Из МассивСтрокДляУдаления Цикл
		ВидыИЗначенияАналитики.Удалить(Строка);
	КонецЦикла;
	
	Если ВидыИЗначенияАналитики.Количество() > 0 Тогда
		Возврат АналитикаСтатей.ПолучитьСсылкуНаНаборЗначенийАналитик(ВидыИЗначенияАналитики);
	Иначе
		Возврат Справочники.ЗначенияСубконтоАналитика.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
