////////////////////////////////////////////////////////////////////////////////
// РаботаСФормамиДокументов: общий функционал по обслуживанию форм операций
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В зависимости от значения ЭтоШаблон добавляет/удаляет командные элементы и реквизиты
Процедура ПодготовитьФормуНаСервереПоРаботеСШаблонами(Форма, Параметры = Неопределено)	Экспорт

	Объект     = Форма.Объект;
	Элементы   = Форма.Элементы;
	Параметры  = ?(Параметры= Неопределено, Форма.Параметры, Параметры);
	Команды    = Форма.Команды;
	
	ТекДатаСеанса = ТекущаяДатаСеанса();
	
	ЗначенияЗаполнения = Неопределено;
	Если Объект.Ссылка.Пустая() И Параметры.Свойство("ЗначенияЗаполнения", ЗначенияЗаполнения) И ТипЗнч(ЗначенияЗаполнения) = Тип("Структура") Тогда
		
		ЭтоШаблон = Неопределено;
		Если ЗначенияЗаполнения.Свойство("ЭтоШаблон", ЭтоШаблон) И ЭтоШаблон <> Неопределено Тогда
			Объект.ЭтоШаблон        = ЭтоШаблон;
			Объект.ОписаниеОперации = ?(Объект.ЭтоШаблон И НЕ ЗначениеЗаполнено(Объект.ОписаниеОперации), НСтр("ru = 'Новый шаблон'"), "");
		КонецЕсли; 
		
		Если Объект.ЭтоШаблон Тогда
			
			// Заполняется шаблон:
			Описание = "";
			Если ЗначенияЗаполнения.Свойство("ОписаниеОперации", Описание) И Описание <> Неопределено Тогда
				Объект.ОписаниеОперации = Описание;
			КонецЕсли; 
			
		Иначе
			
			// Заполняется обычный документ:
			Дата = Неопределено;
			Если ЗначенияЗаполнения.Свойство("Дата", Дата) И ЗначениеЗаполнено(Дата) Тогда
				Объект.Дата = Дата;
			Иначе
				
				ТипДатыНовойОперации = ПользовательскиеНастройкиДеньгиСервер.ТипДатыНовойОперации();
				Если ТипДатыНовойОперации = "ИзПоследнейОперации" И ЗначениеЗаполнено(ПараметрыСеанса.ДатаПоследнейОперации) Тогда
					Объект.Дата = НачалоДня(ПараметрыСеанса.ДатаПоследнейОперации) + (ТекДатаСеанса - НачалоДня(ТекДатаСеанса));
				Иначе
					Объект.Дата = ТекДатаСеанса;
				КонецЕсли;
				
			КонецЕсли; 
			
			ТипОбъекта = ТипЗнч(Объект.Ссылка);
			Если ТипОбъекта = Тип("ДокументСсылка.МыВернулиДолг") И Объект.Ссылка.Пустая() Тогда
				ЗаполнитьДокументМыВернулиДолг(Объект, ЗначенияЗаполнения);
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	// Функционал по работе с плановыми операциями
	Если ДеньгиКлиентСервер.ПолучитьРеквизитФормы("ПараметрыРасписания", Форма) <> Неопределено Тогда
		
		Если Объект.ЭтоШаблон  Тогда
			
			// Получим параметры расписания
			МенеджерЗаписи = РегистрыСведений.Расписания.СоздатьМенеджерЗаписи();
			ПлановаяДата   = Неопределено;
			Параметры.Свойство("ПлановаяДата", ПлановаяДата);
			Если Объект.Ссылка.Пустая() Тогда
				ПлановыеОперации.ЗаполнитьСтруктуруРасписанияЗначениямиПоУмолчанию(МенеджерЗаписи, ПлановаяДата);
				Форма.СохранитьРасписание = ЗначениеЗаполнено(ПлановаяДата);
			Иначе
				МенеджерЗаписи.ВладелецРасписания = Объект.Ссылка;
				МенеджерЗаписи.Прочитать();
				Если НЕ МенеджерЗаписи.Выбран() Тогда
					ПлановыеОперации.ЗаполнитьСтруктуруРасписанияЗначениямиПоУмолчанию(МенеджерЗаписи, ПлановаяДата);
				КонецЕсли;
			КонецЕсли;
			 
			ЗаполнитьЗначенияСвойств(Форма.ПараметрыРасписания, МенеджерЗаписи);
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АктивностьШаблона") Тогда
				Форма.АктивностьШаблона = Не МенеджерЗаписи.НеИспользовать;
			КонецЕсли;
			
		Иначе
			
			// Новый документ может быть создан из шаблона с использованием- или без расписания;
			//	тогда в параметрах будет указан ВладелецРасписания и, возможно, дата плановой операции
			ВладелецРасписания = Неопределено;
			ПлановаяДата       = Неопределено;
			АктуальнаяДата     = Неопределено;
			Если Параметры.Свойство("ВладелецРасписания", ВладелецРасписания) Тогда
				
				Форма.ЗаписьОперацииШаблона.Шаблон = ВладелецРасписания;
				
				Если  Параметры.Свойство("ПлановаяДата", ПлановаяДата) Тогда
					
					Форма.ЗаписьПлановойОперации.ВладелецРасписания   = ВладелецРасписания;
					Форма.ЗаписьПлановойОперации.ПлановаяДата         = ПлановаяДата;
					Параметры.Свойство("АктуальнаяДата", АктуальнаяДата);
					Форма.ЗаписьПлановойОперации.АктуальнаяДата = ?(ЗначениеЗаполнено(АктуальнаяДата), АктуальнаяДата, ПлановаяДата);
					
					Если ЗначениеЗаполнено(Форма.ЗаписьПлановойОперации.ВладелецРасписания) И ЗначениеЗаполнено(Форма.ЗаписьПлановойОперации.ПлановаяДата) Тогда
						ЗаписьРегистра = РегистрыСведений.ДатыРасписаний.СоздатьМенеджерЗаписи();
						ЗаполнитьЗначенияСвойств(ЗаписьРегистра, Форма.ЗаписьПлановойОперации, "ВладелецРасписания, ПлановаяДата");
						ЗаписьРегистра.Прочитать();
						Если ЗаписьРегистра.Выбран() Тогда
							ЗаполнитьЗначенияСвойств(Форма.ЗаписьПлановойОперации, ЗаписьРегистра);
							ПлановаяДата   = ?(ЗначениеЗаполнено(ПлановаяДата), ПлановаяДата, Форма.ЗаписьПлановойОперации.ПлановаяДата);
							АктуальнаяДата = ?(ЗначениеЗаполнено(АктуальнаяДата), АктуальнаяДата, Форма.ЗаписьПлановойОперации.АктуальнаяДата)
						КонецЕсли; 
					КонецЕсли; 
					
					Форма.Объект.Дата = ?(ЗначениеЗаполнено(АктуальнаяДата), АктуальнаяДата, Форма.Объект.Дата);
					Если Форма.Объект.Дата = НачалоДня(Форма.Объект.Дата) Тогда
						Форма.Объект.Дата = Форма.Объект.Дата + (ТекущаяДатаСеанса() - НачалоДня(ТекущаяДатаСеанса()));
					КонецЕсли;
					
					Форма.ЗаписьОперацииШаблона.ПлановаяДата = ПлановаяДата
					
				КонецЕсли;
				
			ИначеЕсли НЕ Объект.Ссылка.Пустая() Тогда
				
				// Записанная в базу операция могла быть создана по шаблону с использованием- или без расписания
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ПлановаяОперация", Объект.Ссылка);
				Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ОперацииШаблонов.Шаблон,
				|	ОперацииШаблонов.Операция КАК Операция,
				|	ДатыРасписаний.ВладелецРасписания,
				|	ЕСТЬNULL(ДатыРасписаний.ПлановаяДата, ДАТАВРЕМЯ(1, 1, 1)) КАК ПлановаяДата,
				|	ЕСТЬNULL(ДатыРасписаний.АктуальнаяДата, ДАТАВРЕМЯ(1, 1, 1)) КАК АктуальнаяДата,
				|	ДатыРасписаний.Пропустить,
				|	ДатыРасписаний.СуммаДолга,
				|	ДатыРасписаний.СуммаПроцентов,
				|	ДатыРасписаний.СуммаКомиссии,
				|	ДатыРасписаний.ПлановаяОперация
				|ИЗ
				|	РегистрСведений.ОперацииШаблонов КАК ОперацииШаблонов
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыРасписаний КАК ДатыРасписаний
				|		ПО ОперацииШаблонов.Шаблон = ДатыРасписаний.ВладелецРасписания
				|			И ОперацииШаблонов.Операция = ДатыРасписаний.ПлановаяОперация
				|			И ОперацииШаблонов.ПлановаяДата = ДатыРасписаний.ПлановаяДата
				|ГДЕ
				|	ОперацииШаблонов.Операция = &ПлановаяОперация
				|
				|УПОРЯДОЧИТЬ ПО
				|	Операция,
				|	ПлановаяДата,
				|	АктуальнаяДата";
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					Форма.ЗаписьОперацииШаблона.Шаблон   = Выборка.Шаблон;
					Форма.ЗаписьОперацииШаблона.Операция = Выборка.Операция;
					Если ЗначениеЗаполнено(Выборка.ВладелецРасписания) Тогда
						ЗаполнитьЗначенияСвойств(Форма.ЗаписьПлановойОперации, Выборка, 
									"ВладелецРасписания,ПлановаяДата,АктуальнаяДата,Пропустить,СуммаДолга,СуммаПроцентов,СуммаКомиссии,ПлановаяОперация");
						Форма.ЗаписьОперацииШаблона.ПлановаяДата = Форма.ЗаписьПлановойОперации.ПлановаяДата;
					КонецЕсли; 
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЕсли;
	КонецЕсли; 

	Если Объект.ЭтоШаблон Тогда
		
		Если Элементы.Найти("ГруппаДатаОписание") = Неопределено Тогда
			Если Элементы.Найти("ГруппаШапкиДата") <> Неопределено Тогда
				Элементы.ГруппаШапкиДата.Видимость = Ложь;
			ИначеЕсли Элементы.Найти("ГруппаДатаИнформацияОРасписании") <> Неопределено Тогда
				Элементы.ГруппаДатаИнформацияОРасписании.Видимость = Ложь;
			Иначе
				Элементы.Дата.Видимость = Ложь;
			КонецЕсли; 
			Если Элементы.Найти("ГруппаШапкиОписание") <> Неопределено Тогда
				Элементы.ГруппаШапкиОписание.Видимость = Истина;
			КонецЕсли; 
			Если Элементы.Найти("ГруппаПараметрыШаблона") <> Неопределено Тогда
				Элементы.ГруппаПараметрыШаблона.Видимость = Истина;
			КонецЕсли; 
		Иначе
			Элементы.ГруппаДатаОписание.ТекущаяСтраница = Элементы.ГруппаСтраницаОписание;
		КонецЕсли; 
		Если Элементы.Найти("ФормаПроведение") <> Неопределено Тогда
			Элементы.ФормаПроведение.Видимость = Ложь;
		КонецЕсли; 
		Если Элементы.Найти("ФормаПровести") <> Неопределено Тогда
			Элементы.ФормаПровести.Видимость = Ложь;
		КонецЕсли; 
		
		Элементы.ПредставлениеФайлов.Видимость = Ложь;
		
	Иначе
		Если Элементы.Найти("ГруппаДатаОписание") = Неопределено Тогда
			Если Элементы.Найти("ГруппаШапкиДата") <> Неопределено Тогда
				Элементы.ГруппаШапкиДата.Видимость = Истина;
			ИначеЕсли Элементы.Найти("ГруппаДатаИнформацияОРасписании") <> Неопределено Тогда
				Элементы.ГруппаДатаИнформацияОРасписании.Видимость = Истина;
			Иначе
				Элементы.Дата.Видимость = Истина;
			КонецЕсли; 
			Если Элементы.Найти("ГруппаШапкиОписание") <> Неопределено Тогда
				Элементы.ГруппаШапкиОписание.Видимость = Истина;
			КонецЕсли; 
			Если Элементы.Найти("ГруппаПараметрыШаблона") <> Неопределено Тогда
				Элементы.ГруппаПараметрыШаблона.Видимость = Истина;
			КонецЕсли; 
		Иначе
			Элементы.ГруппаДатаОписание.ТекущаяСтраница = Элементы.ГруппаСтраницаОписание;
		КонецЕсли; 
		Если Элементы.Найти("ГруппаШапкиОписание") <> Неопределено Тогда
			Элементы.ГруппаШапкиОписание.Видимость = Ложь;
		КонецЕсли; 
		Если Элементы.Найти("ГруппаПараметрыШаблона") <> Неопределено Тогда
			Элементы.ГруппаПараметрыШаблона.Видимость = Ложь;
		КонецЕсли;
		Если Элементы.Найти("Дата") <> Неопределено Тогда
			Элементы.Дата.КнопкаРегулирования = Истина;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

