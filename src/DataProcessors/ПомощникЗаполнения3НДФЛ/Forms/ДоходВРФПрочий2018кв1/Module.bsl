////////////////////////////////////////////////////////////////////////////////
//Отчет.РегламентированныйОтчет3НДФЛ.Форма.ДоходОднойСуммойБезВычетов
//  Заполнение информации о подарках или сдаче в аренду
//  
//Параметры формы:
//  Стандартные параметры формы
//  
////////////////////////////////////////////////////////////////////////////////

&НаСервере 
Перем ЭтотОтчет;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Конвертация параметров формы в значения ДропРеквизитов формы
	Обработки.ПомощникЗаполнения3НДФЛ.ЗаполнитьДопРеквизитыФормыДокументаПомощника(ЭтотОбъект);
	Параметры.Свойство("Декларация3НДФЛВыбраннаяФорма", Декларация3НДФЛВыбраннаяФорма);
	
	// Чтение структуры документа
	СтрукураДокументаНаСервере = Обработки.ПомощникЗаполнения3НДФЛ.СтруктураДокументаСТаблицамиИзХранилищ(ДопРеквизитыФормы.СтруктураДокумента);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрукураДокументаНаСервере, ,);
	
	Если СтрНайти(Декларация3НДФЛВыбраннаяФорма, "2018") = 0 Тогда
		Элементы.ВидКонтрагента.СписокВыбора.Добавить(0, "Неизвестен");
	Иначе
		Если ВидКонтрагента = 0 Тогда
			ВидКонтрагента = ?(СтрДлина(ИНН) = 10, 1, 2);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидДохода = "Дивиденды" Тогда
		
		Элементы.ТекстПриглашения.Заголовок = НСтр("ru='Укажите сумму дивидендов, с которой налоговый агент полностью или частично не удержал налог
		|Информацию можно получить из справки 2-НДФЛ.'"); 
		Заголовок = НСтр("ru='Дивиденды'");
		
		Элементы.КодДохода.Видимость = Ложь;
		Элементы.ГруппаКодСуммаВычета.Видимость = Ложь;
		
	ИначеЕсли ВидДохода = "ПрочийДоход" Тогда
		
		Элементы.ТекстПриглашения.Заголовок = НСтр("ru='Укажите доход, полученный в РФ, налог с которого не был удержан налоговым агентом полностью или частично.
		|Информацию можно получить из справки 2-НДФЛ.'"); 
		Заголовок = НСтр("ru='Прочий доход в РФ'");
		
		Элементы.КодДохода.Видимость = Истина;
		Элементы.ГруппаКодСуммаВычета.Видимость = Истина;
		ОбновитьТаблицыКодовДоходовВычетов();
		
	Иначе
		
		ВызватьИсключение НСтр("ru='Неизвесный вид дохода'");
		
	КонецЕсли;
	
	
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
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	Если ВидКонтрагента = 0 Тогда
		Наименование = "";
	КонецЕсли;
	Если ВидКонтрагента <> 1 Тогда
		ИНН   = "";
		КПП   = "";
		ОКТМО = "";
	КонецЕсли;
	
	УстановитьВидимостьПолейКонтрагента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаДоходаПриИзменении(Элемент)
	
	СтрокаДохода = Неопределено;
	ОбновитьПодписьВидаДохода(ЭтотОбъект, СтрокаДохода);
	Если СтрокаДохода <> Неопределено Тогда
		СтавкаНалога          = СтрокаДохода.СтавкаНалога;
		ДопустимыеКодыВычетов = СтрокаДохода.КодыВычетов;
	КонецЕсли;
	
	Если ДопустимыеКодыВычетов = "" Или СтрНайти(ДопустимыеКодыВычетов + ",", КодВычета + ",") = 0 Тогда
		КодВычета   = "";
		СуммаВычета = 0;
	КонецЕсли;
	
	ОбновитьСписокКодовВычетов(ЭтотОбъект);
	ПересчитатьСуммуВычета(ЭтотОбъект);
	РассчитатьНалог(ЭтотОбъект);
	ИзменитьДоступностьВычета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаДоходаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидКодов", "КодыДоходов");
	ПараметрыФормы.Вставить("ТаблицаКодов", ТаблицаВХранилище("КодыДоходов"));
	
	Оповещение = Новый ОписаниеОповещения("КодДоходаНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("Отчет.РегламентированныйОтчет3НДФЛ.Форма.ВыборКодаДоходаИВычета", ПараметрыФормы, Элемент, Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаПриИзменении(Элемент)
	
	ПересчитатьСуммуВычета(ЭтотОбъект);
	РассчитатьНалог(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВычетаПриИзменении(Элемент)
	ПересчитатьСуммуВычета(ЭтотОбъект);
	РассчитатьНалог(ЭтотОбъект);
	ИзменитьДоступностьВычета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КодВычетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Возврат;
	СтандартнаяОбработка = Ложь;
	
	Если ПустаяСтрока(ДопустимыеКодыВычетов) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидКодов", "КодыВычетов");
	ПараметрыФормы.Вставить("ТаблицаКодов", ТаблицаВычетовВХранидище(ДопустимыеКодыВычетов));
	
	Оповещение = Новый ОписаниеОповещения("КодВычетаНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("Отчет.РегламентированныйОтчет3НДФЛ.Форма.ВыборКодаДоходаИВычета", ПараметрыФормы, Элемент, Истина, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаОблагаемаяПриИзменении(Элемент)
	
	Если СуммаДохода < СуммаДоходаОблагаемая Тогда
		СуммаДоходаОблагаемая = СуммаДохода;
	КонецЕсли;
	
	ПересчитатьСуммуВычета(ЭтотОбъект);
	РассчитатьНалог(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВычетаПриИзменении(Элемент)
	
	ПересчитатьСуммуВычета(ЭтотОбъект, СуммаВычета);
	РассчитатьНалог(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаПриИзменении(Элемент)
	
	РассчитатьНалог(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНалогаУдержаннаяПриИзменении(Элемент)
	
	Если СуммаНалогаУдержанная > СуммаНалога Тогда
		СуммаНалогаУдержанная = СуммаНалога;
	КонецЕсли;
	
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
	
	ИзменитьДоступностьВычета(Форма);
	УстановитьВидимостьПолейКонтрагента(Форма);
	
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

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьНалог(Форма)

	Форма.СуммаДоходаОблагаемая = Макс(Форма.СуммаДохода - Форма.СуммаВычета, 0);
	Форма.СуммаНалога = Окр(Форма.СуммаДоходаОблагаемая * Форма.СтавкаНалога / 100, 0);
	Если Форма.СуммаНалогаУдержанная > Форма.СуммаНалога Тогда
		Форма.СуммаНалогаУдержанная = Форма.СуммаНалога;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьСуммуВычета(Форма, НоваяСуммаВычета = 0)

	Форма.СуммаВычета = НоваяСуммаВычета;
	
	Если Форма.СуммаДохода = 0 ИЛИ ПустаяСтрока(Форма.КодВычета) Тогда
		Возврат;
	КонецЕсли; 
	
	СтрокаВычета = СтрокаВычетаПоКоду(Форма.КодВычета, Форма.КодыВычетов);
	Если СтрокаВычета = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='Неизвестный вычет с кодом %1'"), Форма.КодВычета);
	КонецЕсли;
	
	МаксДоход = Макс(Форма.СуммаДохода, 0);
	
	Если Форма.СуммаВычета > МаксДоход Тогда
		Форма.СуммаВычета = МаксДоход;
	КонецЕсли; 
	
	Если СтрокаВычета.СпособРасчета = "НормаВГод" И (Форма.СуммаВычета = 0 ИЛИ Форма.СуммаВычета > СтрокаВычета.РазмерВычета) Тогда
		
		Форма.СуммаВычета = Мин(МаксДоход, СтрокаВычета.РазмерВычета);
		
	ИначеЕсли СтрокаВычета.СпособРасчета = "НеБолееДохода"  И Форма.СуммаВычета = 0 Тогда
		
		Форма.СуммаВычета = МаксДоход;
		
	ИначеЕсли СтрокаВычета.СпособРасчета = "НормаОтДохода" Тогда
		
		Если СтрНайти("2201,2207,2208", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(МаксДоход * 0.2, 2);
		ИначеЕсли СтрНайти("2202,2204,2209", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(МаксДоход * 0.3, 2);
		ИначеЕсли СтрНайти("2203,2205", Форма.КодДохода) > 0 Тогда
			Форма.СуммаВычета = Окр(МаксДоход * 0.4, 2);
		Иначеесли Форма.КодДохода = "2206" Тогда
			Форма.СуммаВычета = Окр(МаксДоход * 0.25, 2);
		Иначе
			Форма.СуммаВычета = 0;
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьДоступностьВычета(Форма)

	Форма.Элементы.СуммаВычета.Доступность = ЗначениеЗаполнено(Форма.КодВычета);

КонецПроцедуры


#Область ВидДохода

&НаСервере
Процедура ОбновитьТаблицыКодовДоходовВычетов()

	ОбъетОтчета = ОбъектЭтогоОтчета();
	КодыДоходов.Загрузить(ОбъетОтчета.ТаблицаКодовДоходов(ДопРеквизитыФормы.НалогоплательщикСтатус, ДопРеквизитыФормы.ГодОтчета));
	КодыВычетов.Загрузить(ОбъетОтчета.ТаблицаКодовВычетов(ДопРеквизитыФормы.НалогоплательщикСтатус, ДопРеквизитыФормы.ГодОтчета));
	Элементы.КодДохода.СписокВыбора.Очистить();
	Для каждого СтрокаКода Из КодыДоходов Цикл
		Элементы.КодДохода.СписокВыбора.Добавить(СтрокаКода.Код, СокрЛП(СтрокаКода.Код) + ": " + СтрокаКода.Наименование);
	КонецЦикла;
	ОбновитьСписокКодовВычетов(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписокКодовВычетов(Форма)

	Форма.Элементы.ГруппаКодСуммаВычета.Доступность = ЗначениеЗаполнено(Форма.ДопустимыеКодыВычетов);
	
	ЭлементКодВычета = Форма.Элементы.КодВычета;
	ЭлементКодВычета.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Форма.ДопустимыеКодыВычетов) Тогда
		ЭлементКодВычета.СписокВыбора.Добавить("", НСтр("ru='Без вычета'"));
	Иначе
		ЭлементКодВычета.СписокВыбора.Добавить("", НСтр("ru='Вычет не предусмотрен'"));
		Возврат;
	КонецЕсли;
	
	СписокКодов = СтрРазделить(Форма.ДопустимыеКодыВычетов, ",");
	Для каждого Код Из СписокКодов Цикл
		
		СтрокаВычета = СтрокаВычетаПоКоду(Код, Форма.КодыВычетов);
		Если СтрокаВычета = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементКодВычета.СписокВыбора.Добавить(СтрокаВычета.Код, СокрЛП(СтрокаВычета.Код) + ": " + СтрокаВычета.Наименование);
		
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаВычетаПоКоду(КодВычета, ВсеКоды)

	Если КодВычета = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Строки = ВсеКоды.НайтиСтроки(Новый Структура("Код", КодВычета));
	Если Строки.Количество() > 0 Тогда
		Возврат Строки[0];
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

&НаСервере
Функция ОбъектЭтогоОтчета()

	Если ЭтотОтчет = Неопределено Тогда
		ЭтотОтчет = РеквизитФормыВЗначение("Отчет");
	КонецЕсли;
	
	Возврат ЭтотОтчет;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодписьВидаДохода(Форма, СтрокаКода = Неопределено)

	Если Не ЗначениеЗаполнено(Форма.КодДохода) Тогда
		Форма.НаименованиеВидаДохода = "";
	Иначе
		
		СтрокиКода = Форма.КодыДоходов.НайтиСтроки(Новый Структура("Код", Форма.КодДохода));
		Если СтрокиКода.Количество() = 1 Тогда
			СтрокаКода = СтрокиКода[0];
			Форма.НаименованиеВидаДохода = СтрокаКода.Наименование;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодДоходаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		КодДохода          = Результат.Код;
		НаименованиеВидаДохода = Результат.Наименование;
		СтавкаНалога           = Результат.СтавкаНалога;
		ДопустимыеКодыВычетов  = Результат.КодыВычетов;
		
		ОбновитьСписокКодовВычетов(ЭтотОбъект);
		ПересчитатьСуммуВычета(ЭтотОбъект);
		РассчитатьНалог(ЭтотОбъект);
		ИзменитьДоступностьВычета(ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодВычетаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		КодВычета              = Результат.Код;
		ПересчитатьСуммуВычета(ЭтотОбъект);
		РассчитатьНалог(ЭтотОбъект);
		
	КонецЕсли;

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

	ТаблицаВычетов = КодыВычетов.Выгрузить(Новый Массив);
	
	МассивСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДопустимыеКоды, ",", Истина);
	Для каждого Слово Из МассивСлов Цикл
		СтрокиВычетов = КодыВычетов.НайтиСтроки(Новый Структура("Код", Слово));
		Если СтрокиВычетов.Количество() > 0 Тогда
			НоваяСтрока = ТаблицаВычетов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокиВычетов[0]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаВХранилище(ТаблицаВычетов);

КонецФункции
 
#КонецОбласти 



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

&НаСервере
Функция РезультатДляЗаписи()

	СтруктураДокумента = ДопРеквизитыФормы.СтруктураДокумента;
	ЗаполнитьЗначенияСвойств(СтруктураДокумента, ЭтотОбъект, , );
	
	Результат = Новый Структура;
	Результат.Вставить("ВидДокумента", ДопРеквизитыФормы.ВидДокумента);
	Результат.Вставить("СтавкаНалога", СтавкаНалога);
	Если ВидДохода = "Дивиденды" Тогда
		Результат.Вставить("Представление", СтрШаблон("Дивиденды (%1)", Наименование));
		Если ВидКонтрагента = 0 Тогда
			СтруктураДокумента.Наименование = "Дивиденды";
		КонецЕсли;
	Иначе
		Результат.Вставить("Представление", СтрШаблон("Прочие доходы в РФ (%1)", Наименование));
		Если ВидКонтрагента = 0 Тогда
			СтруктураДокумента.Наименование = "Прочие доходы, полученные в РФ";
		КонецЕсли;
	КонецЕсли;
	Результат.Вставить("СтруктураДокумента", СтруктураДокумента);
	Результат.Вставить("СуммаДохода", СуммаДохода);
	Результат.Вставить("СуммаВычета", СуммаВычета);

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

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПолейКонтрагента(Форма)

	Форма.Элементы.ГруппаИННКПП.Видимость = Форма.ВидКонтрагента = 1;
	Форма.Элементы.ГруппаНаименованиеОКТМО.Видимость = Форма.ВидКонтрагента >= 1;

КонецПроцедуры



#КонецОбласти


