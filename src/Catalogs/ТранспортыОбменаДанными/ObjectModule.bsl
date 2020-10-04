#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

// Возвращает значение из табличной части ПараметрыТранспорта для указанного имени
Функция ЗначениеПараметраТранспорта(ИмяПараметра) Экспорт

	СтрокаЗначения = ПараметрыТранспорта.НайтиСтроки(Новый Структура("ИмяПараметра", ИмяПараметра));
	Если СтрокаЗначения.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат ?(ЗначениеЗаполнено(СтрокаЗначения[0].ЗначениеДлиннойСтрокой), СтрокаЗначения[0].ЗначениеДлиннойСтрокой, СтрокаЗначения[0].ЗначениеПараметра);
	КонецЕсли; 

КонецФункции
 
//ПроцедураВозвращает значение из табличной части ПараметрыТранспорта для указанного имени
Процедура УстановитьЗначениеПараметраТранспорта(ИмяПараметра, ЗначениеПараметра) Экспорт

	СтрокиЗначения = ПараметрыТранспорта.НайтиСтроки(Новый Структура("ИмяПараметра", ИмяПараметра));
	Если СтрокиЗначения.Количество() = 0 Тогда
		СтрокаЗначения = ПараметрыТранспорта.Добавить();
	Иначе
		СтрокаЗначения = СтрокиЗначения[0];
	КонецЕсли; 

	СтрокаЗначения.ИмяПараметра       = ИмяПараметра;
	СтрокаЗначения.ЗначениеПараметра  = ЗначениеПараметра;
	Если СтрДлина(ЗначениеПараметра) > 255 Тогда
		СтрокаЗначения.ЗначениеДлиннойСтрокой = Строка(ЗначениеПараметра);
	Иначе
		СтрокаЗначения.ЗначениеДлиннойСтрокой = "";
	КонецЕсли; 
	
КонецПроцедуры
 

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ОбщегоНазначенияДеньги.ЗаполнитьОбъектПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM Тогда
		ЗаполнитьПараметрыТранспортаCOM();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		ЗаполнитьПараметрыТранспортаFILE();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		ЗаполнитьПараметрыТранспортаFTP();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		ЗаполнитьПараметрыТранспортаWS();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.ЯндексДиск Тогда
		ЗаполнитьПараметрыТранспортаЯндексДиск();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL Тогда
		ЗаполнитьПараметрыТранспортаEmail();
	ИначеЕсли ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.Dropbox Тогда
		ЗаполнитьПараметрыТранспортаDropBox();		
	КонецЕсли; 
	
	Наименование = Строка(ВидТранспорта);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Справочники.ТранспортыОбменаДанными.ОбновитьСостояниеСценария(Ссылка, ПометкаУдаления, Отказ);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПараметрыТранспортаCOM()

	ПараметрыТранспорта.Очистить();
	СтрокаПараметра("COMАутентификацияОперационнойСистемы", Ложь);
	СтрокаПараметра("COMВариантРаботыИнформационнойБазы", 1);
	СтрокаПараметра("COMИмяИнформационнойБазыНаСервере1СПредприятия", "");
	СтрокаПараметра("COMИмяСервера1СПредприятия", "");
	СтрокаПараметра("COMКаталогИнформационнойБазы", "");

КонецПроцедуры

Процедура ЗаполнитьПараметрыТранспортаFILE()

	ПараметрыТранспорта.Очистить();
	СтрокаПараметра("FILEКаталогОбменаИнформацией", "");

КонецПроцедуры

Процедура ЗаполнитьПараметрыТранспортаFTP()

	ПараметрыТранспорта.Очистить();
	СтрокаПараметра("FTPСоединениеПассивноеСоединение", Ложь);
	СтрокаПараметра("FTPСоединениеПорт", "");
	СтрокаПараметра("FTPСоединениеПуть", "");

КонецПроцедуры

Процедура ЗаполнитьПараметрыТранспортаWS()

	ПараметрыТранспорта.Очистить();
	СтрокаПараметра("WSURLВебСервиса", "");
	СтрокаПараметра("WSИспользоватьПередачуБольшогоОбъемаДанных", Истина);

КонецПроцедуры

Процедура ЗаполнитьПараметрыТранспортаЯндексДиск()

	ПараметрыТранспорта.Очистить();
	СтрокаПараметра("ЯндексДискКаталогОбменаИнформацией", "");

КонецПроцедуры

Процедура ЗаполнитьПараметрыТранспортаDropBox()

	ПараметрыТранспорта.Очистить();

КонецПроцедуры


Процедура ЗаполнитьПараметрыТранспортаEmail()

	ПараметрыТранспорта.Очистить();

КонецПроцедуры

Функция СтрокаПараметра(ИмяПараметра, ЗначениеПараметра)

	НоваяСтрока = ПараметрыТранспорта.Добавить();
	НоваяСтрока.ИмяПараметра      = ИмяПараметра;
	НоваяСтрока.ЗначениеПараметра = ЗначениеПараметра;
	
	Возврат НоваяСтрока;

КонецФункции
 

#КонецОбласти


#КонецЕсли


