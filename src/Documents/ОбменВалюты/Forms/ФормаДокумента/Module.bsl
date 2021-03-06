&НаКлиенте
Перем ДополнительныеПараметрыНаКлиенте Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	#Область ПрикрепленныеФайлы
	МедиаФайлы = ПрикрепленныеФайлыСервер.ПрочитатьСписокФайлов(Объект.Ссылка);
	#КонецОбласти
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	#Область ПрикрепленныеФайлы
	ПрикрепленныеФайлыСервер.ОбработатьИЗаписатьДанныеМультимедиа(МедиаФайлы, ТекущийОбъект.Ссылка);
	#КонецОбласти 	
	
	ЗаполнитьДобавленныеКолонки();
	ПараметрыСеанса.ДатаПоследнейОперации = ТекущийОбъект.Дата;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Записана операция", Новый Структура("Дата, ВидДокумента, Ссылка, ЭтоШаблон, ВладелецФормы", 
			Объект.Дата, "ОбменВалюты", Объект.Ссылка, Объект.ЭтоШаблон, 
			?(ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения"), ВладелецФормы.УникальныйИдентификатор, Неопределено)));
			
	ОбновитьОстаткиДенег("");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обслуживание плановых операций
	Документы.ОбменВалюты.ОбновитьИтоговыеСуммыДокумента(ТекущийОбъект);
	ПлановыеОперации.ПроверкаПлановПередЗаписьюДокумента(ТекущийОбъект, ПараметрыЗаписи, ЭтотОбъект);
	
	// Обслуживание аналитики статей:
	АналитикаСтатей.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Обслуживание плановых операций
	ПлановыеОперацииКлиент.ПередЗаписьюДокумента(ЭтаФорма, Отказ, ПараметрыЗаписи);
	// Общий функционал перед записью документов
	ОбслуживаниеДокументовКлиент.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Записана операция" И ТипЗнч(Параметр) = Тип("Структура") Тогда
		ФормаВладельца = Неопределено;
		Если Параметр.Свойство("ВладелецФормы", ФормаВладельца) И ФормаВладельца = ЭтаФорма.УникальныйИдентификатор И Параметр.ЭтоШаблон <> Объект.ЭтоШаблон Тогда
			ЗаполнитьДанныеПоШаблону(Параметр.Ссылка);
		КонецЕсли;
	КонецЕсли;
		
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	#Область ПрикрепленныеФайлы
	Если (ПрикрепленныеФайлыКлиент.ЭтоПрикреплениеФайла(ЭтаФорма, ИмяСобытия, Источник))Тогда
		ПрикрепленныеФайлыКлиент.ДобавитьФайлВСписокФормы(ЭтотОбъект, Параметр); 
	КонецЕсли;
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Общий функционал перед закрытием форм документов
	ОбслуживаниеДокументовКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы И Открыта() Тогда
		Закрыть(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обслуживание плановых операций
&НаКлиенте
Процедура ИзменитьРасписание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПлановыеОперацииКлиент.ОткрытьРедакторРасписания(ЭтаФорма);
	
КонецПроцедуры

// Обслуживание плановых операций
&НаКлиенте
Процедура ИнформацияОШаблонеНажатие(Элемент, СтандартнаяОбработка)
	
	ПлановыеОперацииКлиент.ИнформацияОШаблонеНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка, "ОбменВалюты");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	РаботаСФормамиДокументовКлиентСервер.ОбновитьЗаголовкиКомандФормы(ЭтотОбъект);

	ОбновитьКурсы(Истина, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КошелекОткудаПриИзменении(Элемент)
	
	КошелекОткудаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КошелекКудаПриИзменении(Элемент)
	
	КошелекКудаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ФинансоваяЦельОткудаПриИзменении(Элемент)
	ОбновитьОстаткиДенег("Откуда");
КонецПроцедуры

&НаКлиенте
Процедура ФинансоваяЦельКудаПриИзменении(Элемент)
	ОбновитьОстаткиДенег("Куда");
КонецПроцедуры

&НаКлиенте
Процедура СуммаВыданоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КошелекКуда) Тогда
		СуммаВыданоПриИзмененииСервер();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПолученоПриИзменении(Элемент)
	
	СуммаПолученоПриИзмененииСервер();
	
КонецПроцедуры



// Обслуживание аналитики статей:
&НаКлиенте
Процедура Подключаемый_ПриИзмененииАналитикиВШапке(Элемент)
	
	АналитикаСтатейКлиент.ПриИзмененииАналитикиВШапке(ЭтаФорма, Элемент);
	
КонецПроцедуры

#Область ПрикрепленныеФайлы

&НаКлиенте
Процедура ПредставлениеФайловОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ПрикрепленныеФайлыКлиент.ОбработчикНажатияНаПредставлениеФайлов(ЭтотОбъект, СтандартнаяОбработка, НавигационнаяСсылкаФорматированнойСтроки);
КонецПроцедуры

#КонецОбласти 


#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеРасходы

&НаКлиенте
Процедура ДополнительныеРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ДанныеСтроки = Элементы.ДополнительныеРасходы.ТекущиеДанные;
		ДанныеСтроки.КошелекРасхода = Объект.КошелекОткуда;
		ДанныеСтроки.ВидКошелькаРасхода = "Кошелек списания";
		ДанныеСтроки.ФинансоваяЦель = Объект.ФинансоваяЦельОткуда;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыПриИзменении(Элемент)
	
	РасходИсточника  = 0;
	РасходНазначения = 0;
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.КошелекРасхода = Объект.КошелекОткуда Тогда
			РасходИсточника = РасходИсточника + СтрокаРасхода.СуммаРасхода;
		ИначеЕсли СтрокаРасхода.КошелекРасхода = Объект.КошелекКуда Тогда
			РасходНазначения = РасходНазначения + СтрокаРасхода.СуммаРасхода;
		КонецЕсли; 
	КонецЦикла; 
	ТекстЗаголовка = НСтр("ru = 'Дополнительные расходы (%1)'");
	Если РасходИсточника = 0 И РасходНазначения = 0 Тогда
		СтрокаСумм = "0";
	Иначе
		СтрокаСумм = "";
		Если РасходИсточника <> 0 Тогда
			СтрокаСумм = Формат(РасходИсточника, "ЧДЦ=2; ЧН=0; ЧГ=") + " " + Объект.ВалютаСписания;
		КонецЕсли;
		Если РасходНазначения <> 0 Тогда
			СтрокаСумм = СтрокаСумм + ?(СтрокаСумм = "", "", ", ") + Формат(РасходНазначения, "ЧДЦ=2; ЧН=0; ЧГ=") + " " + Объект.ВалютаПоступления;
		КонецЕсли;
	КонецЕсли; 
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, 
		СтрокаСумм);
	
	Элементы.ГруппаСтраницаДополнительныеРасходы.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыСтатьяРасходаПриИзменении(Элемент)
	
	СтатьяПриИзмененииСервер(Элементы.ДополнительныеРасходы.ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыСтатьяРасходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбслуживаниеСправочниковКлиент.РасширенноеПолучениеДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// Обслуживание аналитики статей:
	ТекущиеДанные = Элементы.ДополнительныеРасходы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И НЕ ЗначениеЗаполнено(ТекущиеДанные.СтатьяРасхода) Тогда
		СтатьяПриИзмененииСервер(Элементы.ДополнительныеРасходы.ТекущаяСтрока);
	КонецЕсли;
	Если НЕ АналитикаСтатейКлиент.ВидимостьЭлементовШапкиИзменилась(ЭтаФорма) Тогда
		АналитикаСтатейКлиент.ПриОкончанииРедактированияСтрокиТабличнойЧасти(ЭтаФорма, Истина, "ДополнительныеРасходы", ТекущиеДанные);
	Иначе
		УправлениеРеквизитамиАналитики();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыПослеУдаления(Элемент)
	
	// Обслуживание аналитики статей:
	Если НЕ АналитикаСтатейКлиент.ВидимостьЭлементовШапкиИзменилась(ЭтаФорма) Тогда
		АналитикаСтатейКлиент.ПослеУдаленияСтрокиТабличнойЧасти(ЭтаФорма, Истина, "ДополнительныеРасходы");
	Иначе
		УправлениеРеквизитамиАналитики();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыВидКошелькаРасходаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ДополнительныеРасходы.ТекущиеДанные;
	ДанныеСтроки.ВидКошелькаРасхода = ?(ДанныеСтроки.ВидКошелькаРасхода = "", "Кошелек списания", ДанныеСтроки.ВидКошелькаРасхода);
	Если ДанныеСтроки.ВидКошелькаРасхода = "Кошелек зачисления" Тогда
		ДанныеСтроки.КошелекРасхода     = Объект.КошелекКуда;
		ДанныеСтроки.ФинансоваяЦель     = Объект.ФинансоваяЦельКуда;
	Иначе
		ДанныеСтроки.КошелекРасхода     = Объект.КошелекОткуда;
		ДанныеСтроки.ФинансоваяЦель     = Объект.ФинансоваяЦельОткуда;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРасходыКошелекРасходаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ДополнительныеРасходы.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(ДанныеСтроки.КошелекРасхода) Тогда
		ДанныеСтроки.КошелекРасхода = Объект.КошелекОткуда;
	КонецЕсли;
	Если ДанныеСтроки.КошелекРасхода     = Объект.КошелекКуда Тогда
		ДанныеСтроки.ВидКошелькаРасхода = "Кошелек зачисления";
	ИначеЕсли ДанныеСтроки.КошелекРасхода     = Объект.КошелекОткуда Тогда
		ДанныеСтроки.ВидКошелькаРасхода = "Кошелек списания";
	Иначе
		ДанныеСтроки.ВидКошелькаРасхода = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// Обслуживание аналитики статей:
&НаКлиенте
Процедура Подключаемый_НастройкаКолонокАналитики(Команда)

	АналитикаСтатейКлиент.ИзменитьНастройкиКолонокАналитики(ЭтаФорма, Истина, "ОбменВалюты");

КонецПроцедуры

// Обслуживание аналитики статей:
&НаКлиенте
Процедура НастройкаКолонокАналитикиЗавершение(НастройкиИзменены) Экспорт

	Если НастройкиИзменены Тогда
		УправлениеРеквизитамиАналитики(Истина, Истина);
	КонецЕсли; 

КонецПроцедуры
 
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	// Подготовка реквизитов формы
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	ДатаОстатков = ?(Объект.Проведен, Объект.Ссылка.МоментВремени(), КонецДня(ТекущаяДатаСеанса()));
	ОстатокВКошелькеОткуда = РазделыУчета.ПолучитьОстатокПоСубконто(ПланыСчетов.РазделыУчета.Деньги, Объект.КошелекОткуда, ДатаОстатков);
	ОстатокВКошелькеКуда   = РазделыУчета.ПолучитьОстатокПоСубконто(ПланыСчетов.РазделыУчета.Деньги, Объект.КошелекКуда, ДатаОстатков);
	УстановитьОтборДляКошелькаКуда();
	
	// Обновляем курсы
	ОбновитьКурсы(Истина, Истина, Ложь);
	
	// Обновляем остатки в кошельках
	ОбновитьОстаткиДенег();
	
	// Обслуживание аналитики статей:
	АналитикаСтатей.ПриСозданииНаСервере(ЭтаФорма, "", "", "СтатьяРасхода", "АналитикаСтатьи", "ДополнительныеРасходыКоманднаяПанель");
	
	// Заполнение дополнительных колонок и реквизитов
	ЗаполнитьДобавленныеКолонки();
	
	// Общие настройки форм элементов документов
	РаботаСФормамиДокументов.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);
	
	// Проверка работы с шаблонами
	РаботаСФормамиДокументов.ПодготовитьФормуНаСервереПоРаботеСШаблонами(ЭтаФорма);
	
	#Область ПрикрепленныеФайлы
	ПрикрепленныеФайлыКлиентСервер.ОбновитьПредставлениеМедиафайлов(ЭтотОбъект);
	#КонецОбласти	
	
	// Настройка внешнего вида
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонки()

	// Обслуживание аналитики статей:
	АналитикаСтатей.ЗаполнитьРеквизитыАналитикой(ЭтаФорма);
	
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.КошелекРасхода = Объект.КошелекОткуда Тогда
			СтрокаРасхода.ВидКошелькаРасхода = "Кошелек списания";
		ИначеЕсли СтрокаРасхода.КошелекРасхода = Объект.КошелекКуда Тогда
			СтрокаРасхода.ВидКошелькаРасхода = "Кошелек зачисления";
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()

	// Обслуживание плановых операций
	ПлановыеОперацииКлиентСервер.ОбновитьИнформациюОСвязиОперацииСРасписанием(ЭтотОбъект);
	
	// Обслуживание аналитики статей:
	УправлениеРеквизитамиАналитики();
	
	РаботаСФормамиДокументовКлиентСервер.ОбновитьСостояниеОперации(ЭтотОбъект);
	
	ЭтоНоваяОперация = НЕ Объект.ЭтоШаблон И Объект.Ссылка.Пустая();
	
	РасходыВКошелькеОткуда = 0;
	РасходыВКошелькеКуда   = 0;
	
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.КошелекРасхода = Объект.КошелекОткуда Тогда
			РасходыВКошелькеОткуда = РасходыВКошелькеОткуда + СтрокаРасхода.СуммаРасхода;
		ИначеЕсли СтрокаРасхода.КошелекРасхода = Объект.КошелекКуда Тогда
			РасходыВКошелькеКуда   = РасходыВКошелькеКуда + СтрокаРасхода.СуммаРасхода;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ЗначениеЗаполнено(Объект.ВалютаПоступления) И ЗначениеЗаполнено(Объект.ВалютаСписания) Тогда
		ТекстКурсаКуда   = Формат(КроссКурсВыданной, "ЧДЦ=4; ЧН=0") + " " + Объект.ВалютаПоступления + " за " + КратностьВалютыВыданной + " " + Объект.ВалютаСписания;
		ТекстКурсаОткуда = Формат(КроссКурсПолученной, "ЧДЦ=4; ЧН=0") + " " + Объект.ВалютаСписания + " за " + КратностьВалютыПолученной + " " + Объект.ВалютаПоступления;
	Иначе
		ТекстКурсаКуда   = "";
		ТекстКурсаОткуда = "";
	КонецЕсли; 
	
	РасходИсточника  = 0;
	РасходНазначения = 0;
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.КошелекРасхода = Объект.КошелекОткуда Тогда
			РасходИсточника = РасходИсточника + СтрокаРасхода.СуммаРасхода;
		ИначеЕсли СтрокаРасхода.КошелекРасхода = Объект.КошелекКуда Тогда
			РасходНазначения = РасходНазначения + СтрокаРасхода.СуммаРасхода;
		КонецЕсли; 
	КонецЦикла; 
	ТекстЗаголовка = НСтр("ru = 'Дополнительные расходы (%1)'");
	Если РасходИсточника = 0 И РасходНазначения = 0 Тогда
		СтрокаСумм = "0";
	Иначе
		СтрокаСумм = "";
		Если РасходИсточника <> 0 Тогда
			СтрокаСумм = Формат(РасходИсточника, "ЧДЦ=2; ЧН=0; ЧГ=") + " " + Объект.ВалютаСписания;
		КонецЕсли;
		Если РасходНазначения <> 0 Тогда
			СтрокаСумм = СтрокаСумм + ?(СтрокаСумм = "", "", ", ") + Формат(РасходНазначения, "ЧДЦ=2; ЧН=0; ЧГ=") + " " + Объект.ВалютаПоступления;
		КонецЕсли;
	КонецЕсли; 
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, 
		СтрокаСумм);
	
	Элементы.ГруппаСтраницаДополнительныеРасходы.Заголовок = ТекстЗаголовка;

	Элементы.ФинансоваяЦельОткуда.Видимость = ЗначениеЗаполнено(Объект.КошелекОткуда) И Объект.КошелекОткуда.ИспользоватьДляНакоплений;
	Элементы.ФинансоваяЦельКуда.Видимость   = ЗначениеЗаполнено(Объект.КошелекКуда) И Объект.КошелекКуда.ИспользоватьДляНакоплений;
	ВидимостьФинансовойЦели = Элементы.ФинансоваяЦельОткуда.Видимость 
		ИЛИ Элементы.ФинансоваяЦельКуда.Видимость;
	
	Элементы.ДополнительныеРасходыКошелекРасхода.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.КошелекОткуда) Тогда
		Элементы.ДополнительныеРасходыКошелекРасхода.СписокВыбора.Добавить(Объект.КошелекОткуда);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Объект.КошелекОткуда) Тогда
		Элементы.ДополнительныеРасходыКошелекРасхода.СписокВыбора.Добавить(Объект.КошелекКуда);
	КонецЕсли; 
	
	МассивКошельков = Новый Массив;
	Если ЗначениеЗаполнено(Объект.КошелекОткуда) Тогда
		МассивКошельков.Добавить(Объект.КошелекОткуда);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Объект.КошелекКуда) Тогда
		МассивКошельков.Добавить(Объект.КошелекКуда);
	КонецЕсли; 
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивКошельков)));
	Элементы.ДополнительныеРасходыКошелекРасхода.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	РаботаСФормамиДокументовКлиентСервер.ОбновитьЭлементыФормыПоСостояниюОперации(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДляКошелькаКуда()

	МассивОтбора =  Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВалютаВыдано", Объект.ВалютаСписания);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Ссылка <> &ВалютаВыдано";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивОтбора.Добавить(Выборка.Ссылка);
	КонецЦикла; 
	МассивВалютДляОтбора = Новый ФиксированныйМассив(МассивОтбора);
	ПараметрДляПоля = Новый ПараметрВыбора("Отбор.Валюта", МассивВалютДляОтбора);
	
	МассивПараметров = Новый Массив();
	МассивПараметров.Добавить(ПараметрДляПоля);
	
	Элементы.КошелекКуда.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);