// Общие для всех операций настройки, выполняемые при создании формы на сревере
Процедура ФормаДокументаПриСозданииНаСервере(Форма) Экспорт

	Если ДеньгиВызовСервераПовтИсп.ИспользуетсяВариантИнтерфейсаТакси() Тогда
		СпособОткрытияФормОбъектов    = ПользовательскиеНастройкиДеньгиСервер.СпособОткрытияФорм();
		Если СпособОткрытияФормОбъектов = 1 Тогда
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Иначе
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

// Перезаполняет документ по указанному шаблону и обновляет его форму
Процедура ОбновитьФормуОперацииПоШаблону(Форма, ШаблонОперации) Экспорт

	Форма.Модифицированность = Истина;
	
	Объект     = Форма.Объект;
	Элементы   = Форма.Элементы;
	
	Параметры  = Новый Структура;
	Параметры.Вставить("ВладелецРасписания", ШаблонОперации);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВладелецРасписания", ШаблонОперации);
	Запрос.УстановитьПараметр("ПлановаяДата", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("ТекущаяОперация", Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Даты.ПлановаяДата,
	|	ДатыРасписаний.АктуальнаяДата
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(ДатыРасписаний.ПлановаяДата) КАК ПлановаяДата,
	|		ДатыРасписаний.ВладелецРасписания КАК ВладелецРасписания
	|	ИЗ
	|		РегистрСведений.ДатыРасписаний КАК ДатыРасписаний
	|	ГДЕ
	|		ДатыРасписаний.ВладелецРасписания = &ВладелецРасписания
	|		И (ДатыРасписаний.ПлановаяОперация = &ТекущаяОперация
	|				ИЛИ ДатыРасписаний.ПлановаяДата <= &ПлановаяДата
	|					И ДатыРасписаний.Пропустить = ЛОЖЬ
	|					И ЕСТЬNULL(ДатыРасписаний.ПлановаяОперация.Проведен, ЛОЖЬ) = ЛОЖЬ)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДатыРасписаний.ВладелецРасписания) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыРасписаний КАК ДатыРасписаний
	|		ПО Даты.ВладелецРасписания = ДатыРасписаний.ВладелецРасписания
	|			И Даты.ПлановаяДата = ДатыРасписаний.ПлановаяДата";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Параметры.Вставить("ПлановаяДата", Выборка.ПлановаяДата);
		Параметры.Вставить("АктуальнаяДата", Выборка.ПлановаяДата);
	Иначе
		Параметры.Вставить("ПлановаяДата", Объект.Дата);
		Параметры.Вставить("АктуальнаяДата", Объект.Дата);
	КонецЕсли; 
	
	МетаданныеДокумента = ШаблонОперации.Метаданные();
	ОбъектФормы = Форма.РеквизитФормыВЗначение("Объект");
	ЗаполнитьЗначенияСвойств(ОбъектФормы, ШаблонОперации, "", "Ссылка, Дата, ЭтоШаблон, Пользователь, ОписаниеОперации");
	Для Каждого ТабЧасть Из МетаданныеДокумента.ТабличныеЧасти Цикл
		ОбъектФормы[ТабЧасть.Имя].Очистить();
		ОбъектФормы[ТабЧасть.Имя].Загрузить(ШаблонОперации[ТабЧасть.Имя].Выгрузить());
	КонецЦикла; 
	Форма.ЗначениеВРеквизитФормы(ОбъектФормы, "Объект");
	
	Параметры.Вставить("ЗначениеЗаполнения", Новый Структура("ЭтоШаблон, Дата", Ложь, Объект.Дата));
	ПодготовитьФормуНаСервереПоРаботеСШаблонами(Форма, Параметры);

КонецПроцедуры

// Приводит значение субконто к типу субконто заданного счетом
//	Если счет пустой - заполняет его значением по умолчанию
Процедура ПроверитьТипСубконто(Субконто, Счет, ЗначениеСчетаПоУмолчанию = Неопределено, ЭтоРасход = Истина) Экспорт

	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Счет = ?(ЗначениеСчетаПоУмолчанию = Неопределено, ПланыСчетов.РазделыУчета.СвободныеДеньги, ЗначениеСчетаПоУмолчанию);
	КонецЕсли; 

	Если Счет = ПланыСчетов.РазделыУчета.Капитал Тогда
		ТипСубконто = Новый ОписаниеТипов(?(ЭтоРасход, "СправочникСсылка.СтатьиРасходов", "СправочникСсылка.СтатьиДоходов"));
	Иначе
		СвойстваСчета= РазделыУчетаПовтИсп.ПолучитьСвойстваСчета(Счет);
		ТипСубконто = СвойстваСчета.ВидСубконто1ТипЗначения;
	КонецЕсли; 
	
	Если НЕ ТипСубконто.СодержитТип(ТипЗнч(Субконто)) Тогда
		Субконто = ТипСубконто.ПривестиЗначение(Субконто);
	КонецЕсли; 
	
КонецПроцедуры

// Устраняет проблемы пересечения отборов с настройками пользователей в стандартных списках документов
Процедура ФормаСпискаДокументовОбработатьПараметрыОтбора(Форма, ИмяСписка, ОписаниеОтбора = "", ОчищатьПараметрОтбор = Истина, ЭтоСписокШаблонов = Ложь) Экспорт

	Список = Форма[ИмяСписка];
	ЭтоСписокВыбора = Форма.Элементы[ИмяСписка].РежимВыбора;
	Параметры = Форма.Параметры;
	Если Параметры.Отбор.Количество() > 0 ИЛИ ЭтоСписокВыбора Тогда
		Форма.КлючНазначенияИспользования = "ОтборПоПолученнымПараметрам";
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
	КонецЕсли; 
	
	ОтборСписка = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	Если ОтборСписка <> Неопределено Тогда
		
		Для Каждого ЭлементОтбора Из Параметры.Отбор Цикл
			Если ЭлементОтбора.Ключ = "Проведен" И НЕ ЭтоСписокШаблонов Тогда
				Продолжить;
			КонецЕсли; 
			Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда
				СписокЭлементаОтбора = Новый СписокЗначений;
				СписокЭлементаОтбора.ЗагрузитьЗначения(Новый Массив(ЭлементОтбора.Значение));
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, ЭлементОтбора.Ключ, СписокЭлементаОтбора, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
			Иначе
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, ЭлементОтбора.Ключ, ЭлементОтбора.Значение, ВидСравненияКомпоновкиДанных.Равно, , Истина);
			КонецЕсли; 
		КонецЦикла; 
		
		//Если ЭтоСписокВыбора И ЭтоСписокШаблонов И НЕ Параметры.Отбор.Свойство("Проведен") Тогда
		//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		//КонецЕсли; 
		
		ОписаниеОтбора = Строка(ОтборСписка);
		ОписаниеОтбора = ?(ПустаяСтрока(ОписаниеОтбора), НСтр("ru = 'не установлен'"), ОтборСписка);
		
		Если ОчищатьПараметрОтбор = Истина Тогда
			Параметры.Отбор.Очистить();
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

