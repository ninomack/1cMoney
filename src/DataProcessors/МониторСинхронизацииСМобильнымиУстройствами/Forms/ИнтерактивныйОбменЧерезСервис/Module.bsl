////////////////////////////////////////////////////////////////////////////////
//Обработка.МониторСинхронизации.Форма.ИнтерактивныйОбменЧерезОблако
//  Выполняет фоновый обмен через облако и информирует пользователя о его состоянии
//  
//Параметры формы:
//  Стандартные параметры формы
//  
////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Перем ЗакрытиеОбработано;



#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПередНачаломСинхронизации();
	
	Если ПараметрыОблака.ЗапретитьИспользование Тогда
		ДействиеПриОткрытии = "Открыть настройки";
	ИначеЕсли Не ПровайдерАвторизован(Истина) Тогда
		ДействиеПриОткрытии = "Открыть авторизацию";
	Иначе
		ДействиеПриОткрытии = "Начать синхронизацию";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДействиеПриОткрытии = "Открыть настройки" Тогда
		ОткрытьФормуНастроек();
	ИначеЕсли ДействиеПриОткрытии = "Открыть авторизацию" Тогда
		ОткрытьФормуАвторизации();
	ИначеЕсли ДействиеПриОткрытии = "Начать синхронизацию" И ТранспортДоступенДляНовогоОбмена Тогда 
		ПодключитьОбработчикОжидания("Подключаемый_НачатьСинхронизациюКлиент", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Или Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗакрытиеОбработано <> Истина И ФоновоеЗаданиеЗавершено() = Ложь Тогда
		
		Отказ = истина;
		ПодтвердитьПрекращениеСинхронизации(Истина);
		
	КонецЕсли; 
	
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Повторить(Команда)
	
	ПередНачаломСинхронизации();
	
	Если ТранспортДоступенДляНовогоОбмена Тогда 
		НачатьСинхронизациюКлиент();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПередНачаломСинхронизации()

	Элементы.КартинкаСостояния.Картинка         = БиблиотекаКартинок.СинхронизацияНетОбмена48;
	Элементы.КартинкаСостояния.Доступность      = Истина;
	Элементы.ТекстСостоянияТранспорта.Заголовок = НСтр("ru='Подготовка к синхронизации…'");
	Элементы.ГруппаРамкаОшибки.Видимость        = Ложь;
	
	ТекстОшибкиТранспорта = "";
	СписокУстройств.Очистить();
	
	ОбновитьПараметрыПровайдера();
	
	ТранспортДоступенДляНовогоОбмена = РегистрыСведений.КонтрольТранспортовОбмена.ТранспортДоступенДляНовогоОбмена(Транспорт);
	Если Не ТранспортДоступенДляНовогоОбмена Тогда
		Элементы.КартинкаСостояния.Доступность = Ложь;
		Элементы.ТекстСостоянияТранспорта.Заголовок = НСтр("ru='Сервис используется в фоновом задании или другом сеансе'");
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюСервер()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Транспорт",   Транспорт);
	Запрос.УстановитьПараметр("СписокУстройств",   СписокУстройств.Выгрузить(, "УзелИнформационнойБазы"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокУстройств.УзелИнформационнойБазы
	|ПОМЕСТИТЬ СписокУстройств
	|ИЗ
	|	&СписокУстройств КАК СписокУстройств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрольТранспортовОбмена.НомерСеанса,
	|	КонтрольТранспортовОбмена.НачалоОбмена,
	|	КонтрольТранспортовОбмена.ТекущееДействие,
	|	КонтрольТранспортовОбмена.ТекстСообщений,
	|	КонтрольТранспортовОбмена.ОбменЗавершен
	|ИЗ
	|	РегистрСведений.КонтрольТранспортовОбмена КАК КонтрольТранспортовОбмена
	|ГДЕ
	|	КонтрольТранспортовОбмена.Транспорт = &Транспорт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СписокУстройств.УзелИнформационнойБазы, КонтрольОбменаДанными.УзелИнформационнойБазы) КАК УзелИнформационнойБазы,
	|	КонтрольОбменаДанными.ТекущееДействие,
	|	КонтрольОбменаДанными.ПоследнееПолучение,
	|	КонтрольОбменаДанными.РезультатПолученияДанных,
	|	КонтрольОбменаДанными.ТекстОшибокПолучения,
	|	КонтрольОбменаДанными.ПоследняяОтправка,
	|	КонтрольОбменаДанными.РезультатОтправкиДанных,
	|	КонтрольОбменаДанными.ТекстОшибокОтправки,
	|	КонтрольОбменаДанными.НомерСеанса,
	|	КонтрольОбменаДанными.РезультатПолученияДанныхУзлом,
	|	КонтрольОбменаДанными.ТекстОшибокПолученияУзлом,
	|	КонтрольОбменаДанными.РезультатОтправкиДанныхУзлом,
	|	КонтрольОбменаДанными.ТекстОшибокОтправкиУзлом,
	|	КонтрольОбменаДанными.ПоследнееПолучениеУзлом,
	|	КонтрольОбменаДанными.ПоследняяОтправкаУзлом,
	|	КонтрольОбменаДанными.Транспорт
	|ИЗ
	|	СписокУстройств КАК СписокУстройств
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрольОбменаДанными КАК КонтрольОбменаДанными
	|		ПО СписокУстройств.УзелИнформационнойБазы = КонтрольОбменаДанными.УзелИнформационнойБазы
	|			И (КонтрольОбменаДанными.Транспорт = &Транспорт)
	|ГДЕ 
	|	НЕ Транспорт ЕСТЬ NULL
	|";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	// Обновляем состояние транспорта
	НомерСеансаТранспорта = -1;
	ТекущееДействие   = Неопределено;
	ОбменЗавершен     = Неопределено;
	Выборка = ПакетРезультатов[1].Выбрать();
	Если Выборка.Следующий() Тогда
		НомерСеансаТранспорта = Выборка.НомерСеанса;
		ТекущееДействие       = Выборка.ТекущееДействие;
		ТекстОшибкиТранспорта = ТекстОшибки(Выборка.ТекстСообщений);
		ОбменЗавершен         = Выборка.ОбменЗавершен;
	КонецЕсли;
	
	Если ОбменЗавершен = Истина Тогда
		Элементы.КартинкаСостояния.Картинка = ?(ЗначениеЗаполнено(ТекстОшибкиТранспорта), БиблиотекаКартинок.СинхронизацияОшибка48, БиблиотекаКартинок.СинхронизацияНетОбмена48);
	Иначе
		Элементы.КартинкаСостояния.Картинка = БиблиотекаКартинок.СинхронизацияИдетОбмен48;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущееДействие) Тогда
		Элементы.ТекстСостоянияТранспорта.Заголовок = ТекущееДействие;
	ИначеЕсли Не ЗначениеЗаполнено(ТекстОшибкиТранспорта) Тогда 
		Элементы.ТекстСостоянияТранспорта.Заголовок = НСтр("ru='Обмен завершен'");
	Иначе
		Элементы.ТекстСостоянияТранспорта.Заголовок = НСтр("ru='Обмен прерван'");
	КонецЕсли;
	
	Элементы.ГруппаРамкаОшибки.Видимость = ЗначениеЗаполнено(ТекстОшибкиТранспорта);
	
	
	// Обновляем состояние узлов
	УзлыКУдалению = Новый Массив;
	Выборка = ПакетРезультатов[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТекущееДействие = NULL Тогда
			УзлыКУдалению.Добавить(Выборка.УзелИнформационнойБазы);
			Продолжить;
		КонецЕсли;
		
		СтрокаСписка = СтрокаСпискаПоУзлу(Выборка.УзелИнформационнойБазы, Истина);
		СтрокаСписка.ТекущееДействие = ?(ОбменЗавершен, "", Выборка.ТекущееДействие);
		
		Если ЗначениеЗаполнено(СтрокаСписка.ТекущееДействие) И Не ОбменЗавершен Тогда
			СтрокаСписка.ИконкаСостояния = БиблиотекаКартинок.СинхронизацияИдетОбмен16;
		Иначе
			СтрокаСписка.ИконкаСостояния = БиблиотекаКартинок.СинхронизацияНетОбмена16;
		КонецЕсли;
		
		СтрокаСписка.СостояниеПолучения = СостояниеОперацииОбмена(Выборка.РезультатПолученияДанных);
		Если СтрокаСписка.СостояниеПолучения = -1 Тогда
			СтрокаСписка.ИконкаПолучения = БиблиотекаКартинок.СинхронизацияОшибкаПолученияДанных16;
			СтрокаСписка.ПредставлениеПолучения = НСтр("ru='см. ошибки'");
		Иначе
			СтрокаСписка.ИконкаПолучения = БиблиотекаКартинок.СинхронизацияПолучениеДанных16;
			СтрокаСписка.ПредставлениеПолучения = ?(СтрокаСписка.СостояниеПолучения = 0, "", НСтр("ru='Ок'"));
		КонецЕсли;
		
		СтрокаСписка.СостояниеОтправки = СостояниеОперацииОбмена(Выборка.РезультатОтправкиДанных);
		Если СтрокаСписка.СостояниеОтправки = -1 Тогда
			СтрокаСписка.ИконкаОтправки = БиблиотекаКартинок.СинхронизацияОшибкаОтправкаДанных16;
			СтрокаСписка.ПредставлениеОтправки = НСтр("ru='см. ошибки'");
		Иначе
			СтрокаСписка.ИконкаОтправки = БиблиотекаКартинок.СинхронизацияОтправкаДанных16;
			СтрокаСписка.ПредставлениеОтправки = ?(СтрокаСписка.СостояниеОтправки = 0, "", НСтр("ru='Ок'"));
		КонецЕсли;
		
		Если Выборка.РезультатПолученияДанныхУзлом = Перечисления.РезультатыВыполненияОбмена.Выполнено
			Или Выборка.РезультатПолученияДанныхУзлом = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями Тогда
			СтрокаСписка.ОшибкаЗагрузкиУзлом = Ложь;
			СтрокаСписка.ПредставлениеЗагрузкиУзлом = СтрШаблон(НСтр("ru='загрузка на устройстве %1'"), Формат(Выборка.ПоследнееПолучениеУзлом, "Л=ru_RU; ДФ=dd.MM.yyyy")); 
		ИначеЕсли ЗначениеЗаполнено(Выборка.ТекстОшибокПолученияУзлом) Тогда 
			СтрокаСписка.ОшибкаЗагрузкиУзлом = Истина;
			СтрокаСписка.ПредставлениеЗагрузкиУзлом = СтрШаблон(НСтр("ru='%1 ошибка загрузки на устройстве'"), Формат(Выборка.ПоследнееПолучениеУзлом, "Л=ru_RU; ДФ=dd.MM.yyyy")); 
		Иначе
			СтрокаСписка.ОшибкаЗагрузкиУзлом = Ложь;
			СтрокаСписка.ПредставлениеЗагрузкиУзлом = ""; 
		КонецЕсли;
		
		Если Выборка.РезультатОтправкиДанныхУзлом = Перечисления.РезультатыВыполненияОбмена.Выполнено
			Или Выборка.РезультатОтправкиДанныхУзлом = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями Тогда
			СтрокаСписка.ОшибкаОтправкиУзлом = Ложь;
			СтрокаСписка.ПредставлениеОтправкиУзлом = СтрШаблон(НСтр("ru='отправлено с устройства %1'"), Формат(Выборка.ПоследнееПолучениеУзлом, "Л=ru_RU; ДФ=dd.MM.yyyy")); 
		ИначеЕсли ЗначениеЗаполнено(Выборка.ТекстОшибокОтправкиУзлом) Тогда 
			СтрокаСписка.ОшибкаОтправкиУзлом = Истина;
			СтрокаСписка.ПредставлениеОтправкиУзлом = СтрШаблон(НСтр("ru='%1 ошибка отправки на устройстве'"), Формат(Выборка.ПоследнееПолучениеУзлом, "Л=ru_RU; ДФ=dd.MM.yyyy")); 
		Иначе
			СтрокаСписка.ОшибкаОтправкиУзлом = Ложь;
			СтрокаСписка.ПредставлениеОтправкиУзлом = ""; 
		КонецЕсли;
		
		
	КонецЦикла;
	
	// Удаление линшних строк
	Для каждого УзелКУдалению Из УзлыКУдалению Цикл
		СтрокаСписка = СтрокаСпискаПоУзлу(УзелКУдалению, Ложь);
		Если СтрокаСписка <> Неопределено Тогда
			СписокУстройств.Удалить(СтрокаСписка);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция СтрокаСпискаПоУзлу(Узел, Создавать = Истина)

	СтрокаУзла = Неопределено;
	
	СтрокиУзла = СписокУстройств.НайтиСтроки(Новый Структура("УзелИнформационнойБазы", Узел));
	Если СтрокиУзла.Количество() = 0 Тогда
		
		Если Создавать Тогда
			СтрокаУзла = СписокУстройств.Добавить();
			СтрокаУзла.УзелИнформационнойБазы = Узел;
		КонецЕсли;
		
	Иначе
		СтрокаУзла = СтрокиУзла[0];
	КонецЕсли;

	Возврат СтрокаУзла;
	
КонецФункции

&НаСервереБезКонтекста
Функция СостояниеОперацииОбмена(РезультатВыполнения)

	Если РезультатВыполнения = Перечисления.РезультатыВыполненияОбмена.Выполнено
			Или РезультатВыполнения = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями Тогда
		Возврат 1; // успешно завершено
	ИначеЕсли РезультатВыполнения = Перечисления.РезультатыВыполненияОбмена.Ошибка
		Или РезультатВыполнения = Перечисления.РезультатыВыполненияОбмена.Ошибка_ТранспортСообщения
		Или РезультатВыполнения = Перечисления.РезультатыВыполненияОбмена.Предупреждение_СообщениеОбменаБылоРанееПринято Тогда
		Возврат -1; // завершено ошибкой 
	Иначе
		Возврат 0; // нет информации о завершении
	КонецЕсли;

КонецФункции

&НаСервере
Процедура ОбновитьПараметрыПровайдера()

	СвойстваАккаунта = Неопределено;
	Провайдер = RESTВызовСервера.ПровайдерИзПараметраСеанса(СвойстваАккаунта);
	Транспорт = Справочники.ТранспортыОбменаДанными.ОсновнойТранспортОблачногоПровайдера(Провайдер);
	ПараметрыОблака = Справочники.ТранспортыОбменаДанными.СтруктураПараметровТранспорта(Транспорт, Истина);
	ПараметрыОблака.Вставить("СвойстваАккаунта", СвойстваАккаунта);
	
	Если Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Dropbox") Тогда
		Элементы.ИконкаПровайдера.Картинка = БиблиотекаКартинок.СинхронизацияDropBox16;
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Google") Тогда
		Элементы.ИконкаПровайдера.Картинка = БиблиотекаКартинок.СинхронизацияGoogleDrive16;
	ИначеЕсли Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Яндекс") Тогда
		Элементы.ИконкаПровайдера.Картинка = БиблиотекаКартинок.СинхронизацияЯндексДиск16;
	Иначе
		Элементы.ИконкаПровайдера.Картинка = БиблиотекаКартинок.Синхронизация16;
	КонецЕсли;
	
	Если ПараметрыОблака.ЗапретитьИспользование Тогда
		Элементы.ПредставлениеАккаунта.Заголовок = НСтр("ru='Отключен'");
	Иначе
		 Элементы.ПредставлениеАккаунта.Заголовок = СвойстваАккаунта.ПредставлениеАккаунта;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПровайдерАвторизован(ПроверятьНаСервере)

	СвойстваАккаунта = ?(ПараметрыОблака = Неопределено, Неопределено, ПараметрыОблака.СвойстваАккаунта);
	Возврат RESTКлиентСервер.ПриложениеАвторизовано(Провайдер, ПроверятьНаСервере, СвойстваАккаунта);

КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастроек()

	// Параметры открываемой формы
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Провайдер", Провайдер);
	ПараметрыФормы.Вставить("ВключитьИспользованиеПриОткрытии", Истина);
	
	// Обработчик оповещения о закрытии формы
	ДополнительныеПараметры = Новый Структура();
	Оповещение = Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	// Открытие формы
	ОткрытьФорму("Обработка.МониторСинхронизацииСМобильнымиУстройствами.Форма.НастройкаОблачногоСервиса", ПараметрыФормы, ЭтотОбъект, Истина, , , Оповещение, РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуАвторизации()

	// Обработчик оповещения о закрытии формы
	ДополнительныеПараметры = Новый Структура();
	Оповещение = Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	RESTКлиент.ОткрытьФормуАвторизации(Провайдер, Оповещение); 

КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт

	РезультатИзменения = РезультатИзмененияНастроек();
	Если РезультатИзменения = "Запрет использования" Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru='Использование облачного сервиса запрещено в настройках.
				|Измените настройки и повторите попытку'"), , Заголовок);
		
	ИначеЕсли РезультатИзменения = "Не авторизован" Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеПослеПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru='Использование облачного сервиса запрещено в настройках.
				|Измените настройки и повторите попытку'"), , Заголовок);
		
	Иначе
		
		НачатьСинхронизациюКлиент();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция РезультатИзмененияНастроек()

	ОбновитьПараметрыПровайдера();
	Если ПараметрыОблака.ЗапретитьИспользование Тогда
		Возврат "Запрет использования";
	КонецЕсли;
	
	Если Не ПровайдерАвторизован(Ложь) Тогда
		Возврат "Не авторизован";
	КонецЕсли;

	Возврат "Ок";
	
КонецФункции

&НаКлиенте
Процедура ЗакрытиеПослеПредупреждения(ДополнительныеПараметры) Экспорт

	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьСинхронизациюКлиент()

	НачатьСинхронизациюКлиент();

КонецПроцедуры

&НаКлиенте
Процедура НачатьСинхронизациюКлиент()

	ПроверкаПровайдераПередСинхронизацией();
	ДлительнаяОперация = НачатьСинхронизациюСервер();
	ОбновитьИнформациюСервер();
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверкаСостоянияТранспорта", 1, Истина);

КонецПроцедуры

&НаСервере
Функция НачатьСинхронизациюСервер()
	
	// Установим оформление формы
	Элементы.КартинкаСостояния.Картинка = БиблиотекаКартинок.СинхронизацияИдетОбмен48;
	Элементы.Повторить.Доступность = Ложь;
	
	// параметры выполнеия задания
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = 
			СтрШаблон(НСтр("ru='Обмен с мобильными приложениями через %1'"), Строка(Провайдер));
	
	// параметры метода, выполняемого в фоне
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Транспорт", Транспорт);
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
			"Обработки.МониторСинхронизацииСМобильнымиУстройствами.ЗапуститьОбменИнтерактивно",
			СтруктураПараметров, ПараметрыВыполнения);
			
	Если РезультатВыполнения <> Неопределено Тогда
		ИДФоновогоЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища    = РезультатВыполнения.АдресРезультата;
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверкаСостоянияТранспорта()

	ОбновитьИнформациюСервер();
	Если ФоновоеЗаданиеЗавершено() = Истина Тогда
		Элементы.КартинкаСостояния.Картинка = ?(ЗначениеЗаполнено(ТекстОшибкиТранспорта), БиблиотекаКартинок.СинхронизацияОшибка48, БиблиотекаКартинок.СинхронизацияНетОбмена48);
		Элементы.Повторить.Доступность = Истина;
		ОбновитьИнформациюСервер();
		ПодключитьОбработчикОжидания("Подключаемый_ПроверкаСостоянияТранспорта", 3, Истина);
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ПроверкаСостоянияТранспорта", 1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ФоновоеЗаданиеЗавершено()

	Если Не ЗначениеЗаполнено(ИДФоновогоЗадания) Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ИДФоновогоЗадания);
	Исключение
		
		ТекстОшибкиТранспорта = ТекстОшибки(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Элементы.КартинкаСостояния.Картинка = БиблиотекаКартинок.СинхронизацияОшибка48;
		Элементы.ГруппаРамкаОшибки.Видимость = ЗначениеЗаполнено(ТекстОшибкиТранспорта);
		
		ЗаданиеВыполнено = Истина;
		
	КонецПопытки; 
	
	Возврат ЗаданиеВыполнено;
	
КонецФункции


&НаКлиенте
Процедура ПодтвердитьПрекращениеСинхронизации(ЗакрыватьФорму)

	ТекстВопроса = НСтр("ru = 'Прекратить синхронизацию?'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект, Новый Структура("ЗакрыватьФорму", ЗакрыватьФорму));
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Синхронизация с мобильными устройствами'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()) );

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПрекратитьСинхронизациюСервер();
		
		Если ДополнительныеПараметры.ЗакрыватьФорму Тогда
			ЗакрытиеОбработано = Истина;
			Закрыть();
		КонецЕсли;
		
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ПрекратитьСинхронизациюСервер()

	Если ЗначениеЗаполнено(ИДФоновогоЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИДФоновогоЗадания);
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОшибки(Текст)

	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат "";
	Иначе
		Возврат НСтр("ru='Обмен прерван из-за ошибки:'") + Символы.ПС + Текст; 
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ПроверкаПровайдераПередСинхронизацией()

	Если Провайдер = ПредопределенноеЗначение("Перечисление.ТипыПровайдеровREST.Google") Тогда
		Если Не ПровайдерАвторизован(Истина) Тогда
			ОткрытьФормуАвторизации();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
 

#КонецОбласти
