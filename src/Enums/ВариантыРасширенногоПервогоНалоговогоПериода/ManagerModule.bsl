#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Определяет дату начала налогового периода с учетом даты регистрации организации (требований ст. 55 НК РФ). Налоговый
// период может быть расширен или отсутствовать, если организация зарегистрирована в конце обычного периода (например,
// 30 декабря). Налоговый период может быть сокращен, если организация зарегистрирована не в конце обычного периода
// (например, 10 января).
//
// Параметры:
//  Организация                              - СправочникСсылка.Организации - организация, для которой определяется
//                                             дата начала налогового периода;
//  Период                                   - Дата - дата в периоде, начало которого определяется;
//  ВариантРасширенногоПервогоПериода        - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода -
//                                             проверяемый вариант требований закона;
//  СтандартнаяДлительностьНалоговогоПериода - ПеречислениеСсылка.Периодичность - длительность налогового периода;
//  СокращатьНалоговыйПериод                 - Булево - Ложь, если для совместимости важно, чтобы дата регистрации
//                                                      возвращалась только для расширенного периода (не сокращенного),
//                                                      при этом ст. 55 будет выполнена в неполном объеме);
//                                                      Истина, если требуется выполнение ст. 55 в части сокращения
//                                                      периода.
//  ДатаРегистрации                          - Дата - дата регистрации организации;
//                                             если не передана, определяется из свойств организации.
//  ДатаПостановкиНаУчет                     - Дата - дата постановки на учет в качестве налогоплательщика;
//
// Возвращаемое значение (варианты):
//  Дата         - дата начала налогового периода;
//  Неопределено - в этом периоде обязанностей налогоплательщика у организации нет.
// 
Функция НачалоНалоговогоПериода(Организация, Период, ВариантРасширенногоПервогоПериода,
	Знач СтандартнаяДлительностьНалоговогоПериода = Неопределено, СокращатьНалоговыйПериод = Истина,
	Знач ДатаРегистрации = Неопределено, Знач ДатаПостановкиНаУчет = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтандартнаяДлительностьНалоговогоПериода) Тогда
		СтандартнаяДлительностьНалоговогоПериода
		= СтандартнаяДлительностьНалоговогоПериода(ВариантРасширенногоПервогоПериода);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(СтандартнаяДлительностьНалоговогоПериода) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачалоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
		СтандартнаяДлительностьНалоговогоПериода, Период);
	
	Если ДатаРегистрации = Неопределено Тогда
		ДатаРегистрации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ДатаРегистрации");
	КонецЕсли;
	
	Если ДатаПостановкиНаУчет = Неопределено Или ДатаПостановкиНаУчет < ДатаРегистрации Тогда
		ДатаПостановкиНаУчет = ДатаРегистрации;
	КонецЕсли;
	
	НачалоПервогоНалоговогоПериода = ?(ПервыйНалоговыйПериодНачинаетсяСДатыПостановкиНаУчет(ВариантРасширенногоПервогоПериода), ДатаПостановкиНаУчет, ДатаРегистрации);
	Если НЕ ЗначениеЗаполнено(НачалоПервогоНалоговогоПериода) Тогда
		Возврат НачалоПериода;
	КонецЕсли;
	
	Если Период < НачалоПервогоНалоговогоПериода Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ОрганизацияЗарегистрированаВПредыдущемПериоде(НачалоПериода, НачалоПервогоНалоговогоПериода, СтандартнаяДлительностьНалоговогоПериода) Тогда
		
		ПропущенныйПериод = ПропущенныйНалоговыйПериод(ВариантРасширенногоПервогоПериода, Организация, ДатаРегистрации, ДатаПостановкиНаУчет);
		Если НЕ ЗначениеЗаполнено(ПропущенныйПериод) Тогда
			Если СокращатьНалоговыйПериод И НачалоПериода < НачалоПервогоНалоговогоПериода Тогда
				// Первый налоговый период начинается с даты регистрации (постановки на учет в качестве налогоплательщика).
				НачалоПериода = НачалоПервогоНалоговогоПериода;
			КонецЕсли;
		ИначеЕсли НачалоПериода = ПропущенныйПериод Тогда
			// Этот период организация пропускает.
			НачалоПериода = Неопределено;
		ИначеЕсли НачалоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.ДобавитьПериод(
			ПропущенныйПериод, СтандартнаяДлительностьНалоговогоПериода) Тогда
			// Первый налоговый период (следующий за пропущенным) - расширенный.
			НачалоПериода = НачалоПервогоНалоговогоПериода;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НачалоПериода;
	
