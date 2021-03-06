&НаСервере 
Перем ЭтотОтчет;


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Конвертация параметров формы в значения ДропРеквизитов формы
	Обработки.ПомощникЗаполнения3НДФЛ.ЗаполнитьДопРеквизитыФормыДокументаПомощника(ЭтотОбъект);
	Параметры.Свойство("Декларация3НДФЛВыбраннаяФорма", Декларация3НДФЛВыбраннаяФорма);
	
	// Подготовка реквизитов формы
	Элементы.СтавкаНалога.СписокВыбора.Очистить(); 
	Для каждого ЭлементСписка Из ДопРеквизитыФормы.СписокСтавокНалога Цикл
		Элементы.СтавкаНалога.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
	КонецЦикла;
	
	// Чтение структуры документа
	СтрукураДокументаНаСервере = Обработки.ПомощникЗаполнения3НДФЛ.СтруктураДокументаСТаблицамиИзХранилищ(ДопРеквизитыФормы.СтруктураДокумента);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрукураДокументаНаСервере, , "Строки2НДФЛ,Вычеты2НДФЛ");
	ДопРеквизитыФормы.Вставить("ПрежняяСтавкаНалога", СтавкаНалога);
	Строки2НДФЛ.Загрузить(СтрукураДокументаНаСервере.Строки2НДФЛ);
	Вычеты2НДФЛ.Загрузить(СтрукураДокументаНаСервере.Вычеты2НДФЛ);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДопРеквизитыФормы.СписокОшибок <> Неопределено Тогда
		// Если форма открывается из списка собщений помощника заполнения, в параметрах будет передан массив "СписокОшибок"
		ПоказатьСписокОшибок(ДопРеквизитыФормы.СписокОшибок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		#Область ПоказатьВопрос
		ТекстВопроса = НСтр("ru='Записать изменения перед закрытием этой формы?'");
		
		ДополнительныеПараметры = Новый Структура;
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Закрыть без записи'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отменить закрытие'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, Заголовок);
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаПриИзменении(Элемент)
	
	Если СтавкаНалога = ДопРеквизитыФормы.ПрежняяСтавкаНалога Тогда
		Возврат;
	КонецЕсли;
	
	ДопРеквизитыФормы.ПрежняяСтавкаНалога = СтавкаНалога;
	
	Если Строки2НДФЛ.Количество() = 0 И Вычеты2НДФЛ.Количество() = 0 Тогда
		УправлениеФормой(ЭтотОбъект);
	Иначе
		ТекстВопроса = НСтр("ru='После изменения ставки разделы 3 и 4 будут очищены.
				|Изменить ставку налога?'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Оповещение = Новый ОписаниеОповещения("СтавкаНалогаПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru='Справка 2-НДФЛ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())); 
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяБазаПриИзменении(Элемент)
	СуммаВычета = Макс(0, СуммаДохода - СуммаДоходаОблагаемая);
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_Строки2НДФЛ

