#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		УправлениеФормой();
	КонецЕсли; 
	
	// Общие настройки форм элементов справочников
	РаботаСФормамиСправочников.ФормаЭлементаПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИмяПВХ = Неопределено;
	Ссылка = Неопределено;
	Если ИмяСобытия = "Записан вид характеристик" И ТипЗнч(Параметр) = Тип("Структура")
		 И Параметр.Свойство("ИмяПланаВидовХарактеристик", ИмяПВХ) И ИмяПВХ = "ВидыАналитик" 
		 И Параметр.Свойство("Ссылка", Ссылка) И Ссылка = Объект.Ссылка Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПереключательРасширенныеНастройкиДляРасхода = Объект.РасширенныеНастройкиДляРасхода;
	ПереключательРасширенныеНастройкиДляДохода =  Объект.РасширенныеНастройкиДляДохода;
	
	РазблокироватьДанныеФормыДляРедактирования();
	
	УправлениеФормой();
	
	//СохраненныйФлагДляДоходов  = ТекущийОбъект.ОбщееДляВсехСтатейДохода;
	//СохраненныйФлагДляРасходов = ТекущийОбъект.ОбщееДляВсехСтатейРасхода;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Записан вид характеристик", Новый Структура("ИмяПланаВидовХарактеристик,Ссылка,ВладелецФормы", "ВидыАналитик", Объект.Ссылка, ?(ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения"), ВладелецФормы.УникальныйИдентификатор, Неопределено)));
	
	УправлениеФормой();
	
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АктуальнаДляРасходаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательРасширенныеНастройкиДляРасходаПриИзменении(Элемент)
	
	Объект.РасширенныеНастройкиДляРасхода = ПереключательРасширенныеНастройкиДляРасхода;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьРасширенныеНастройкиДляРасходаНажатие(Элемент)
	
	ОткрытьФормуПослеПроверкиИЗаписи("ПланВидовХарактеристик.ВидыАналитик.Форма.НастройкиВидимостиПоСтатьям", Новый Структура("ВидАналитики, ЭтоРасход", Объект.Ссылка, Истина), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуальнаДляДоходаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательРасширенныеНастройкиДляДоходаПриИзменении(Элемент)
	
	Объект.РасширенныеНастройкиДляДохода = ПереключательРасширенныеНастройкиДляДохода;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьРасширенныеНастройкиДляДоходаНажатие(Элемент)
	
	ОткрытьФормуПослеПроверкиИЗаписи("ПланВидовХарактеристик.ВидыАналитик.Форма.НастройкиВидимостиПоСтатьям", Новый Структура("ВидАналитики, ЭтоРасход", Объект.Ссылка, Ложь), Элемент);
	
КонецПроцедуры



#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()

	Элементы.ЗначениеАналитикиРасхода.Доступность                   = Объект.АктуальнаДляРасхода;
	Элементы.ГруппаРасширенныеНастройкиДляРасхода.Доступность       = Объект.АктуальнаДляРасхода;
	Элементы.НадписьРасширенныеНастройкиДляРасхода.Доступность      = Объект.АктуальнаДляРасхода И Объект.РасширенныеНастройкиДляРасхода;
	
	Элементы.ЗначениеАналитикиДохода.Доступность                   = Объект.АктуальнаДляДохода;
	Элементы.ГруппаРасширенныеНастройкиДляДохода.Доступность       = Объект.АктуальнаДляДохода;
	Элементы.НадписьРасширенныеНастройкиДляДохода.Доступность      = Объект.АктуальнаДляДохода И Объект.РасширенныеНастройкиДляДохода;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПослеПроверкиИЗаписи(ИмяФормы, ПараметрыДляФормы, ВладелецДляФормы)

	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Сначала объект необходимо записать. 
								  |Записать и продолжить?'");
		ДополнительныеПараметры = Новый Структура("ИмяФормы, ПараметрыДляФормы, ВладелецДляФормы", ИмяФормы, ПараметрыДляФормы, ВладелецДляФормы); 
		ОбработчикОтвета = Новый ОписаниеОповещения("ОткрытьФормуПослеПроверкиИЗаписиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОбработчикОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ОткрытьФорму(ИмяФормы, ПараметрыДляФормы, ВладелецДляФормы, Объект.Ссылка, ,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПослеПроверкиИЗаписиЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да И Записать() Тогда
		ДополнительныеПараметры.ПараметрыДляФормы.Вставить("ВидАналитики", Объект.Ссылка);
		ОткрытьФорму(ДополнительныеПараметры.ИмяФормы, ДополнительныеПараметры.ПараметрыДляФормы, ДополнительныеПараметры.ВладелецДляФормы);
	КонецЕсли;

КонецПроцедуры
 


#КонецОбласти

