///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтеграцияПодсистемБИП.
//
// Клиентские процедуры и функции интеграции с БСП и БИП:
//  - Подписка на события БСП;
//  - Обработка событий БСП в подсистемах БИП;
//  - Определение списка возможных подписок в БИП;
//  - Вызов методов БСП, на которые выполнена подписка;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийБСП

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БИП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - См. ИнтеграцияПодсистемБСПКлиент.СобытияБСП.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	// Варианты отчетов
	Подписки.ПриОбработкеВыбораТабличногоДокумента = Истина;
	Подписки.ПриОбработкеРасшифровки = Истина;
	
КонецПроцедуры

#Область НастройкиПрограммы

// Выполняет команду подключения Интернет-поддержки пользователей
// на панели администрирования "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой вызывается команда;
//  Команда - КомандаФормы - выполняемая команда.
//
Процедура ИнтернетПоддержкаИСервисы_БИПВойтиИлиВыйти(Форма, Команда) Экспорт
	
	Если Форма.БИПДанныеАутентификации = Неопределено Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(, Форма);
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ПриОтветеНаВопросОВыходеИзИнтернетПоддержки",
				ЭтотОбъект,
				Форма),
			НСтр("ru = 'Логин и пароль для подключения к сервисам Интернет-поддержки пользователей будут удалены из программы.
				|Отключить Интернет-поддержку?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет,
			НСтр("ru = 'Выход из Интернет-поддержки пользователей'"));
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку оповещения на панели администрирования
// "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, в которой обрабатывается оповещение;
//	ИмяСобытия - Строка - имя события;
//	Параметр - Произвольный - параметр;
//	Источник - Произвольный - источник события.
//
Процедура ИнтернетПоддержкаИСервисы_ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИнтернетПоддержкаПодключена" Тогда
		
		// Обработка подключения Интернет-поддержки.
		ВведенныеДанныеАутентификации = Параметр;
		Если ВведенныеДанныеАутентификации <> Неопределено Тогда
			Форма.БИПДанныеАутентификации = ВведенныеДанныеАутентификации;
			ИнтернетПоддержкаПользователейКлиентСервер.ОтобразитьСостояниеПодключенияИПП(Форма);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСКлассификаторамиКлиент");
		МодульРаботаСКлассификаторамиКлиент.ИнтернетПоддержкаИСервисы_ОбработкаОповещения(
			Форма,
			ИмяСобытия,
			Параметр,
			Источник);
	КонецЕсли;

КонецПроцедуры

// Выполняет обработку навигационных ссылок на панели администрирования
// "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, в которой обрабатывается оповещение;
//	Элемент - ДекорацияФормы - декорация на форме;
//	НавигационнаяСсылкаФорматированнойСтроки - Строка - навигационная ссылка;
//	СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ИнтернетПоддержкаИСервисы_ДекорацияОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если Элемент.Имя = "ДекорацияЛогинИПП" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьЛичныйКабинетПользователя();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды БИПСообщениеВСлужбуТехническойПоддержки
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//	Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_СообщениеВСлужбуТехническойПоддержки(Форма, Команда) Экспорт
	
	ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
		НСтр("ru = 'Интернет-поддержка пользователей'"),
		НСтр("ru = '<Заполните текст сообщения>'"));
	
КонецПроцедуры

#КонецОбласти

#Область ВариантыОтчетов

// См. ОтчетыКлиентПереопределяемый.ОбработкаВыбораТабличногоДокумента.
//
Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеВыбораТабличногоДокумента(
			ФормаОтчета,
			Элемент,
			Область,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки.
//
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеРасшифровки(
			ФормаОтчета,
			Элемент,
			Расшифровка,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу.
//
Процедура ОткрытьИнтернетСтраницу(АдресСтраницы, ЗаголовокОкна, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОткрытьИнтернетСтраницу Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОткрытьИнтернетСтраницу(
			АдресСтраницы,
			ЗаголовокОкна,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеОбновленийПрограммы

// См. ПолучениеОбновленийПрограммыКлиент.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях.
//
Процедура ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет события, на которые могут подписаться другие библиотеки.
//
// Возвращаемое значение:
//   События - Структура - Ключами свойств структуры являются имена событий, на которые
//             могут быть подписаны библиотеки.
//
Функция СобытияБИП() Экспорт
	
	События = Новый Структура;
	
	// Базовая функциональность БИП
	События.Вставить("ОткрытьИнтернетСтраницу", Ложь);
	
	// Получение обновления программы
	События.Вставить("ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях", Ложь);
	
	Возврат События;
	
КонецФункции

Процедура ПриОтветеНаВопросОВыходеИзИнтернетПоддержки(КодВозврата, Форма) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		ИнтернетПоддержкаПользователейВызовСервера.ВыйтиИзИПП();
		Форма.БИПДанныеАутентификации = Неопределено;
		ИнтернетПоддержкаПользователейКлиентСервер.ОтобразитьСостояниеПодключенияИПП(Форма);
		Оповестить("ИнтернетПоддержкаОтключена");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
