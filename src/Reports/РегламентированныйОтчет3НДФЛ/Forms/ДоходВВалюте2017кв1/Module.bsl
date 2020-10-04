&НаСервере 
Перем ЭтотОтчет;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаРубль = Справочники.Валюты.НайтиПоКоду("643");
	
	КонтейнерДокумента = Параметры.СтрокаДокумента;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонтейнерДокумента, СтрокаСвойствКонтейнера());
	НалогоплательщикСтатус = Параметры.НалогоплательщикСтатус;
	ГодОтчета              = Параметры.ГодОтчета;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонтейнерДокумента.ШапкаДокумента, СтрокаСвойствШапкиДокумента());
				
	ОбновитьТаблицыКодовДоходовИВычетов();
	
	Элементы.ГруппаКодСуммаВычета.Доступность = НЕ ПустаяСтрока(КодыВычетов);
	
	// Обновление курсов валюты
	Если ЗначениеЗаполнено(ДатаДохода) И ЗначениеЗаполнено(ВалютаДохода) Тогда
		
		Если НЕ ЗначениеЗаполнено(КурсНаДатуДохода) Тогда
			ОбновитьКурсыВалют("Доход");
			ПересчитатьРублевыеСуммы(ЭтотОбъект, "Доход");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(КурсНаДатуУплатыНалога) Тогда
			ОбновитьКурсыВалют("Налог");
			ПересчитатьРублевыеСуммы(ЭтотОбъект, "Налог");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьИностранныеКомпании(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура КодВидаДоходаПриИзменении(Элемент)
	ОбновитьИностранныеКомпании(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура ВалютаДоходаПриИзменении(Элемент)
	
	ОбновитьКурсыВалют();
	ПересчитатьРублевыеСуммы(ЭтотОбъект);
	
КонецПроцедуры
 
&НаКлиенте
Процедура ДатаДоходаПриИзменении(Элемент)
	
	ОбновитьКурсыВалют("Доход");
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Доход");
	
КонецПроцедуры

&НаКлиенте
Процедура КурсНаДатуДоходаПриИзменении(Элемент)
	
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Доход");
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаВВалютеПриИзменении(Элемент)
	
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Доход");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаУплатыНалогаПриИзменении(Элемент)
	
	ОбновитьКурсыВалют("Налог");
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Налог");
	
КонецПроцедуры

&НаКлиенте
Процедура КурсНаДатуУплатыНалогаПриИзменении(Элемент)
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Налог");
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогаУплаченоВВалютеПриИзменении(Элемент)
	ПересчитатьРублевыеСуммы(ЭтотОбъект, "Налог");
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогаУплаченоЗаГраницейПриИзменении(Элемент)
	
	Если СуммаНалогаПринимаетсяКЗачету > СуммаНалогаУплаченоЗаГраницей Тогда
		 СуммаНалогаПринимаетсяКЗачету = СуммаНалогаУплаченоЗаГраницей;
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура КодДоходаПриИзменении(Элемент)
	
	// Проверяем правильность кода
	Если ЗначениеЗаполнено(КодДохода) Тогда
		
		СтрокиКода = КодыДоходов.НайтиСтроки(Новый Структура("Код", КодДохода));
		Если СтрокиКода.Количество() = 0 Тогда
			
			КодВидаДохода = 2;
			СтавкаНалога = 0;
			НаименованиеДохода = "";
			КодВычета   = "";
			НаименованиеВычета = "";
			КодыВычетов = "";
			СуммаВычета = 0;
			Сообщить("Возможно, код дохода указан неверно");
			
		Иначе
			
			СтрокаКода = СтрокиКода[0];
			НаименованиеДохода = СтрокаКода.Наименование;
			КодыВычетов = СтрокаКода.КодыВычетов;
			Если ЗначениеЗаполнено(КодВычета) И Найти(КодыВычетов + ",", КодВычета + ",") = 0 Тогда
				КодВычета = "";
				НаименованиеВычета = "";
			КонецЕсли;
			
			Если ПустаяСтрока(КодВычета) Тогда
				СуммаВычета = 0;
			КонецЕсли;
			
			Если КодДохода = "9811" Или КодДохода = "9812" Тогда
				КодВидаДохода = 1;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтавкаНалога = 0;
		НаименованиеДохода = "";
		КодВычета   = "";
		КодыВычетов = "";
		НаименованиеВычета = "";
		СуммаВычета = 0;
		
	КонецЕсли;
	
	ОбновитьИностранныеКомпании(ЭтотОбъект);
	Элементы.ГруппаКодСуммаВычета.Доступность = НЕ ПустаяСтрока(КодыВычетов);
	ПересчитатьВычет(ЭтотОбъект);
	
КонецПроцедуры
 
&НаКлиенте
Процедура КодДоходаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидКодов", "КодыДоходов");
	ПараметрыФормы.Вставить("ТаблицаКодов", ТаблицаВХранилище("КодыДоходов"));
	
	Оповещение = Новый ОписаниеОповещения("КодДоходаНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ДоходВВалюте2017кв1", "ВыборКодаДоходаИВычета"), ПараметрыФормы, Элемент, Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВычетаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КодВычета) И Найти(КодыВычетов + ",", КодВычета + ",") = 0 Тогда
		
		НаименованиеВычета = "";
		Сообщить("Возможно, код код вычета указан неверно. Проверьте код вычета и код дохода.");
		
	КонецЕсли;
	
	Если ПустаяСтрока(КодВычета) Тогда
		
		СуммаВычета = 0;
		НаименованиеВычета = "";
		
	Иначе
		
		СтрокиВычета = ВсеКодыВычетов.НайтиСтроки(Новый Структура("Код", КодВычета));
		Если СтрокиВычета.Количество() = 0 Тогда
			НаименованиеВычета = "";
		Иначе
			НаименованиеВычета = СтрокиВычета[0].Наименование;
		КонецЕсли; 
		
	КонецЕсли;
	
	ПересчитатьВычет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВычетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПустаяСтрока(КодыВычетов) Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидКодов", "КодыВычетов");
	ПараметрыФормы.Вставить("ТаблицаКодов", ТаблицаВычетовВХранидище(КодыВычетов));
	
	Оповещение = Новый ОписаниеОповещения("КодВычетаНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ДоходВВалюте2017кв1", "ВыборКодаДоходаИВычета"), ПараметрыФормы, Элемент, Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаПриИзменении(Элемент)
	ПересчитатьВычет(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СуммаВычетаПриИзменении(Элемент)
	ПересчитатьВычет(ЭтотОбъект);
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


&НаСервере
Функция ОбъектЭтогоОтчета()

	Если ЭтотОтчет = Неопределено Тогда
		ЭтотОтчет = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	Возврат ЭтотОтчет;

КонецФункции

&НаСервере
Процедура ОбновитьТаблицыКодовДоходовИВычетов()

	ОбъетОтчета = ОбъектЭтогоОтчета();
	ВсеКодыВычетов.Загрузить(ОбъетОтчета.ТаблицаКодовВычетов(НалогоплательщикСтатус, ГодОтчета));
	КодыДоходов.Загрузить(ОбъетОтчета.ТаблицаКодовДоходов(НалогоплательщикСтатус, ГодОтчета));

КонецПроцедуры

&НаСервере
Функция ТаблицаВХранилище(Таблица)

	Если ТипЗнч(Таблица) = Тип("ТаблицаЗначений") Тогда
		Возврат ПоместитьВоВременноеХранилище(Таблица);
	Иначе
		Возврат ПоместитьВоВременноеХранилище(ЭтотОбъект[Таблица].Выгрузить());
	КонецЕсли;

КонецФункции

&НаСервере
Функция ТаблицаВычетовВХранидище(ДопустимыеКоды)

	Если ПустаяСтрока(ДопустимыеКоды) Тогда
		Возврат ТаблицаВХранилище("ВсеКодыВычетов");
	КонецЕсли;
	
	ТаблицаВычетов = ВсеКодыВычетов.Выгрузить(Новый Массив);
	
	
	МассивСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДопустимыеКоды, ",", Истина);
	Для каждого Слово Из МассивСлов Цикл
		СтрокиВычетов = ВсеКодыВычетов.НайтиСтроки(Новый Структура("Код", Слово));
		Если СтрокиВычетов.Количество() > 0 Тогда
			НоваяСтрока = ТаблицаВычетов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокиВычетов[0]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаВХранилище(ТаблицаВычетов);

КонецФункции
 
&НаКлиенте
Процедура КодДоходаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		КодДохода   = Результат.Код;
		НаименованиеДохода = Результат.Наименование;
		СтавкаНалога = Результат.СтавкаНалога;
		КодДоходаПриИзменении(Неопределено);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодВычетаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		КодВычета = Результат.Код;
		НаименованиеВычета = Результат.Наименование;
		КодВычетаПриИзменении(Неопределено);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСвойствКонтейнера()

	Возврат "СтавкаНалога,СуммаДохода,СуммаНалогаНачислено,
				|ИДДокумента,СуммаНалогаУдержано,СуммаВычета,ПредставлениеДокумента";

КонецФункции


&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСвойствШапкиДокумента()

	Возврат "ИсточникНаименование,ИсточникСтрана,ВалютаДохода,
				|ДатаДохода,КодДохода,НаименованиеДохода,СуммаДоходаВВалюте,КурсНаДатуДохода,СуммаДохода,
				|ДатаУплатыНалога,СуммаНалогаУплаченоВВалюте,КурсНаДатуУплатыНалога,СуммаНалогаУплаченоЗаГраницей,СуммаНалогаПринимаетсяКЗачету,
				|КодВычета,КодыВычетов,НаименованиеВычета,СуммаВычета,
				|КодВидаДохода,НомерИностраннойОрганизации,ВычетЛиквидацииИностраннойОрганизации,
				|ВычетДивидендовИностраннойОрганизации,ОпределениеПрибылиИностраннойОрганизации,
				|ИндивидуальныйИнвестиционныйСчет";

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьВычет(Форма)

	Если (Форма.СуммаДохода = 0 ИЛИ ПустаяСтрока(Форма.КодВычета)) И Форма.СуммаВычета <> 0 Тогда
		Форма.СуммаВычета = 0;
	КонецЕсли; 
	
	СтрокиВычета = Форма.ВсеКодыВычетов.НайтиСтроки(Новый Структура("Код", Форма.КодВычета));
	Если СтрокиВычета.Количество()= 0 Тогда
		Форма.СуммаВычета = 0;
		ПересчитатьНалогНачислено(Форма);
		Возврат;
	КонецЕсли; 

	СтрокаВычета = СтрокиВычета[0];
	
	// Проверяем корректность указанной суммы вычета
	Если Форма.СуммаВычета > Форма.СуммаДохода Тогда
		Форма.СуммаВычета = Форма.СуммаДохода;
	КонецЕсли; 
	
	Если СтрокаВычета.СпособРасчета = "НормаВГод" И (Форма.СуммаВычета = 0 ИЛИ Форма.СуммаВычета > СтрокаВычета.РазмерВычета) Тогда
		
		Форма.СуммаВычета = Мин(Форма.СуммаДохода, СтрокаВычета.РазмерВычета);
		
	ИначеЕсли СтрокаВычета.СпособРасчета = "НеБолееЧем" И (Форма.СуммаВычета = 0 ИЛИ Форма.СуммаВычета > СтрокаВычета.РазмерВычета) Тогда
		
		Форма.СуммаВычета = СтрокаВычета.РазмерВычета;
		
	ИначеЕсли СтрокаВычета.СпособРасчета = "НормаОтДохода" Тогда
		
		Если СтрНайти("2201,2207,2208", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(Форма.СуммаДохода * 0.2, 2);
		ИначеЕсли СтрНайти("2202,2204,2209", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(Форма.СуммаДохода * 0.3, 2);
		ИначеЕсли СтрНайти("2203,2205", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(Форма.СуммаДохода * 0.4, 2);
		Иначеесли Форма.КодДохода = "2206" Тогда
			Форма.СуммаВычета = Окр(Форма.СуммаДохода * 0.25, 2);
		Иначе
			Форма.СуммаВычета = 0;
		КонецЕсли; 
		
	КонецЕсли; 
	
	ПересчитатьНалогНачислено(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКурсыВалют(ИмяКурса = Неопределено)

	Если ИмяКурса = Неопределено ИЛИ ИмяКурса = "Доход" Тогда
		Если ЗначениеЗаполнено(ДатаДохода) Тогда
			КурсНаДатуДохода = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДохода, ДатаДохода, ВалютаРубль).Курс;
		Иначе
			КурсНаДатуДохода = 0;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ИмяКурса = Неопределено ИЛИ ИмяКурса = "Налог" Тогда
		Если ЗначениеЗаполнено(ДатаУплатыНалога) Тогда
			КурсНаДатуУплатыНалога = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДохода, ДатаУплатыНалога, ВалютаРубль).Курс;
		Иначе
			КурсНаДатуУплатыНалога = 0;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьРублевыеСуммы(Форма, ИмяКурса = Неопределено)

	Если ИмяКурса = Неопределено ИЛИ ИмяКурса = "Доход" Тогда
		Форма.СуммаДохода = Форма.СуммаДоходаВВалюте * Форма.КурсНаДатуДохода;
		ПересчитатьВычет(Форма);
	КонецЕсли; 
	
	Если ИмяКурса = Неопределено ИЛИ ИмяКурса = "Налог" Тогда
		Форма.СуммаНалогаУплаченоЗаГраницей = Форма.СуммаНалогаУплаченоВВалюте * Форма.КурсНаДатуУплатыНалога;
		Если Форма.СуммаНалогаПринимаетсяКЗачету > Форма.СуммаНалогаУплаченоЗаГраницей Тогда
			Форма.СуммаНалогаПринимаетсяКЗачету = Форма.СуммаНалогаУплаченоЗаГраницей;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьНалогНачислено(Форма)

	Форма.СуммаНалогаНачислено = Окр(Макс(0, (Форма.СуммаДохода - Форма.СуммаВычета)) * Форма.СтавкаНалога / 100, 0);

КонецПроцедуры
 

&НаКлиенте
Процедура ЗаписатьДокументКлиент()

	
	Если ЗначениеЗаполнено(ИсточникНаименование) Тогда
		ПредставлениеДокумента = ИсточникНаименование;
	КонецЕсли; 
	Если ЗначениеЗаполнено(НаименованиеДохода) Тогда
		ПредставлениеДокумента = ПредставлениеДокумента + ?(ПредставлениеДокумента = "", "", ", ") + НаименованиеДохода;
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

	Если КодДохода = "9811" Тогда
		ВычетЛиквидацииИностраннойОрганизации = СуммаВычета;
		ВычетДивидендовИностраннойОрганизации = 0;
	ИначеЕсли КодДохода = "9812" Тогда
		ВычетЛиквидацииИностраннойОрганизации = 0;
		ВычетДивидендовИностраннойОрганизации = СуммаВычета;
	Иначе
		ВычетЛиквидацииИностраннойОрганизации = 0;
		ВычетДивидендовИностраннойОрганизации = 0;
	КонецЕсли;
	
	СтрокаСвойств = СтрокаСвойствКонтейнера();
	Результат = Новый Структура(СтрокаСвойств);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект, СтрокаСвойств);
	
	СтрокаСвойств = СтрокаСвойствШапкиДокумента();
	Результат.Вставить("ШапкаДокумента", Новый Структура(СтрокаСвойств));
	ЗаполнитьЗначенияСвойств(Результат.ШапкаДокумента, ЭтотОбъект, СтрокаСвойств);
	
	Модифицированность = Ложь;
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Функция ДанныеЗаполненыКорректно()

	ОчиститьСообщения();
	
	КоллекцияОшибок = Неопределено;
	Если НЕ ЗначениеЗаполнено(КодВидаДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КодВидаДохода", 
				НСтр("ru = 'Не указан код вида дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ИсточникСтрана) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникСтрана", 
				НСтр("ru = 'Не указана страна источника дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ВалютаДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВалютаДохода, "ВалютаДохода", 
				НСтр("ru = 'Не указана валюта дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если ПустаяСтрока(ИсточникНаименование) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ИсточникНаименование", 
				НСтр("ru = 'Не указано наименование плательщика дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если ПустаяСтрока(КодДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КодДохода", 
				НСтр("ru = 'Не указан код дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если  НЕ ЗначениеЗаполнено(ДатаДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ДатаДохода", 
				НСтр("ru = 'Не указана дата получения дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если  НЕ ЗначениеЗаполнено(КурсНаДатуДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КурсНаДатуДохода", 
				НСтр("ru = 'Не указан курс валюты дохода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если  НЕ ЗначениеЗаполнено(СуммаДоходаВВалюте) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаДоходаВВалюте", 
				НСтр("ru = 'Не указана сумма дохода в валюте'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	Если  НЕ ЗначениеЗаполнено(СуммаДохода) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаДохода", 
				НСтр("ru = 'Не указана сумма дохода в рублях'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
	КонецЕсли; 
	
	НужноПроверятьНалог = ЗначениеЗаполнено(ДатаУплатыНалога) ИЛИ ЗначениеЗаполнено(КурсНаДатуУплатыНалога)
			ИЛИ ЗначениеЗаполнено(СуммаНалогаУплаченоВВалюте) ИЛИ ЗначениеЗаполнено(СуммаНалогаУплаченоЗаГраницей)
			ИЛИ ЗначениеЗаполнено(СуммаНалогаПринимаетсяКЗачету);
			
	Если НужноПроверятьНалог Тогда
		
		Если  НЕ ЗначениеЗаполнено(ДатаУплатыНалога) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "ДатаУплатыНалога", 
					НСтр("ru = 'Не указана дата уплаты налога'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		Если  НЕ ЗначениеЗаполнено(КурсНаДатуУплатыНалога) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КурсНаДатуУплатыНалога", 
					НСтр("ru = 'Не указан курс валюты на дату уплаты налога'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		Если  НЕ ЗначениеЗаполнено(СуммаНалогаУплаченоВВалюте) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаНалогаУплаченоВВалюте", 
					НСтр("ru = 'Не указана сумма уплаченного за границей налога'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		Если  НЕ ЗначениеЗаполнено(СуммаНалогаУплаченоЗаГраницей) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаНалогаУплаченоЗаГраницей", 
					НСтр("ru = 'Не указана сумма уплаченного налога в пересчете рубли'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(КодВычета) ИЛИ ЗначениеЗаполнено(СуммаВычета) Тогда
		
		Если  НЕ ЗначениеЗаполнено(КодВычета) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "КодВычета", 
					НСтр("ru = 'Не указан код вычета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		Если  НЕ ЗначениеЗаполнено(СуммаВычета) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "СуммаВычета", 
					НСтр("ru = 'Не указана сумма вычета'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если КодВидаДохода = 1 Тогда
		Если  НЕ ЗначениеЗаполнено(НомерИностраннойОрганизации) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КоллекцияОшибок, "НомерИностраннойОрганизации", 
					НСтр("ru = 'Не указан номер зависимой иностранной компании'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "");
		КонецЕсли; 
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

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИностранныеКомпании(Форма)

	ДоступностьКомпаниии = Форма.КодВидаДохода = 1;
	Форма.Элементы.ГруппаНомерСпособОпределенияПрибыли.Доступность   = ДоступностьКомпаниии;
	Форма.Элементы.ГруппаСуммыВычетаЗависимыхОрганизаций.Доступность = ДоступностьКомпаниии;

КонецПроцедуры



#КонецОбласти


