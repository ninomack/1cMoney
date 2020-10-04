
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает строковое представление параметров расписания
//
// Параметры:
//	ПараметрыРасписания - РегистрСведенийМенеджерЗаписи.Расписания
//
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеРасписания(ПараметрыРасписания, ПроизвольныеДатыРасписания = Неопределено) Экспорт

	ОписаниеРасписания = "";
	
	Если ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.Ежедневно") Тогда
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Ежедневно'");
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждый %1-й день'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, ПараметрыРасписания.ПорядокПериодов);
		КонецЕсли; 
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.Еженедельно") Тогда
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Еженедельно в %1'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели));
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждую %1-ю неделю в %2'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокПериодов, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели));
		КонецЕсли; 
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ЕжемесячноПоЧислам") Тогда
		СтрокаЧисел        = СтрЗаменить(ПараметрыРасписания.ШаблонЧиселМесяца, ",", "");
		СуффиксЧислаМесяца = ?(СтрНайти(",30,31,", "," + СтрокаЧисел + ",") > 0, НСтр("ru = ' (или в последн. день месяца)'") , "");
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Ежемесячно %1 числа'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											СтрокаЧисел);
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждый %1-й месяц %2 числа'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокПериодов, 
											СтрокаЧисел);
		КонецЕсли;
		ОписаниеРасписания = ОписаниеРасписания + СуффиксЧислаМесяца;
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ЕжемесячноПоДнямНедели") Тогда
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Ежемесячно в %1-й(ю) %2'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокДнейНедели, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели));
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждый %1-й месяц в %2-й(ю) %3'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокПериодов, 
											ПараметрыРасписания.ПорядокДнейНедели, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели));
		КонецЕсли;
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ЕжегодноПоЧислам") Тогда
		СтрокаЧисел        = СтрЗаменить(ПараметрыРасписания.ШаблонЧиселМесяца, ",", "");
		СуффиксЧислаМесяца = ?(СтрНайти(",29,30,31,", "," + СтрокаЧисел + ",") > 0 и ПараметрыРасписания.ШаблонНомеровМесяцев = "2,", 
					НСтр("ru = ' (или в последн. день месяца)'") , "");
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Ежегодно %1 %2'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											СтрокаЧисел, 
											ПреобразоватьШаблонНомеровМесяцев(ПараметрыРасписания.ШаблонНомеровМесяцев));
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждый %1-й год %2 %3'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокПериодов, 
											СтрЗаменить(ПараметрыРасписания.ШаблонЧиселМесяца, ",", ""), 
											ПреобразоватьШаблонНомеровМесяцев(ПараметрыРасписания.ШаблонНомеровМесяцев));
		КонецЕсли;
		ОписаниеРасписания = ОписаниеРасписания + СуффиксЧислаМесяца;
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ЕжегодноПоДнямНедели") Тогда
		Если ПараметрыРасписания.ПорядокПериодов = 1 Тогда
			ОписаниеРасписания = НСтр("ru = 'Ежегодно в %1-й(ю) %2 %3'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокДнейНедели, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели),
											ПреобразоватьШаблонНомеровМесяцев(ПараметрыРасписания.ШаблонНомеровМесяцев));
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Каждый %1-й год в %2-й(ю) %3 %4'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, 
											ПараметрыРасписания.ПорядокПериодов, 
											ПараметрыРасписания.ПорядокДнейНедели, 
											ПреобразоватьШаблонДнейНедели(ПараметрыРасписания.ШаблонДнейНедели),
											ПреобразоватьШаблонНомеровМесяцев(ПараметрыРасписания.ШаблонНомеровМесяцев));
		КонецЕсли;
		
	ИначеЕсли ПараметрыРасписания.Периодичность = ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ВУказанныеДаты") Тогда
		СтрокаДат = "";
		Если ЗначениеЗаполнено(ПроизвольныеДатыРасписания) Тогда
			Счетчик = 5;
			ОстатокДат = ПроизвольныеДатыРасписания.Количество() - Счетчик;
			Для Каждого СтрокаДаты Из ПроизвольныеДатыРасписания Цикл
				СтрокаДат = СтрокаДат + ", " + Формат(СтрокаДаты.ПлановаяДата, "ДФ=дд.ММ.гг");
				Счетчик = Счетчик - 1;
				Если Счетчик = 0 Тогда
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			Если ОстатокДат > 0 Тогда
				СтрокаДат = СтрокаДат + НСтр("ru = ' и еще %1 дат'");
				СтрокаДат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаДат, ОстатокДат);
			КонецЕсли; 
			ОписаниеРасписания = НСтр("ru = 'По указанным датам'") + ": " + Сред(СтрокаДат, 3);
		Иначе
			ОписаниеРасписания = НСтр("ru = 'Даты не указаны'");
		КонецЕсли; 
		
	Иначе
		ОписаниеРасписания = НСтр("ru = 'Не задано'") ;
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПараметрыРасписания.Периодичность) 
		И ПараметрыРасписания.Периодичность <> ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.ВУказанныеДаты") 
		И ПараметрыРасписания.Периодичность <> ПредопределенноеЗначение("Перечисление.СпособыПовторовСобытий.НеИспользовать") Тогда
		Если ЗначениеЗаполнено(ПараметрыРасписания.КоличествоПовторов) Тогда
			ОписаниеРасписания = ОписаниеРасписания + ". " + НСтр("ru = 'Повторить %1 раз'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, ПараметрыРасписания.КоличествоПовторов);
		ИначеЕсли ЗначениеЗаполнено(ПараметрыРасписания.ДатаОкончанияРасписания) Тогда
			ОписаниеРасписания = ОписаниеРасписания + ". " + НСтр("ru = 'Прекратить %1'");
			ОписаниеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеРасписания, Формат(ПараметрыРасписания.ДатаОкончанияРасписания, "ДФ='дд.ММ.гггг ""г""'") );
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат ОписаниеРасписания;
	