&НаКлиенте
Процедура Строки2НДФЛПриИзменении(Элемент)
	ПересчитатьИтоги(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Строки2НДФЛПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ДанныеСтроки = Элементы.Строки2НДФЛ.ТекущиеДанные;
	
	Если НоваяСтрока Тогда
		
		МаксМесяц = 0;
		Для каждого СтрокаСправки Из Строки2НДФЛ Цикл
			Если СтрокаСправки.Месяц > МаксМесяц Тогда
				МаксМесяц = СтрокаСправки.Месяц;
			КонецЕсли;
		КонецЦикла;
		
		ДанныеСтроки.Месяц = ?(МаксМесяц < 12, МаксМесяц + 1, МаксМесяц);
		
		Если НЕ Копирование Тогда
			
			Если СтавкаНалога = 13 ИЛИ СтавкаНалога = 30 Тогда
				ДанныеСтроки.КодДохода = "2000";
			ИначеЕсли СтавкаНалога = 35 Тогда
				ДанныеСтроки.КодДохода = "3020";
			ИначеЕсли СтавкаНалога = 9 ИЛИ СтавкаНалога = 15 Тогда
				ДанныеСтроки.КодДохода = "1010";
				Если СтавкаНалога = 9 Тогда
					ДанныеСтроки.КодыВычетов = "601";
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Вычеты2НДФЛ

&НаКлиенте
Процедура Вычеты2НДФЛПриИзменении(Элемент)
	ПересчитатьИтоги(ЭтотОбъект);
КонецПроцедуры

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
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	
	Элементы.КПП.АвтоотметкаНезаполненного = НЕ ПустаяСтрока(Форма.ИНН) И СтрДлина(Форма.ИНН) < 12; 

КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Вычеты2НДФЛ.Очистить();
		Строки2НДФЛ.Очистить();
		УправлениеФормой(ЭтотОбъект);
		
	Иначе
		
		СтавкаНалога = ДопРеквизитыФормы.ПрежняяСтавкаНалога;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура ПересчитатьИтоги(Форма)

	Форма.СуммаДохода            = Форма.Строки2НДФЛ.Итог("СуммаДохода");
	СуммаВычета                  = Форма.Строки2НДФЛ.Итог("СуммаВычета") + Форма.Вычеты2НДФЛ.Итог("СуммаВычета");
	Форма.СуммаДоходаОблагаемая  = Макс(0, Форма.СуммаДохода - СуммаВычета);
	Форма.СуммаНалогаНачисленая  = Окр(Форма.СуммаДоходаОблагаемая * Форма.СтавкаНалога / 100, 0);
	Форма.СуммаНалогаУдержанная  = Форма.СуммаНалогаНачисленая;

КонецПроцедуры


///////////////////////////////////////////////////////
// Проверка и запись документа

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьДокументКлиент();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокументКлиент()

	РезультатПроверки = РезультатПроверкиДокумента();
	
	Если РезультатПроверки.БезОшибок Тогда
		Модифицированность = Ложь;
		ВернутьРезультатВПомощник(РезультатПроверки.РезультатДляВозврата);
	Иначе
		
		ПоказатьСписокОшибок(РезультатПроверки.СписокОшибок);
		
		#Область ПоказатьВопрос
		ТекстВопроса = НСтр("ru='В документе обнаружены ошибки. Записать документ в текущем состоянии?'");
		
		ДополнительныеПараметры = Новый Структура("РезультатПроверки", РезультатПроверки);
		Оповещение = Новый ОписаниеОповещения("ЗаписатьДокументКлиентЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать с ошибками'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Исправить ошибки'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Закрыть не записывая'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, Заголовок);
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСписокОшибок(СписокОшибок)

	ОчиститьСообщения();
	Для каждого Ошибка Из СписокОшибок Цикл
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст  = Ошибка.ОписаниеОшибки;
		Сообщение.Поле   = Ошибка.ИмяРеквизита;
		Сообщение.Сообщить(); 
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция РезультатДляЗаписи()

	СтруктураДокумента = ДопРеквизитыФормы.СтруктураДокумента;
	ЗаполнитьЗначенияСвойств(СтруктураДокумента, ЭтотОбъект);
	СтруктураДокумента.Вставить("Строки2НДФЛ", Новый ХранилищеЗначения(Строки2НДФЛ.Выгрузить()));
	СтруктураДокумента.Вставить("Вычеты2НДФЛ", Новый ХранилищеЗначения(Вычеты2НДФЛ.Выгрузить()));
	СтруктураДокумента.Вставить("СуммаВычета", Строки2НДФЛ.Итог("СуммаВычета") + Вычеты2НДФЛ.Итог("СуммаВычета"));
	
	СтруктураДокумента.Вставить("ВидДохода", 3); // иное
	
	КодыВидовДоходовРФ = Неопределено;
	СтруктураДокумента.Вставить("КодВидаДохода", Отчеты.РегламентированныйОтчет3НДФЛ.КодВидаДоходаПоСправке2НДФЛ(
					Декларация3НДФЛВыбраннаяФорма, СтруктураДокумента, Строки2НДФЛ, КодыВидовДоходовРФ));
	
	Если СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаНедвижимости
		Или СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаНедвижимостиПоКадастровойСтоимости
		Или СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаНежилойНедвижимости
		Или СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаНежилойНедвижимостиПоКадастровойСтоимости
		Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.ПродажаНедвижимости);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаИмущества
		Или СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ПродажаТранспортныхСредств Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.ПродажаИмущества);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ОперацииСЦеннымиБумагами Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.ОперацииСЦеннымиБумагами);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.СдачаИмуществаВАренду Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.СдачаИмуществаВАренду);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.Подарок Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.Подарок);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ОплатаТруда
			Или СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.ОплатаТрудаНалогНеУдержанАгентом Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.ОплатаТруда);
	ИначеЕсли СтруктураДокумента.КодВидаДохода = КодыВидовДоходовРФ.Дивиденды Тогда
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.Дивиденды);
		СтруктураДокумента.ВидДохода = 2;
	Иначе
		СтруктураДокумента.Вставить("ИсточникиДоходов", Перечисления.ИсточникиДоходовФизическихЛиц.ИнойДоходОтИсточникаРФ);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВидДокумента", ДопРеквизитыФормы.ВидДокумента);
	Результат.Вставить("СтавкаНалога", СтавкаНалога);
	Результат.Вставить("Представление", СтрШаблон("2-НДФЛ ""%1""", Наименование));
	Результат.Вставить("СтруктураДокумента", СтруктураДокумента);
	Результат.Вставить("СуммаДохода", СуммаДохода);
	Результат.Вставить("СуммаВычета", СтруктураДокумента.СуммаВычета);

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатПроверкиДокумента()

	Результат = Новый Структура();
	Результат.Вставить("РезультатДляВозврата", РезультатДляЗаписи());
	
	Результат.Вставить("СписокОшибок", Новый Массив);
	Результат.Вставить("БезОшибок", Обработки.ПомощникЗаполнения3НДФЛ.ДокументНеСодержитОшибок(
			ДопРеквизитыФормы.ВидДокумента, ДопРеквизитыФормы.ГодОтчета, Результат.РезультатДляВозврата.СтруктураДокумента, Результат.СписокОшибок, Неопределено));
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЗаписатьДокументКлиентЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		ВернутьРезультатВПомощник(ДополнительныеПараметры.РезультатПроверки.РезультатДляВозврата);
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВернутьРезультатВПомощник(Результат = Неопределено)

	Если Результат = Неопределено Тогда
		Результат = РезультатДляЗаписи();
	КонецЕсли;
	
	Закрыть(Результат);

КонецПроцедуры




#КонецОбласти



