#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтейнерДокумента = Параметры.СтрокаДокумента;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонтейнерДокумента, СтрокаСвойствКонтейнера());
	Если ВидДоговора = 0 Тогда
		ВидДоговора = 1;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы
 
&НаКлиенте
Процедура СуммаВзносаПриИзменении(Элемент)
	
	ПринимаетсяКВычету = СуммаВзноса;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринимаетсяКВычетуПриИзменении(Элемент)
	
	ПринимаетсяКВычету = Мин(ПринимаетсяКВычету, СуммаВзноса);
	
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
Функция СтрокаСвойствКонтейнера()

	Возврат "ИДЭлемента,Представление,СуммаВзноса,ИНН,КПП,НаименованиеОрганизации,
			|НомерДоговора,ДатаДоговора,ВычетУНалоговогоАгента,ПринимаетсяКВычету,ВидДоговора";

КонецФункции

&НаКлиенте
Процедура ЗаписатьДокументКлиент()

	Представление = "Договор №" + ?(ЗначениеЗаполнено(НомерДоговора), НомерДоговора, "???");
	Представление = Представление + " от " + ?(ЗначениеЗаполнено(ДатаДоговора), Формат(ДатаДоговора, "ДФ=дд.ММ.гг"), "???");
	Если ЗначениеЗаполнено(НаименованиеОрганизации) Тогда
		Представление = Представление + " (" + НаименованиеОрганизации + ")";
	КонецЕсли; 
	
	Если НЕ ДанныеЗаполненыКорректно() Тогда
		ПоказатьВопросНаЗаписьСОшибками();
	Иначе
		ЗаписатьДокументЗавершение();
	КонецЕсли; 
	
КонецПроцедуры

// Проверка и запись изменений

&НаКлиенте
Процедура ЗаписатьДокументЗавершение()

	СтрокаСвойств = СтрокаСвойствКонтейнера();
	Результат = Новый Структура(СтрокаСвойств);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект, СтрокаСвойств);
	
	Модифицированность = Ложь;
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Функция ДанныеЗаполненыКорректно()

	ОчиститьСообщения();
	
	КоллекцияОшибок = Неопределено;
	Если СтрДлина(ИНН) <> 10 Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИНН", 
				НСтр("ru = 'ИНН не заполнен или его длина менее 10 символов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если СтрДлина(КПП) <> 9 Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КПП", 
				НСтр("ru = 'КПП не заполнен или его длина менее 9 символов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если ПустаяСтрока(НаименованиеОрганизации) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "НаименованиеОрганизации", 
				НСтр("ru = 'Не указано наименование  пенсионного фонда или страховой организации'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ДатаДоговора) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ДатаДоговора", 
				НСтр("ru = 'Не указана дата договора'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если ПустаяСтрока(НомерДоговора) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "НомерДоговора", 
				НСтр("ru = 'Не указан номер договора'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если СуммаВзноса = 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаВзноса", 
				НСтр("ru = 'Не указана сумма взноса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
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