КонецФункции

// Обновляет реквизит формы о связи операции с расписанием ее шаблона
//
// Параметры:
//	Форма - УправляемаяФорма - форма операции, из которой вызывается процедура
//	
Процедура ОбновитьИнформациюОСвязиОперацииСРасписанием(Форма) Экспорт
	
	Элементы   = Форма.Элементы;
	
	// Информация о связи операции с шаблоном (если она предусмотрена)
	Если Элементы.Найти("ИнформацияОШаблоне") <> Неопределено Тогда
		Если ЗначениеЗаполнено(Форма.ЗаписьОперацииШаблона.Шаблон) Тогда
			
			ПланДата = Формат(Форма.ЗаписьОперацииШаблона.ПлановаяДата, "Л=ru_RU; ДФ=dd.MM.yyyy");
			
			Если Форма.ЗаписьОперацииШаблона.Шаблон = Форма.ЗаписьОперацииШаблона.Операция Тогда
				
				Форма.ИнформацияОШаблоне = НСтр("ru = 'Запланирована на %1 без шаблона'");
				Форма.ИнформацияОШаблоне = СтрШаблон(Форма.ИнформацияОШаблоне, ПланДата);
				
			Иначе
				
				Если ЗначениеЗаполнено(Форма.ЗаписьПлановойОперации.ВладелецРасписания) Тогда
					
					Форма.ИнформацияОШаблоне = НСтр("ru = 'Запланирована на %1 по шаблону %2'");
					Форма.ИнформацияОШаблоне = СтрШаблон(Форма.ИнформацияОШаблоне, ПланДата, Форма.ЗаписьОперацииШаблона.Шаблон);
					
				Иначе
					
					Форма.ИнформацияОШаблоне = НСтр("ru = 'Без расписания по шаблону %1'");
					Форма.ИнформацияОШаблоне = СтрШаблон(Форма.ИнформацияОШаблоне, Форма.ЗаписьОперацииШаблона.Шаблон);
					
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе
			Форма.ИнформацияОШаблоне = НСтр("ru = '<без шаблона>'");
		КонецЕсли; 
		Элементы.ИнформацияОШаблоне.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры
 