КонецПроцедуры

// Обслуживание плановых операций
&НаСервере
Процедура ЗаполнитьДанныеПоШаблону(СсылкаНаШаблон)
	
	РаботаСФормамиДокументов.ОбновитьФормуОперацииПоШаблону(ЭтотОбъект, СсылкаНаШаблон);
	
	// Обслуживание аналитики статей:
	АналитикаСтатей.ПриСозданииНаСервере(ЭтаФорма, "", "", "СтатьяРасхода", "АналитикаСтатьи", "ДополнительныеРасходыКоманднаяПанель");
	
	// Заполнение дополнительных колонок и реквизитов
	ЗаполнитьДобавленныеКолонки();
	
	// Общие настройки форм элементов документов
	РаботаСФормамиДокументов.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);
	
	// Настройка внешнего вида
	УправлениеФормой();

КонецПроцедуры

// Обслуживание аналитики статей:
&НаСервере
Процедура УправлениеРеквизитамиАналитики(ИспользоватьЗначенияПоУмолчанию = Ложь, ПотеряДанныхРазрешена = Ложь)

	АналитикаСтатей.УправлениеФормой(ЭтаФорма, ИспользоватьЗначенияПоУмолчанию, ПотеряДанныхРазрешена);

КонецПроцедуры

// Обслуживание аналитики статей:
&НаСервере
Процедура СтатьяПриИзмененииСервер(ИДСтроки)

	СтрокаДокумента = Объект.ДополнительныеРасходы.НайтиПоИдентификатору(ИДСтроки);
	Если СтрокаДокумента <> Неопределено Тогда
		АналитикаСтатей.ПриИзмененииСтатьиВТабличнойЧасти(ЭтаФорма, СтрокаДокумента.СтатьяРасхода, "ДополнительныеРасходы", ИДСтроки);
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ОбновитьКурсы(Списание, Зачисление, ОбновлятьФорму = Ложь)

	Если Списание Тогда
		Если Объект.ВалютаСписания = ВалютаУчета ИЛИ НЕ ЗначениеЗаполнено(Объект.ВалютаСписания) Тогда
			КурсВалютыВыданной      = 1;
			КратностьВалютыВыданной = 1;
		Иначе
			КурсИКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаСписания, Объект.Дата, ВалютаУчета);
			КурсВалютыВыданной      = КурсИКратность.Курс;
			КратностьВалютыВыданной = КурсИКратность.Кратность;
		КонецЕсли; 
	КонецЕсли; 
	
	Если Зачисление Тогда
		Если Объект.ВалютаПоступления = ВалютаУчета ИЛИ НЕ ЗначениеЗаполнено(Объект.ВалютаПоступления) Тогда
			КурсВалютыПолученной      = 1;
			КратностьВалютыПолученной = 1;
		Иначе
			КурсИКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаПоступления, Объект.Дата, ВалютаУчета);
			КурсВалютыПолученной      = КурсИКратность.Курс;
			КратностьВалютыПолученной = КурсИКратность.Кратность;
		КонецЕсли;
	КонецЕсли; 

	КурсВалютыВыданной        = Макс(КурсВалютыВыданной, 1);
	КурсВалютыПолученной      = Макс(КурсВалютыПолученной, 1);
	КратностьВалютыВыданной   = Макс(КратностьВалютыВыданной, 1);
	КратностьВалютыПолученной = Макс(КратностьВалютыПолученной, 1);
	
	КроссКурсВыданной = ?(Объект.СуммаПолучено = 0 ИЛИ Объект.СуммаВыдано = 0, 
			Окр(КурсВалютыВыданной / КурсВалютыПолученной, 4,1), 
			Окр(Объект.СуммаПолучено / Объект.СуммаВыдано, 4,1) * КратностьВалютыВыданной);
	
	КроссКурсПолученной = ?(Объект.СуммаПолучено = 0 ИЛИ Объект.СуммаВыдано = 0, 
			Окр(КурсВалютыПолученной / КурсВалютыВыданной, 4,1), 
			Окр(Объект.СуммаВыдано / Объект.СуммаПолучено, 4,1) * КратностьВалютыПолученной);

	
	Если ОбновлятьФорму Тогда
		УправлениеФормой();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура КошелекОткудаПриИзмененииСервер()

	ВыполнятьПересчет = ЗначениеЗаполнено(Объект.ВалютаСписания) И ЗначениеЗаполнено(Объект.ВалютаПоступления)
		И Объект.ВалютаСписания <> Объект.КошелекОткуда.Валюта 
		И ЗначениеЗаполнено(Объект.СуммаВыдано) И ЗначениеЗаполнено(Объект.СуммаПолучено);
	Объект.ВалютаСписания = Объект.КошелекОткуда.Валюта;
	ОбновитьКурсы(Истина, Ложь, Ложь);
	
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.ВидКошелькаРасхода = "Кошелек списания" Тогда
			СтрокаРасхода.КошелекРасхода = Объект.КошелекОткуда;
		КонецЕсли; 
	КонецЦикла; 
	
	Если Объект.ВалютаПоступления = Объект.ВалютаСписания Тогда
		Объект.КошелекКуда = Неопределено;
		Объект.ВалютаПоступления = Неопределено;
	КонецЕсли;
	 
	УстановитьОтборДляКошелькаКуда();
	
	Если НЕ ЗначениеЗаполнено(Объект.ФинансоваяЦельОткуда) Тогда
		Объект.ФинансоваяЦельОткуда = Справочники.ФинансовыеЦели.ОбщиеНакопления;
	КонецЕсли; 
	
	Если ВыполнятьПересчет Тогда
		СуммаВыданоПриИзмененииСервер();
	Иначе
		Если Объект.ВалютаСписания = Объект.ВалютаПоступления Тогда
			Объект.СуммаПолучено = Объект.СуммаВыдано;
		КонецЕсли;
		
		УправлениеФормой();
		
	КонецЕсли;

	ОбновитьОстаткиДенег("Откуда");
	