// Устанавливает стандартное условное оформление для формы списка справочника:
//	Активность, ПометкаУдаления, поля сумм и валют, и т.д.
//Параметры:
//	Форма		    - <УправляемаяФорма>, для которой устанавливается условное оформление
//	ИмяСписка	    - <Строка>, имя реквизита формы, являющегося списком.
//	ПрефиксСтандартныхКолонок - <Строка>, префикс, которым нужно предворять имена элементов-колонок списка 
//	ПоляСуммы       - <Структура>, в которой Ключ = имя поля суммы, значение = структура или массив с именами полей, 
//						в которых нужно очищать текст при нулвом значении суммы
//	ЭтоСписокШаблонов - <Булево> - признак списка шаблонов операций
Процедура УстановитьУсловноеОформлениеФормыСписка(Форма, ИмяСписка, ПрефиксСтандартныхКолонок = "", ПоляСуммы = Неопределено, Очищать = Истина, ЭтоСписокШаблонов = Ложь) Экспорт

	УсловноеОформление = Форма.УсловноеОформление;
	Элементы = Форма.Элементы;
	Если Очищать Тогда
		УсловноеОформление.Элементы.Очистить();
	КонецЕсли; 
	
	СтандартныйШрифт = Элементы[ИмяСписка].Шрифт;
	
	Если ЭтоСписокШаблонов Тогда
		// Актуальность
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяСписка);

		ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(ИмяСписка + ".Активность");
		ЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение  = Ложь;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Иначе
		// Проведение
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяСписка);

		ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(ИмяСписка + ".Проведен");
		ЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение  = Ложь;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	КонецЕсли; 
	
	// Пометка удаления
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяСписка);

	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(ИмяСписка + ".ПометкаУдаления");
	ЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение  = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(СтандартныйШрифт, , , , , , Истина));
	
	// Условное оформление для сумм и валют:
	Если ПоляСуммы <> Неопределено Тогда
		Для Каждого ПолеСуммы Из ПоляСуммы Цикл
			
			// очищаем текст для суммы и валюты если сумма не заполнена
			Элемент = УсловноеОформление.Элементы.Добавить();

			Если ЗначениеЗаполнено(ПолеСуммы.Значение) Тогда
				Для Каждого ЭлементПоляСуммы Из ПолеСуммы.Значение Цикл
					ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
					ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементПоляСуммы);
				КонецЦикла; 
			Иначе
				ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
				ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяСписка);
			КонецЕсли; 

			ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(ИмяСписка + "." + ПолеСуммы.Ключ);
			ЭлементОтбора.ВидСравнения    = ВидСравненияКомпоновкиДанных.НеЗаполнено;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
			
		КонецЦикла; 
	КонецЕсли; 
	