// Возвращает строковое представление условий и графика погашения долга
//
// Параметры:
//	ПараметрыГрафика    - РегистрСведенийМенеджерЗаписи.ПараметрыГрафикаПогашенияДолгов, ДанныеФормыСтруктура, 
//						  Структура - см. функция ПлановыеОперацииКлиентСервер.СтруктураПараметровГрафикаПогашенияДолга
//	ПараметрыРасписания - РегистрСведенийМенеджерЗаписи.Расписания, ДанныеФормыСтруктура, 
//						  Структура - см. функция ПлановыеОперацииКлиентСервер.СтруктураПараметровРасписания
//
// Возвращаемое значение:
//  Строка
//
// Пример использования:
//		СтруктураПараметрыГрафика    = ПлановыеОперацииКлиентСервер.СтруктураПараметровГрафикаПогашенияДолга();
//		СтруктураПараметрыРасписания = ПлановыеОперацииКлиентСервер.СтруктураПараметровРасписания();
//		ЗаполнитьЗначенияСвойств(СтруктураПараметрыГрафика, ЭтаФорма.ПараметрыГрафика);
//		ЗаполнитьЗначенияСвойств(СтруктураПараметрыРасписания, ЭтаФорма.ПараметрыРасписания);
//		ТекстГрафикаПогашения = ПлановыеОперацииКлиентСервер.ПредставлениеУсловийДолга(СтруктураПараметрыГрафика, СтруктураПараметрыРасписания);
//
Функция ПредставлениеУсловийДолга(ПараметрыГрафика, ПараметрыРасписания, ВыводитьСуммуДолга = Истина) Экспорт
	
	СпособПогашенияЗаполнен = ЗначениеЗаполнено(ПараметрыГрафика.СпособПогашения);
	Представление = "";
	
	Если ВыводитьСуммуДолга И СпособПогашенияЗаполнен И ЗначениеЗаполнено(ПараметрыГрафика.СуммаДолга) Тогда
		Представление = Представление + "; " + Формат(ПараметрыГрафика.СуммаДолга, ?(ПараметрыГрафика.СуммаДолга % 1 = 0, "ЧДЦ=0; ЧН=0", "ЧДЦ=2")) + " " + ПараметрыГрафика.Долг.Валюта;
	КонецЕсли;
	
	Представление = Представление + "; " + ?(НЕ ЗначениеЗаполнено(ПараметрыГрафика.ПроцентнаяСтавка), НСтр("ru = 'Без процентов'"), Формат(ПараметрыГрафика.ПроцентнаяСтавка, "ЧДЦ=2") + " " + НСтр("ru = '% годовых'"));
	
	Если СпособПогашенияЗаполнен Тогда
		Если ЗначениеЗаполнено(ПараметрыГрафика.ПлановаяДатаПогашения) Тогда
			Представление = Представление + "; " + НСтр("ru = 'До'") + " " + Формат(ПараметрыГрафика.ПлановаяДатаПогашения, "ДФ='дд.ММ.гггг'");
		ИначеЕсли ЗначениеЗаполнено(ПараметрыГрафика.СрокМесяцев) Тогда
			МесяцПрописью = ЧислоПрописью(ПараметрыГрафика.СрокМесяцев, "Л = ru_RU; НД = Ложь", "месяц,месяца,месяцев,м,,,,,0");
			МесяцПрописью = Сред(МесяцПрописью, Найти(ВРег(МесяцПрописью), "МЕСЯЦ"));
			Представление = Представление + "; " + НСтр("ru = 'На'") + " " + Формат(ПараметрыГрафика.СрокМесяцев, "ЧДЦ=0; ЧГ=") + " " + МесяцПрописью;
		Иначе
			Представление = Представление + "; " + ?(ЗначениеЗаполнено(ПараметрыРасписания.ДатаОкончанияРасписания), 
				НСтр("ru = 'До'") + " " + Формат(ПараметрыРасписания.ДатаОкончанияРасписания, "ДФ='дд.ММ.гггг'") , НСтр("ru = 'Без срока'"));
		КонецЕсли; 
		
		Представление = Представление + "; " + Строка(ПараметрыГрафика.СпособПогашения);
		
		Если СпособПогашенияЗаполнен И ЗначениеЗаполнено(ПараметрыГрафика.ДеньМесяцаДляРасчетов) 
			И (ПараметрыГрафика.СпособПогашения = ПредопределенноеЗначение("Перечисление.СпособыПогашенияКредита.Аннуитет")
				ИЛИ ПараметрыГрафика.СпособПогашения = ПредопределенноеЗначение("Перечисление.СпособыПогашенияКредита.ДифференцированныеПлатежи")) Тогда
			ТекстЧисла = НСтр("ru = 'Платить каждое %1-е число месяца'");
			ТекстЧисла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЧисла, Формат(ПараметрыГрафика.ДеньМесяцаДляРасчетов, "ЧЦ=2; ЧДЦ=0") );
			Представление = Представление + "; " + ТекстЧисла;
		КонецЕсли; 
		
	Иначе
		Представление = Представление + "; " + НСтр("ru = 'Без срока'");
		
	КонецЕсли;
	
	Возврат Сред(Представление, 3);
	