КонецПроцедуры

&НаСервере
Процедура СуммаВыданоПриИзмененииСервер()

	Объект.СуммаПолучено = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.СуммаВыдано,
		Объект.ВалютаСписания, Объект.ВалютаПоступления, 
		КурсВалютыВыданной, КурсВалютыПолученной, 
		КратностьВалютыВыданной, КратностьВалютыПолученной);

	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура СуммаПолученоПриИзмененииСервер()

	Если Не ЗначениеЗаполнено(Объект.СуммаВыдано) Тогда
		Объект.СуммаВыдано = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.СуммаПолучено,
			Объект.ВалютаПоступления,  Объект.ВалютаСписания, 
			КурсВалютыПолученной, КурсВалютыВыданной, 
			КратностьВалютыПолученной, КратностьВалютыВыданной);
	КонецЕсли;
	
	КроссКурсВыданной = ?(Объект.СуммаПолучено = 0 ИЛИ Объект.СуммаВыдано = 0, 
			Окр(КурсВалютыВыданной / КурсВалютыПолученной, 4,1), 
			Окр(Объект.СуммаПолучено / Объект.СуммаВыдано, 4,1) * КратностьВалютыВыданной);
	
	КроссКурсПолученной = ?(Объект.СуммаПолучено = 0 ИЛИ Объект.СуммаВыдано = 0, 
			Окр(КурсВалютыПолученной / КурсВалютыВыданной, 4,1), 
			Окр(Объект.СуммаВыдано / Объект.СуммаПолучено, 4,1) * КратностьВалютыПолученной);

	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура КошелекКудаПриИзмененииСервер()

	Объект.ВалютаПоступления = Объект.КошелекКуда.Валюта;
	ОбновитьКурсы(Ложь, Истина, Ложь);
	ВыполнятьПересчет = ЗначениеЗаполнено(Объект.ВалютаСписания) И ЗначениеЗаполнено(Объект.ВалютаПоступления)
		И ЗначениеЗаполнено(Объект.СуммаВыдано);
	
	Для Каждого СтрокаРасхода Из Объект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.ВидКошелькаРасхода = "Кошелек поступления" Тогда
			СтрокаРасхода.КошелекРасхода = Объект.КошелекКуда;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ВыполнятьПересчет Тогда
		Объект.СуммаПолучено = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Объект.СуммаВыдано,
			Объект.ВалютаСписания, Объект.ВалютаПоступления, 
			КурсВалютыВыданной, КурсВалютыПолученной, 
			КратностьВалютыВыданной, КратностьВалютыПолученной);
	ИначеЕсли Объект.ВалютаСписания = Объект.ВалютаПоступления Тогда
		Объект.СуммаПолучено = Объект.СуммаВыдано;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФинансоваяЦельКуда) Тогда
		Объект.ФинансоваяЦельКуда = Справочники.ФинансовыеЦели.ОбщиеНакопления;
	КонецЕсли; 
	
	УправлениеФормой();

	ОбновитьОстаткиДенег("Куда");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиДенег(Сторона = "")

	Если Сторона = "" Или Сторона = "Откуда" Тогда
		РаботаСФормамиДокументов.ОбновитьОстатокПоОбъектуУчета(ЭтотОбъект, "НадписьОстатокКошелекОткуда", 
				ПланыСчетов.РазделыУчета.Деньги, Объект.КошелекОткуда, , Объект.ФинансоваяЦельОткуда, "НадписьОстатокНакопленийКошелекОткуда");
	КонецЕсли; 
	Если Сторона = "" Или Сторона = "Куда" Тогда
		РаботаСФормамиДокументов.ОбновитьОстатокПоОбъектуУчета(ЭтотОбъект, "НадписьОстатокКошелекКуда", 
				ПланыСчетов.РазделыУчета.Деньги, Объект.КошелекКуда, , Объект.ФинансоваяЦельКуда, "НадписьОстатокНакопленийКошелекКуда");
	КонецЕсли; 
	

КонецПроцедуры


// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства


#КонецОбласти


