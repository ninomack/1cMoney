////////////////////////////////////////////////////////////////////////////////
//Справочник.СтатьиДоходов.ФормаСписка
//  используется и для выбора и для просмотра
//  
//Параметры формы:
//  Стандартные параметры формы
//  
////////////////////////////////////////////////////////////////////////////////


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Проверяем режим открытия формы списка
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.ОтображатьКорень = Истина;
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Установка условного оформления для форм списков:
	СуммыИВалюты = Новый Структура("ОстатокДолга, ОстатокДолгаДругихПередНами, ОстатокНашегоДолгаДругим", 
			Новый Массив, Новый Массив, Новый Массив);
	СуммыИВалюты.ОстатокДолга.Добавить("ОстатокДолга");
	СуммыИВалюты.ОстатокДолга.Добавить("Валюта2");
	СуммыИВалюты.ОстатокДолгаДругихПередНами.Добавить("ОстатокДолгаДругихПередНами");
	СуммыИВалюты.ОстатокДолга.Добавить("Валюта");
	СуммыИВалюты.ОстатокНашегоДолгаДругим.Добавить("ОстатокНашегоДолгаДругим");
	СуммыИВалюты.ОстатокДолга.Добавить("Валюта1");
	РаботаСФормамиСправочников.УстановитьУсловноеОформлениеФормыСписка(ЭтотОбъект, "Список", Ложь, , СуммыИВалюты);
	
	// Перенос программно установленного отбора в пользовательские настройки:
	РаботаСФормамиСправочников.ФормаСпискаСправочникаОбработатьПараметрыОтбора(ЭтотОбъект, "Список");
	
	Если ХранилищеСистемныхНастроек.Загрузить(ЭтотОбъект.ИмяФормы + ?(КлючНазначенияИспользования = "", "", "/" + КлючНазначенияИспользования) + "/ТекущиеДанные", ) = Неопределено Тогда
		УстановитьБыстрыйОтборПоРеквизитам(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	ПриПовторномОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Записана операция" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьБыстрыйОтборПоРеквизитам(ЭтотОбъект);
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиСобытийСписка


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПриЗагрузкеПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	// Обработчики Панели ГруппаБыстрыеОтборы
	АктуализироватьЗначенияБыстрыхОтборов(Настройки);
	
КонецПроцедуры


#КонецОбласти

// Обработчики Панели ГруппаБыстрыеОтборы
#Область ГруппаБыстрыеОтборы 

&НаКлиенте
Процедура АктуальностьПриИзменении(Элемент)
	
	УстановитьБыстрыйОтборПоРеквизитам(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьБыстрыйОтборПоРеквизитам(Форма)

	ОтборСписка = Форма.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Форма.Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	
	Если ОтборСписка <> Неопределено Тогда
		
		Если Форма.Актуальность = 1 Тогда
			// Только активные
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Активность", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		ИначеЕсли Форма.Актуальность = -1 Тогда
			// Только неактивные
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Активность", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		Иначе
			// Все шаблоны
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Активность", , , , Ложь);
			
		КонецЕсли;
		
		ЭлементыОтбораКонтакт = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, "Контакт");
		Если ЭлементыОтбораКонтакт.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Контакт", , ВидСравненияКомпоновкиДанных.Равно, , Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
		КонецЕсли;
		
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	АктуализироватьЗначенияБыстрыхОтборов(Список.КомпоновщикНастроек.ПользовательскиеНастройки);
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьЗначенияБыстрыхОтборов(Настройки)

	// Восстанавливаем значения быстрых отборов, если они были
	ОтборСписка = Настройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	Если ОтборСписка <> Неопределено Тогда
		
		// "обнуляем" значения быстрого отбора:
		Актуальность        = 0;
		ОписаниеОтбора      = "";
		
		// Проверяем актуальность:
		ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, "Активность");
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если НЕ ЭлементОтбора.Использование Тогда
				Актуальность = 0;
			ИначеЕсли ЭлементОтбора.ПравоеЗначение = Ложь Тогда
				Актуальность = -1;
			Иначе
				Актуальность = 1;
			КонецЕсли; 
		КонецЦикла; 
		
		ЭлементыОтбораКонтакт = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, "Контакт");
		Если ЭлементыОтбораКонтакт.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ОтборСписка, "Контакт", , ВидСравненияКомпоновкиДанных.Равно, , Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
		КонецЕсли;
		
		ОписаниеОтбора = Строка(ОтборСписка);
		ОписаниеОтбора = ?(ПустаяСтрока(ОписаниеОтбора), НСтр("ru = 'не установлен'"), ОтборСписка);
		
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ИзменитьОстаток(Команда)
	
	СправочникСсылка = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ЗначенияЗаполнения = Новый Структура("ОбъектУчета", СправочникСсылка);
		ПараметрыДокумента = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ОткрытьФорму("Документ.ВводИзменениеОстатка.ФормаОбъекта", ПараметрыДокумента, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры



// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ПриПовторномОткрытииНаСервере()
	Элементы.Список.Обновить();
КонецПроцедуры



#КонецОбласти