КонецФункции

// Определяет границы ближайшего налогового периода с учетом даты регистрации (постановки на учет в качестве налогоплательщика).
//
// Параметры:
//  Организация                              - СправочникСсылка.Организации - организация, для которой определяются
//                                             границы ближайшего налогового периода;
//  Период                                   - Дата - дата в периоде, границы которого определяются;
//  ВариантРасширенногоПервогоПериода        - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода -
//                                             проверяемый вариант требований закона;
//  СтандартнаяДлительностьНалоговогоПериода - ПеречислениеСсылка.Периодичность - длительность налогового периода.
//  ДатаРегистрации                          - Дата - дата регистрации организации;
//                                             если не передана, определяется из свойств организации.
//  ДатаПостановкиНаУчет                     - Дата - дата постановки на учет в качестве налогоплательщика;
//
// Возвращаемое значение:
//  Структура - границы периода
//    * Период - Дата - стандартное начало налогового периода (например, 01 июля для третьего квартала);
//    * Начало - Дата - фактическое начало налогового периода (может совпадать со стандартным началом или
//               датой регистрации организации;
//    * Конец  - Дата - дата с указанием времени.
// 
Функция БлижайшийНалоговыйПериод(Организация, Знач ПроверяемыйПериод, ВариантРасширенногоПервогоПериода,
	Знач СтандартнаяДлительностьНалоговогоПериода = Неопределено, Знач ДатаРегистрации = Неопределено, Знач ДатаПостановкиНаУчет = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Период", '0001-01-01');
	Результат.Вставить("Начало", '0001-01-01');
	Результат.Вставить("Конец",  '0001-01-01');
	
	Если НЕ ЗначениеЗаполнено(СтандартнаяДлительностьНалоговогоПериода) Тогда
		СтандартнаяДлительностьНалоговогоПериода
		= СтандартнаяДлительностьНалоговогоПериода(ВариантРасширенногоПервогоПериода);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтандартнаяДлительностьНалоговогоПериода) Тогда
		СтандартнаяДлительностьНалоговогоПериода = Перечисления.Периодичность.Год;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ДатаРегистрации = '0001-01-01';
	КонецЕсли;
	
	Если ДатаРегистрации = Неопределено Тогда
		ДатаРегистрации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ДатаРегистрации");
	КонецЕсли;
	
	Если ДатаПостановкиНаУчет = Неопределено Или ДатаПостановкиНаУчет < ДатаРегистрации Тогда
		ДатаПостановкиНаУчет = ДатаРегистрации;
	КонецЕсли;
	
	НачалоПервогоНалоговогоПериода = ?(ПервыйНалоговыйПериодНачинаетсяСДатыПостановкиНаУчет(ВариантРасширенногоПервогоПериода), ДатаПостановкиНаУчет, ДатаРегистрации);
	
	Если ПроверяемыйПериод < НачалоПервогоНалоговогоПериода Тогда
		ПроверяемыйПериод = НачалоПервогоНалоговогоПериода;
	КонецЕсли;
	
	НачалоПроверяемогоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
		СтандартнаяДлительностьНалоговогоПериода, ПроверяемыйПериод);
	
	Если ОрганизацияЗарегистрированаВПредыдущемПериоде(НачалоПроверяемогоПериода, НачалоПервогоНалоговогоПериода, СтандартнаяДлительностьНалоговогоПериода) Тогда
		
		Результат.Период = НачалоПроверяемогоПериода;
		Результат.Начало = НачалоПроверяемогоПериода;
		
	Иначе
		
		ПропущенныйПериод = ПропущенныйНалоговыйПериод(ВариантРасширенногоПервогоПериода, Организация, НачалоПервогоНалоговогоПериода);
		
		Если ЗначениеЗаполнено(ПропущенныйПериод) Тогда
			
			// Первый налоговый период - следующий за периодом регистрации (постановки на учет в качестве налогоплательщика), он расширенный.
			Результат.Период = НачалоСледующегоПериода(НачалоПервогоНалоговогоПериода, СтандартнаяДлительностьНалоговогоПериода);
			Результат.Начало = НачалоПервогоНалоговогоПериода;
			
		ИначеЕсли НачалоПроверяемогоПериода <= НачалоПервогоНалоговогоПериода Тогда
			
			// Это первый налоговый период, он начинается с даты регистрации (постановки на учет в качестве налогоплательщика).
			Результат.Период = НачалоПроверяемогоПериода;
			Результат.Начало = НачалоПервогоНалоговогоПериода;
			
		Иначе
			
			// Это не первый налоговый период, дата регистрации (постановки на учет в качестве налогоплательщика) уже не имеет значения.
			Результат.Период = НачалоПроверяемогоПериода;
			Результат.Начало = НачалоПроверяемогоПериода;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.Конец = ИнтерфейсыВзаимодействияБРОКлиентСервер.КонецПериода(
		СтандартнаяДлительностьНалоговогоПериода, Результат.Период);
	
	Возврат Результат;
	