КонецФункции

Функция СтруктураПараметровРасписания() Экспорт
	
	Возврат Новый Структура(
	"ВладелецРасписания,
	|ДатаНачалаРасписания,
	|ДатаОкончанияРасписания,
	|КоличествоПовторов,
	|Периодичность,
	|ПорядокПериодов,
	|ПорядокДнейНедели,
	|ШаблонДнейНедели,
	|ШаблонЧиселМесяца,
	|ШаблонНомеровМесяцев,
	|Завершено,
	|ОписаниеРасписания,
	|СуммаДохода,
	|ВалютаДохода,
	|СуммаРасхода,
	|ВалютаРасхода,
	|СуммаДолга,
	|СуммаПроцентов,
	|СуммаКомиссии");
	
КонецФункции

Функция СтруктураПараметровГрафикаПогашенияДолга() Экспорт
	
	Возврат Новый Структура(
	"Долг,
	|ШаблонОперации,
	|ДатаВозникновенияДолга,
	|ПроцентнаяСтавка,
	|СтатьяДляУчетаПроцентов,
	|СпособПогашения,
	|КошелекДляПогашения,
	|СрокМесяцев,
	|ПлановаяДатаПогашения,
	|СуммаЕдиноразовойКомиссии,
	|СтатьяЕдиноразовойКомиссии,
	|СуммаЕжемесячнойКомиссии,
	|СтатьяЕжемесячнойКомиссии,
	|ДеньМесяцаДляРасчетов,
	|ДнейВГоду,
	|НеПересчитыватьПриРедактировании,
	|ДатаЗакрытияДолга");
	
КонецФункции

// Возвращает сумму процентов за период, рассчитанную пропорционально количеству дней пользования кредитом/займом в каждом году периода.
// За первый день проценты не начисляются, за последний - начисляются, как за полный день.
//
Функция СуммаПроцентовЗаПериод(База, ПроцентнаяСтавка, НачалоПериода, КонецПериода) Экспорт

	Если НЕ ЗначениеЗаполнено(НачалоПериода) ИЛИ НЕ ЗначениеЗаполнено(КонецПериода) ИЛИ НачалоПериода > КонецПериода Тогда
		ВызватьИсключение "Неверные параметры";
	КонецЕсли;
	
	Если База = 0 ИЛИ ПроцентнаяСтавка = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	
	СуммаПроцентовВГод = База * ПроцентнаяСтавка / 100;
	
	ГодНачалаПериода    = Год(НачалоПериода);
	ГодОкончанияПериода = Год(КонецПериода);
	
	Если ГодНачалаПериода = ГодОкончанияПериода Тогда
		
		ДнейВГоду      = ДеньГода(КонецГода(КонецПериода));
		СрокДолгаВДнях = ДеньГода(КонецПериода) - ДеньГода(НачалоПериода);
		СуммаПроцентов = СуммаПроцентовВГод * СрокДолгаВДнях / ДнейВГоду;
		
	Иначе
		
		// Сумма процентов за первый год
		ДнейВГоду      = ДеньГода(КонецГода(НачалоПериода));
		СрокДолгаВДнях = ДнейВГоду - ДеньГода(НачалоПериода);
		СуммаПроцентов = СуммаПроцентовВГод * СрокДолгаВДнях / ДнейВГоду;
		
		// + Сумма процентов за последний год
		ДнейВГоду      = ДеньГода(КонецГода(КонецПериода));
		СрокДолгаВДнях = ДеньГода(КонецПериода);
		СуммаПроцентов = СуммаПроцентов + СуммаПроцентовВГод * СрокДолгаВДнях / ДнейВГоду;
		
		// + Сумма процентов за промежуточные годы
		СуммаПроцентов = СуммаПроцентов + СуммаПроцентовВГод * Макс(0, ГодОкончанияПериода - ГодНачалаПериода - 1);
		
	КонецЕсли;
	
	Возврат СуммаПроцентов;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заменяет в строке номера дней недели на их наименования в винительном падеже
//
Функция ПреобразоватьШаблонДнейНедели(Знач СтрокаШаблона)

	Результат = СокрЛП(СтрокаШаблона);
	Результат = СтрЗаменить(Результат, "1,", НСтр("ru = 'понедельник'") + ", ");
	Результат = СтрЗаменить(Результат, "2,", НСтр("ru = 'вторник'") + ", ");  
	Результат = СтрЗаменить(Результат, "3,", НСтр("ru = 'среду'") + ", ");
	Результат = СтрЗаменить(Результат, "4,", НСтр("ru = 'четверг'") + ", ");
	Результат = СтрЗаменить(Результат, "5,", НСтр("ru = 'пятницу'") + ", ");
	Результат = СтрЗаменить(Результат, "6,", НСтр("ru = 'субботу'") + ", ");
	Результат = СтрЗаменить(Результат, "7,", НСтр("ru = 'воскресенье'") + ", ");  
	Если Прав(Результат, 2) = ", " Тогда
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 2);
	КонецЕсли; 
	
	Возврат Результат;

КонецФункции

// Заменяет в строке номера месяцев на их наименования в родительном падеже
//
Функция ПреобразоватьШаблонНомеровМесяцев(Знач СтрокаШаблона)

	Результат = СокрЛП(СтрокаШаблона);
	Результат = СтрЗаменить(Результат, "10,", НСтр("ru = 'октября'") + ", ");
	Результат = СтрЗаменить(Результат, "11,", НСтр("ru = 'ноября'") + ", ");
	Результат = СтрЗаменить(Результат, "12,", НСтр("ru = 'декабря'") + ", ");
	Результат = СтрЗаменить(Результат, "1,", НСтр("ru = 'января'") + ", ");
	Результат = СтрЗаменить(Результат, "2,", НСтр("ru = 'февраля'") + ", ");  
	Результат = СтрЗаменить(Результат, "3,", НСтр("ru = 'марта'") + ", ");
	Результат = СтрЗаменить(Результат, "4,", НСтр("ru = 'апреля'") + ", ");
	Результат = СтрЗаменить(Результат, "5,", НСтр("ru = 'мая'") + ", ");
	Результат = СтрЗаменить(Результат, "6,", НСтр("ru = 'июня'") + ", ");
	Результат = СтрЗаменить(Результат, "7,", НСтр("ru = 'июля'") + ", ");
	Результат = СтрЗаменить(Результат, "8,", НСтр("ru = 'августа'") + ", ");
	Результат = СтрЗаменить(Результат, "9,", НСтр("ru = 'сентября'") + ", ");
	Если Прав(Результат, 2) = ", " Тогда
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 2);
	КонецЕсли; 
	
	Возврат Результат;

КонецФункции