КонецПроцедуры

// Устанавливает значение параметра ВыбраннаяФорма в зависимости от наличия и содержимого отбора
Процедура ОпределитьФормуСпискаДляВыбора(Тип, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт

	ПараметрыОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", ПараметрыОтбора) И ТипЗнч(ПараметрыОтбора) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Отбор.Вставить("Тип", Тип);
		Если ПараметрыОтбора.Свойство("ЭтоШаблон") И ПараметрыОтбора.ЭтоШаблон = Истина Тогда
			ВыбраннаяФорма = "ЖурналДокументов.ОбщийЖурналДокументов.Форма.ФормаВыбораШаблона";
		Иначе
			ВыбраннаяФорма = "ЖурналДокументов.ОбщийЖурналДокументов.Форма.ФормаВыбораОперации";
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

// Обновляет информационную надпись об остатке в указанном объекте учета
//
//Параметры:
//	Форма - управляемая форма, на которой нужно обновить остаток
//	ИмяПоля - Строка - наименование элемента формы (декорации), отображающего остаток
//	РазделУчета - ПланСчетовСсылка.РазделыУчета - ссылка на счет, по которому нужно получить остаток
//	ОбъектУчета - Субконто - ссылка на субконто (объект учета), для которого нужно получить остаток
//	ИмяРеквизитаОстатка - Строка - Наименование реквизита формы, в который нужно поместить остаток
//
Процедура ОбновитьОстатокПоОбъектуУчета(Форма, ИмяЭлемента, РазделУчета, ОбъектУчета, ИмяРеквизитаОстатка = Неопределено, 
					ФинЦель = Неопределено, ИмяЭлементаФинцели = Неопределено, ИмяРеквизитаОстаткаФинцели = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ИмяЭлемента) Тогда 
		Возврат;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(РазделУчета) 
		ИЛИ НЕ ЗначениеЗаполнено(ОбъектУчета) Тогда
		
		// Если не указаны раздел/объект учета, остаток будет обнулен
		Остаток = 0;
		ТекстОстатка   = НСтр("ru = 'Остаток неизвестен'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ТекстПодсказки = НСтр("ru = 'Не заполнено поле, по которому можно рассчитать остаток'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЦветОстатка    = ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
		
	Иначе
		
		ВалютаОстатка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектУчета, "Валюта");
		ТипОбъекта = ТипЗнч(ОбъектУчета);
		ЕстьФинцель = ТипОбъекта = Тип("СправочникСсылка.КошелькиИСчета") И ЗначениеЗаполнено(ФинЦель)
				И Не ОбъектУчета.ЭтоГруппа И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектУчета, "ИспользоватьДляНакоплений");
		
		Если Форма.Объект.Проведен И НЕ Форма.Модифицированность Тогда
			
			// Получаем остаток на конец операции и остаток на конец текущего дня
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Период",      Форма.Объект.Ссылка.МоментВремени());
			Запрос.УстановитьПараметр("Сегодня",     КонецДня(ТекущаяДатаСеанса()));
			Запрос.УстановитьПараметр("РазделУчета", РазделУчета);
			Запрос.УстановитьПараметр("ОбъектУчета", ОбъектУчета);
			Если ТипОбъекта = Тип("СправочникСсылка.Долги") Тогда
				Запрос.УстановитьПараметр("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконто.Долги);
			Иначе
				Запрос.УстановитьПараметр("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконто.КошелькиИСчета);
			КонецЕсли; 
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЖурналОперацийОстаткиИОбороты.Период,
			|	ЖурналОперацийОстаткиИОбороты.ВалютнаяСуммаНачальныйОстаток,
			|	ЖурналОперацийОстаткиИОбороты.ВалютнаяСуммаКонечныйОстаток
			|ИЗ
			|	РегистрБухгалтерии.ЖурналОпераций.ОстаткиИОбороты(&Период, &Период, Регистратор, ДвиженияИГраницыПериода, Счет В ИЕРАРХИИ (&РазделУчета), &ВидСубконто, Субконто1 В ИЕРАРХИИ (&ОбъектУчета)) КАК ЖурналОперацийОстаткиИОбороты
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СУММА(жОстатки.ВалютнаяСуммаОстаток) КАК ВалютнаяСуммаОстаток
			|ИЗ
			|	РегистрБухгалтерии.ЖурналОпераций.Остатки(&Сегодня, Счет В ИЕРАРХИИ (&РазделУчета), &ВидСубконто, Субконто1 В ИЕРАРХИИ (&ОбъектУчета)) КАК жОстатки";
			
			Если ЕстьФинцель Тогда
				Запрос.УстановитьПараметр("ФинЦель", ФинЦель);
				Запрос.Текст = Запрос.Текст + Символы.ПС + 
				";
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ЖурналОперацийОстаткиИОбороты.Период,
				|	ЖурналОперацийОстаткиИОбороты.ВалютнаяСуммаНачальныйОстаток,
				|	ЖурналОперацийОстаткиИОбороты.ВалютнаяСуммаКонечныйОстаток
				|ИЗ
				|	РегистрБухгалтерии.ЖурналОпераций.ОстаткиИОбороты(
				|			&Период,
				|			&Период,
				|			Регистратор,
				|			ДвиженияИГраницыПериода,
				|			Счет В ИЕРАРХИИ (&РазделУчета),
				|			,
				|			Субконто1 В ИЕРАРХИИ (&ОбъектУчета)
				|				И Субконто2 = &Финцель) КАК ЖурналОперацийОстаткиИОбороты
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	СУММА(жОстатки.ВалютнаяСуммаОстаток) КАК ВалютнаяСуммаОстаток
				|ИЗ
				|	РегистрБухгалтерии.ЖурналОпераций.Остатки(
				|			&Сегодня,
				|			Счет В ИЕРАРХИИ (&РазделУчета),
				|			,
				|			Субконто1 В ИЕРАРХИИ (&ОбъектУчета)
				|				И Субконто2 = &Финцель) КАК жОстатки";
				
			КонецЕсли;
			
			ПакетРезультатов = Запрос.ВыполнитьПакет();
			Выборка = ПакетРезультатов[0].Выбрать();
			Если Выборка.Следующий() Тогда
				ОстатокДоОперации       = Выборка.ВалютнаяСуммаНачальныйОстаток;
				ОстатокПослеОперации    = Выборка.ВалютнаяСуммаКонечныйОстаток;
			Иначе
				ОстатокДоОперации       = 0;
				ОстатокПослеОперации    = 0;
			КонецЕсли; 
			
			Выборка = ПакетРезультатов[1].Выбрать();
			Если Выборка.Следующий() Тогда
				ОстатокНаСегодня    = Выборка.ВалютнаяСуммаОстаток;
			Иначе
				ОстатокНаСегодня    = 0;
			КонецЕсли; 
			
			// В форму будет выведен остаток на конец операции, в подсказке - оба остатка
			ВидОперации = ТипЗнч(Форма.Объект.Ссылка);
			Если ВидОперации = Тип("ДокументСсылка.Перемещение") Тогда
				ТекстОстатка   = НСтр("ru = 'Остаток до перевода: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ТекстПодсказки = НСтр("ru = '  Остаток до перевода денег: %1 %2
											|Остаток на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ИначеЕсли ВидОперации = Тип("ДокументСсылка.ОбменВалюты") Тогда
				ТекстОстатка = НСтр("ru = 'Остаток до обмена: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ТекстПодсказки = НСтр("ru = '   Остаток до обмена валюты: %1 %2
											|Остаток на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ИначеЕсли ВидОперации = Тип("ДокументСсылка.Расход") Тогда
				ТекстОстатка = НСтр("ru = 'Остаток до оплаты: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ТекстПодсказки = НСтр("ru = '   Остаток до оплаты расходов: %1 %2
											|  Остаток на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			Иначе
				ТекстОстатка = НСтр("ru = 'Остаток до операции: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ТекстПодсказки = НСтр("ru = '   Остаток до учета операции: %1 %2
											| Остаток на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			КонецЕсли; 
			
			ОстатокСтрокой = Формат(ОстатокДоОперации, "ЧДЦ=2; ЧН=0,00");
			ТекстОстатка   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОстатка, ОстатокСтрокой, ВалютаОстатка);
			ЦветОстатка = ?(ОстатокДоОперации >= 0, ЦветаСтиля.ИнформационнаяНадписьЦвет, ЦветаСтиля.ЦветОтрицательногоЧисла);
			
			ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказки, 
									ОстатокСтрокой, ВалютаОстатка,
									Формат(ОстатокНаСегодня, "ЧДЦ=2; ЧН=0,00"));
			
			Если ИмяРеквизитаОстатка <> Неопределено Тогда
				// Сохраним сумму остатка в указанный реквизит формы
				Форма[ИмяРеквизитаОстатка] = ОстатокПослеОперации;
			КонецЕсли; 
			
			// Остаток по финансовой цели
			Если ЕстьФинцель Тогда
				
				Выборка = ПакетРезультатов[2].Выбрать();
				Если Выборка.Следующий() Тогда
					ОстатокДоОперации       = Выборка.ВалютнаяСуммаНачальныйОстаток;
					ОстатокПослеОперации    = Выборка.ВалютнаяСуммаКонечныйОстаток;
				Иначе
					ОстатокДоОперации       = 0;
					ОстатокПослеОперации    = 0;
				КонецЕсли; 
				
				Выборка = ПакетРезультатов[3].Выбрать();
				Если Выборка.Следующий() Тогда
					ОстатокНаСегодня    = Выборка.ВалютнаяСуммаОстаток;
				Иначе
					ОстатокНаСегодня    = 0;
				КонецЕсли; 
				
				// В форму будет выведен остаток на конец операции, в подсказке - оба остатка
				Если ВидОперации = Тип("ДокументСсылка.Перемещение") Тогда
					ТекстОстаткаФинцели   = НСтр("ru = 'Накоплений до перевода: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
					ТекстПодсказкиФинцели = НСтр("ru = '  Накоплений до перевода денег: %1 %2
												|Накоплений на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ИначеЕсли ВидОперации = Тип("ДокументСсылка.ОбменВалюты") Тогда
					ТекстОстаткаФинцели = НСтр("ru = 'Накоплений до обмена: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
					ТекстПодсказкиФинцели = НСтр("ru = '   Накоплений до обмена валюты: %1 %2
												|Накоплений на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ИначеЕсли ВидОперации = Тип("ДокументСсылка.Расход") Тогда
					ТекстОстаткаФинцели = НСтр("ru = 'Накоплений до оплаты: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
					ТекстПодсказкиФинцели = НСтр("ru = '   Накоплений до оплаты расходов: %1 %2
												|  Накоплений на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				Иначе
					ТекстОстаткаФинцели = НСтр("ru = 'Накоплений до операции: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
					ТекстПодсказкиФинцели = НСтр("ru = '   Накоплений до учета операции: %1 %2
												| Накоплений на сегодняшний день: %3 %2 '", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				КонецЕсли; 
				
				ОстатокСтрокой = Формат(ОстатокДоОперации, "ЧДЦ=2; ЧН=0,00");
				ТекстОстаткаФинцели   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОстаткаФинцели, ОстатокСтрокой, ВалютаОстатка);
				ЦветОстаткаФинцели = ?(ОстатокДоОперации >= 0, ЦветаСтиля.ИнформационнаяНадписьЦвет, ЦветаСтиля.ЦветОтрицательногоЧисла);
				
				ТекстПодсказкиФинцели = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПодсказкиФинцели, 
										ОстатокСтрокой, ВалютаОстатка,
										Формат(ОстатокНаСегодня, "ЧДЦ=2; ЧН=0,00"));
				
				Если ИмяРеквизитаОстаткаФинцели <> Неопределено Тогда
					// Сохраним сумму остатка в указанный реквизит формы
					Форма[ИмяРеквизитаОстаткаФинцели] = ОстатокПослеОперации;
				КонецЕсли; 
			КонецЕсли;
			
		Иначе
			
			// Получаем остаток на конец текущего дня
			Остаток = РазделыУчета.ПолучитьОстатокПоСубконто(РазделУчета, ОбъектУчета, КонецДня(ТекущаяДатаСеанса()));
			
			ТекстОстатка = НСтр("ru = 'Остаток на сегодня: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ТекстОстатка   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОстатка, Формат(Остаток, "ЧДЦ=2; ЧН=0,00"), ВалютаОстатка);
			ЦветОстатка = ?(Остаток >= 0, ЦветаСтиля.ИнформационнаяНадписьЦвет, ЦветаСтиля.ЦветОтрицательногоЧисла);
			
			ТекстПодсказки = НСтр("ru = 'Остаток на сегодняшний день'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			
			Если ИмяРеквизитаОстатка <> Неопределено Тогда
				// Сохраним сумму остатка в указанный реквизит формы
				Форма[ИмяРеквизитаОстатка] = Остаток;
			КонецЕсли; 
			
			Если ЗначениеЗаполнено(ФинЦель) Тогда
				
				Остаток = РазделыУчета.ПолучитьОстатокПоФинцели(ОбъектУчета, ФинЦель, КонецДня(ТекущаяДатаСеанса()));
				
				ТекстОстаткаФинцели = НСтр("ru = 'Накоплений на сегодня: %1 %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				ТекстОстаткаФинцели   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОстаткаФинцели, Формат(Остаток, "ЧДЦ=2; ЧН=0,00"), ВалютаОстатка);
				ЦветОстаткаФинцели = ?(Остаток >= 0, ЦветаСтиля.ИнформационнаяНадписьЦвет, ЦветаСтиля.ЦветОтрицательногоЧисла);
				
				ТекстПодсказкиФинцели = НСтр("ru = 'Накоплений на сегодняшний день'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				
				Если ИмяРеквизитаОстаткаФинцели <> Неопределено Тогда
					// Сохраним сумму остатка в указанный реквизит формы
					Форма[ИмяРеквизитаОстаткаФинцели] = Остаток;
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли; 
		
			
	КонецЕсли; 
	
	// Обновляем информацию и оформление поля
	ЭлементФормы = Форма.Элементы[ИмяЭлемента];
	ЭлементФормы.Заголовок = Новый ФорматированнаяСтрока(ТекстОстатка, , ЦветОстатка);
	ЭлементФормы.Подсказка = ТекстПодсказки;

	Если ЗначениеЗаполнено(ИмяЭлементаФинцели) Тогда
		
		ЭлементФормы = Форма.Элементы[ИмяЭлементаФинцели];
		
		Если ЗначениеЗаполнено(ТекстОстаткаФинцели) И ЕстьФинцель Тогда
			
			ЭлементФормы.Заголовок = Новый ФорматированнаяСтрока(ТекстОстаткаФинцели, , ЦветОстаткаФинцели);
			ЭлементФормы.Подсказка = ТекстПодсказкиФинцели;
			ЭлементФормы.Видимость = Истина;
			
		Иначе
			
			ЭлементФормы.Видимость = Ложь;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// Выполняет общие настройки стандартной формы списка операций.
//	Стандартная форма предполагает, что:
//		реквизит списка называется "Список" и элемент формы называется так же
//		основная таблица реквизита "Список" является таблицей документа
//		у командной панели и у контекстного меню списка отключено автозаполнение и они заполнены командами вручную (см. пример в форме списка документа "Доход")
//		форма имеет дополнительные реквизиты, необходимые для контроля отборов и проч. (см. пример в форме списка документа "Доход")
// Условное оформление форм вызывается из модуля каждой формы отдельно.
//
Процедура ФормаСпискаПриСозданииНаСервере(Форма) Экспорт
	
	Элементы  = Форма.Элементы;
	Параметры = Форма.Параметры;
	МетаданныеДокумента = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Форма.Список.ОсновнаяТаблица));
	
	// Убираем автоматический заголовок формы для корректного указания отбора по состоянию операций
	Если Форма.АвтоЗаголовок Тогда
		Форма.АвтоЗаголовок = Ложь;
		Форма.Заголовок     = ?(ЗначениеЗаполнено(МетаданныеДокумента.ПредставлениеСписка), МетаданныеДокумента.ПредставлениеСписка, МетаданныеДокумента.Синоним);
	КонецЕсли;
	
	// Проверяем режим открытия списка
	Элементы.Список.РежимВыбора      = Параметры.РежимВыбора;
	
	// Устраняем проблемы с пересечением программных и пользовательских отборов
	РаботаСФормамиДокументов.ФормаСпискаДокументовОбработатьПараметрыОтбора(Форма, "Список", "", Истина, Истина);
	
	// Устанавливаем отбор по состоянию документов
	Если Параметры.Свойство("НомерОтбораПоСостоянию") Тогда
		Форма.НомерОтбораПоСостоянию = Параметры.НомерОтбораПоСостоянию;
	Иначе
		// Задаем значение по умолчанию для отбора по состоянию
		Форма.НомерОтбораПоСостоянию = ?(Элементы.Список.РежимВыбора, 1, 0);
	КонецЕсли;
	ДеньгиКлиентСервер.УстановитьОтборСпискаОперацийПоСостояниюДокумента(Форма, Форма.НомерОтбораПоСостоянию);
	
	
КонецПроцедуры
 

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокументМыВернулиДолг(Объект, ЗначенияЗаполнения)

	// Нужно обновить курсы валют
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	Если Объект.ВалютаКредита = ВалютаУчета ИЛИ НЕ ЗначениеЗаполнено(Объект.ВалютаКредита) Тогда
		Объект.КурсВалютыКредита = 1;
		Объект.КратностьВалютыКредита = 1;
	КонецЕсли; 
	Если Объект.ВалютаКошелька = ВалютаУчета ИЛИ НЕ ЗначениеЗаполнено(Объект.ВалютаКошелька) Тогда
		Объект.КурсВалютыКошелька = 1;
		Объект.КратностьВалютыКошелька = 1;
	КонецЕсли; 
	
	СуммаДолга     = 0;
	СуммаПроцентов = 0;
	СуммаКомиссии  = 0;
	Если ЗначенияЗаполнения.Свойство("СуммаДолга", СуммаДолга) И ЗначениеЗаполнено(СуммаДолга) Тогда
		Объект.СуммаКредитаВВалютеКредита = СуммаДолга;
	КонецЕсли; 
	Если ЗначенияЗаполнения.Свойство("СуммаПроцентов", СуммаПроцентов) И ЗначениеЗаполнено(СуммаПроцентов) Тогда
		Объект.СуммаПроцентовВВалютеКредита = СуммаПроцентов;
	КонецЕсли; 
	Если ЗначенияЗаполнения.Свойство("СуммаКомиссии", СуммаКомиссии) И ЗначениеЗаполнено(СуммаКомиссии) Тогда
		СуммаКомиссии = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(СуммаКомиссии,
			Объект.ВалютаКредита, Объект.ВалютаКошелька,
			Объект.КурсВалютыКредита, Объект.КурсВалютыКошелька,
			Объект.КратностьВалютыКредита, Объект.КратностьВалютыКошелька);
		Объект.ВыплаченоКомиссии = СуммаКомиссии;
	КонецЕсли; 
	
	// Пересчитываем суммы из валюты в валюту:
	Объект.ВыплаченоКредита = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.СуммаКредитаВВалютеКредита,
			Объект.ВалютаКредита, Объект.ВалютаКошелька,
			Объект.КурсВалютыКредита, Объект.КурсВалютыКошелька,
			Объект.КратностьВалютыКредита, Объект.КратностьВалютыКошелька);
	Объект.ВыплаченоПроцентов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.СуммаПроцентовВВалютеКредита,
			Объект.ВалютаКредита, Объект.ВалютаКошелька,
			Объект.КурсВалютыКредита, Объект.КурсВалютыКошелька,
			Объект.КратностьВалютыКредита, Объект.КратностьВалютыКошелька);

КонецПроцедуры


#КонецОбласти