КонецФункции

// Определяет стандартную длительность налогового периода по переданному варианту периода регистрации организации.
//
// Параметры:
//  ВариантРасширенногоПервогоПериода - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода - вариант
//                                      требований закона.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.Периодичность - длительность периода; пустая ссылка, если установить не удалось.
//
Функция СтандартнаяДлительностьНалоговогоПериода(Вариант) Экспорт
	
	Если Вариант = РегистрацияВДекабре Тогда
		Возврат Перечисления.Периодичность.Год;
	ИначеЕсли Вариант = РегистрацияВПоследние10ДнейКвартала Тогда
		Возврат Перечисления.Периодичность.Квартал;
	ИначеЕсли Вариант = РегистрацияВПоследнемКвартале Тогда
		Возврат Перечисления.Периодичность.Год;
	ИначеЕсли Вариант = МесяцПостановкиНаУчет Тогда
		Возврат Перечисления.Периодичность.Месяц;
	Иначе
		Возврат Перечисления.Периодичность.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Определяет налоговый период, относящийся к дате регистрации (постановки на учет), пропускаемый для целей уплаты налогов
// (представления отчетов). Требования установлены ст. 55 НК РФ и п. 3 ст. 15 закона "О бухгалтерском учете".
//
// Например, если организация зарегистрирована в конце года, то некоторую отчетность за этот год она не представляет
// (и некоторые налоги не платит), а показатели деятельности за период с даты регистрации до конца следующего года
// включает в отчетность за следующий год. Таким образом, первый налоговый период у организации может быть длинее,
// чем последующие (т.е., может быть "расширенным").
//
// Другими словами, если дата регистрации попадает в определенные периоды, то не требуется представлять отчетность
// и/или уплачивать налоги за эти периоды.
//
// Законом определены несколько вариантов периодов, в зависимости от даты регистрации организации.
//
// Параметры:
//  Вариант         - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода - вариант требований закона;
//  Организация     - СправочникСсылка.Организации - организация, для которой определяется пропущенный период;
//  ДатаРегистрации - Дата - дата регистрации организации; если не передана, определяется из свойств организации;
//  ДатаПостановкиНаУчет - Дата - дата постановки на учет в качестве налогоплательщика;
//
// Возвращаемое значение (варианты):
//  Дата         - дата начала пропущенного периода;
//  Неопределено - нет оснований для пропуска периода.
//
Функция ПропущенныйНалоговыйПериод(Вариант, Организация, Знач ДатаРегистрации = Неопределено, Знач ДатаПостановкиНаУчет = Неопределено) Экспорт
	
	// ДЕНЬГИ
	Возврат Неопределено;
	// Конец ДЕНЬГИ	
	
КонецФункции

// Определяет, что не требуется сдавать отчетность и уплачивать налог за переданный период.
//
// Параметры:
//  Организация                       - СправочникСсылка.Организации - проверяемая организация
//  Период                            - Дата - проверяемый период
//  ВариантРасширенногоПервогоПериода - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода - вариант требований закона;
//  ДатаРегистрации                   - Дата - дата регистрации организации; если не передана, определяется из свойств организации;
//  ДатаПостановкиНаУчет              - Дата - дата постановки на учет в качестве налогоплательщика;
//
// Возвращаемое значение:
//   Булево   - Если ИСТИНА, это пропущенный период
//              (организация зарегистрирована в декабре переданного года, и для нее актуальны требования п.2 статьи 55 НК РФ).
//
Функция НалоговыйПериодПропущен(Организация, Период, ВариантРасширенногоПервогоПериода, Знач ДатаРегистрации = Неопределено, Знач ДатаПостановкиНаУчет = Неопределено) Экспорт
	
	ПропущенныйПериод = ПропущенныйНалоговыйПериод(
		ВариантРасширенногоПервогоПериода,
		Организация,
		ДатаРегистрации,
		ДатаПостановкиНаУчет);
	
	Если ПропущенныйПериод = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтандартнаяДлительностьНалоговогоПериода = СтандартнаяДлительностьНалоговогоПериода(ВариантРасширенногоПервогоПериода);
	
	НачалоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
		СтандартнаяДлительностьНалоговогоПериода,
		Период);
	
	НачалоПропущенногоПериода = ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
		СтандартнаяДлительностьНалоговогоПериода,
		ПропущенныйПериод);
	
	НалоговыйПериодПропущен = (НачалоПериода = НачалоПропущенногоПериода);
	
	Возврат НалоговыйПериодПропущен;
	
КонецФункции

// Определяет какой период расширяется в соответствии с выбранным вариантом.
// 
// Параметры:
//  ВариантРасширенногоПервогоПериода - ПеречислениеСсылка.ВариантыРасширенногоПервогоНалоговогоПериода - вариант требований закона;
//
// Возвращаемое значение:
//  Истина - расширяемый налоговый период начинается с даты постановки на учет в качестве налогоплательщика;
//  Ложь - расширяемый налоговый период начинается с даты регистрации организации.
//
Функция ПервыйНалоговыйПериодНачинаетсяСДатыПостановкиНаУчет(ВариантРасширенногоПервогоПериода) Экспорт
	
	Возврат (ВариантРасширенногоПервогоПериода = МесяцПостановкиНаУчет);
	
КонецФункции

Функция ОрганизацияЗарегистрированаВПредыдущемПериоде(НачалоПроверяемогоПериода, НачалоПервогоНалоговогоПериода, СтандартнаяДлительностьНалоговогоПериода)
	
	Если НЕ ЗначениеЗаполнено(НачалоПервогоНалоговогоПериода) Тогда
		// Если дата регистрации (постановки на учет в качестве налогоплательщика) неизвестна,
		// нельзя достоверно определить границы налогового периода.
		Возврат Истина;
	КонецЕсли;
		
	Возврат НачалоСледующегоПериода(НачалоПервогоНалоговогоПериода, СтандартнаяДлительностьНалоговогоПериода) < НачалоПроверяемогоПериода;

КонецФункции

Функция НачалоСледующегоПериода(Период, СтандартнаяДлительностьНалоговогоПериода)
	
	СледующийПериод = ИнтерфейсыВзаимодействияБРОКлиентСервер.ДобавитьПериод(
		Период, СтандартнаяДлительностьНалоговогоПериода);
	
	Возврат ИнтерфейсыВзаимодействияБРОКлиентСервер.НачалоПериода(
		СтандартнаяДлительностьНалоговогоПериода, СледующийПериод);
	
КонецФункции

#КонецОбласти

#КонецЕсли