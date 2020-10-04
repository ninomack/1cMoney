////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки РегламентированнаяОтчетность (БРО).
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Объявление библиотеки.

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "РегламентированнаяОтчетность";
	Описание.Версия = "1.1.7.17";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий обновления информационной базы.

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.УправлениеОбработчиками = Истина;
	Обработчик.Версия = "*";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБРО.ЗаполнитьОбработчикиРазделенныхДанных";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Версия = "*";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ОчиститьВнешниеРеглОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
	Обработчик.НачальноеЗаполнение = Истина;
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "0.0.0.1";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	//Обработчик.НачальноеЗаполнение = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "0.0.0.1";
	//Обработчик.Процедура = "Документы.РегламентированныйОтчет.НазначитьНомераПачекОтчетовПФР";
	//Обработчик.НачальноеЗаполнение = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "0.0.0.1";
	//Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ЗаполнитьРеквизитыПриПереходе20";
	//Обработчик.НачальноеЗаполнение = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.23";
	//Обработчик.Процедура = "Документы.ТранспортноеСообщение.ОбновитьСвойстваТранспортныхСообщений";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.24";
	//Обработчик.Процедура = "Справочники.УчетныеЗаписиДокументооборота.ЗаполнениеРеквизитовУчетныхЗаписейПриОбновлении";
	//Обработчик.НачальноеЗаполнение = Истина;
	// Конец ДЕНЬГИ
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.29";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиНаРегламентированныеОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.41";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.41";
	//Обработчик.Процедура = "Справочники.ДокументыРеализацииПолномочийНалоговыхОрганов.ОбновитьДокументыРеализацииПолномочийНалоговыхОрганов";
	//Обработчик.НачальноеЗаполнение = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.43";  
	//Обработчик.Процедура = "Справочники.ОтправкиФСС.ЗаполнитьНовыеПоляОтправкиФСС";
	//Обработчик.НачальноеЗаполнение = Истина;
	// Конец ДЕНЬГИ
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.47";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПересозданныеНеразделенныеРегистры";
	//Обработчик.НачальноеЗаполнение = Истина;
	//Обработчик.ОбщиеДанные = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.48";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	// Конец ДЕНЬГИ
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.52";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.58";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ПереносДанныхЭДОПриОбновлении10158";
	// Конец ДЕНЬГИ
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.58";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
	// Конец ДЕНЬГИ
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.60";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.УдалитьСкрытыеОтчетыИзРегистраСведений";
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.60";
	//Обработчик.Процедура = "Документы.РегламентированныйОтчет.НазначитьНомераПачекОтчетовПФР";
	//	
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.3.1";
	//Обработчик.Процедура = "РегламентированнаяОтчетность.ОбновитьОтправкиПослеЗаменыПредопределенныхЗначенийДляФСРАР";
	//		
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.5.1";
	//Обработчик.Процедура = "Справочники.УчетныеЗаписиДокументооборота.ЗадатьДляУчетныхЗаписейИспользованиеСервисаОнлайнПроверки";
	//		
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.8.1";
	//Обработчик.Процедура = "РегистрыСведений.СтатусыОтправки.ЗаполнитьСтатусыОтправкиДляФССиФСРАР";
	//Обработчик.НачальноеЗаполнение = Истина;
	// Конец ДЕНЬГИ
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.14.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ОбновитьРеквизитВидОбменаСКонтролирующимиОрганамиСправочникаОрганизации";
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.1";
	//Обработчик.Процедура = "Справочники.ОписиИсходящихДокументовВНалоговыеОрганы.ОбновитьНаименованиеВсехОписейИсходящихДокументов";
	// Конец ДЕНЬГИ
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.2";
	//Обработчик.Процедура = "ДокументооборотСКОВызовСервера.ЗаполнитьРегистрЖурналОтправокВКонтролирующиеОрганы";
	//Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление информации в форме 1С-Отчетность во всех разделах, кроме Отчеты. До завершения выполнения данные в форме 1С-Отчетность могут отображаться некорректно'");
	// Конец ДЕНЬГИ
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.2";
	//Обработчик.Процедура = "РегламентированнаяОтчетностьВызовСервера.ЗаполнитьРегистрЖурналОчетовСтатусы";
	//Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление информации в форме 1С-Отчетность в разделе Отчеты. До завершения выполнения данные в форме 1С-Отчетность могут отображаться некорректно'");
	// Конец ДЕНЬГИ
	
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.2";
	//Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ОбновитьНаименование";
	//Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление наименования загруженных отчетов.'");
	// Конец ДЕНЬГИ
			
	// ДЕНЬГИ
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.3";
	//Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	//Обработчик.НачальноеЗаполнение = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.5.1";
	//Обработчик.Процедура = "ДокументооборотСКО.УстановитьРасписаниеРегламентногоЗаданияАвтоматическогоОбмена";
	//Обработчик.НачальноеЗаполнение = Ложь;
	//Обработчик.ОбщиеДанные = Истина;
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.5.5";
	//Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ПереименоватьОтправкиНаПолучениеПатентаВЖурнале";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.5.5";
	//Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ОбновитьНаименованияПредопределенныхЭлементов";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.1";
	//Обработчик.Процедура = "Справочники.СканированныеДокументыДляПередачиВЭлектронномВиде.ЗаполнитьНовыеРеквизиты";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.1";
	//Обработчик.Процедура = "Справочники.СканированныеДокументыДляПередачиВЭлектронномВидеПрисоединенныеФайлы.ВыполнитьНачальноеЗаполнение";
	//Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Преобразуются файлы избражений сканированных документов, предназначенных для отправки в ФНС. 
	//|До завершения обработки рекомендуется воздержаться от формирования и отправки документов в ответ на требование о представлении документов в ФНС'");
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.1";
	//Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЗаполнитьРегистрДокументыПоТребованиюФНС";
	//Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Комментарий = НСтр("ru = 'Заполняются данные единого списка документов для представления в ФНС. 
	//|До завершения обработки рекомендуется воздержаться от формирования и отправки документов в ответ на требование о представлении документов в ФНС'");
	//	
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.2";
	//Обработчик.Процедура = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.ИсправитьНекорректныеСостоянияОтправок2НДФЛ";
	//Обработчик.НачальноеЗаполнение = Ложь;
	//		
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.7";
	//Обработчик.Процедура = "Справочники.ЭлектронныеПредставленияРегламентированныхОтчетов.ПеренестиРеквизитВидОтчета";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.6.7";
	//Обработчик.Процедура = "Справочники.ЦиклыОбмена.ПеренестиРеквизитВидОтчета";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.7.6";
	//Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьИменаОтчетов";
	//Обработчик.НачальноеЗаполнение = Ложь;
	// Конец ДЕНЬГИ
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.17";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.17";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.17";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	
	// ДЕНЬГИ
	// 	ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ПриДобавленииОбработчиковОбновления(Обработчики);
	// Конец ДЕНЬГИ

КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. описание этой же процедуры в модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	// Не используется в БРО.
	
КонецПроцедуры

// Заполняет обработчик разделенных данных, зависимый от изменения неразделенных данных (Обработчик.Версия = "*" поддерживается).
//
// Параметры:
//   Обработчики - ТаблицаЗначений, Неопределено - см. описание 
//    функции НоваяТаблицаОбработчиковОбновления общего модуля 
//    ОбновлениеИнформационнойБазы..
//    В случае прямого вызова (не через механизм обновления 
//    версии ИБ) передается Неопределено.
// 
Процедура ЗаполнитьОбработчикиРазделенныхДанных(Параметры = Неопределено) Экспорт
	
	Если Параметры <> Неопределено Тогда
		Обработчики = Параметры.РазделенныеОбработчики;
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти