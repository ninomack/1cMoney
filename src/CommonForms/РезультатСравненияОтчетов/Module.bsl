
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем АдресРезультатаСравнения;
	Перем ДанныеДляСравнения;
	Перем ЕстьРазличия;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("АдресРезультатаСравнения", АдресРезультатаСравнения)
	 ИЛИ НЕ ЭтоАдресВременногоХранилища(АдресРезультатаСравнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ДанныеДляСравнения", ДанныеДляСравнения)
	 ИЛИ НЕ ТипЗнч(ДанныеДляСравнения) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ОписаниеРезультата.Заголовок = ОписаниеРезультатаСравнения(ДанныеДляСравнения);
	
	ДанныеРезультатаСравнения = ПолучитьИзВременногоХранилища(АдресРезультатаСравнения);
	
	ЗначениеВРеквизитФормы(ДанныеРезультатаСравнения.РазделыОтчета, "РазделыОтчетаВсе");
	
	ЕстьРазличия = Ложь;
	КопироватьРазделыСодержащиеРазличия(РазделыОтчетаВсе, РазделыОтчетаРазличия, ЕстьРазличия);
	
	ПоказатьТолькоРазличия = Истина;
	Элементы.Различия.Пометка = ПоказатьТолькоРазличия;
	
	Если ПоказатьТолькоРазличия Тогда
		КопироватьДанныеФормы(РазделыОтчетаРазличия, РазделыОтчета);
	Иначе
		КопироватьДанныеФормы(РазделыОтчетаВсе, РазделыОтчета);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДанныеРезультатаСравнения.СтраницыРезультатовСравнения, "СтраницыРезультатовСравнения");
	
	РезультатТабличныйДокумент.АвтоМасштаб = Истина;
	РезультатТабличныйДокумент.ОтображатьСетку = Ложь;
	РезультатТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	РезультатТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если РазделыОтчетаРазличия.ПолучитьЭлементы().Количество() = 0 Тогда
	
		ПоказатьПредупреждение( , НСтр("ru='Данные сравниваемых отчетов не содержат различий'"));
	
	КонецЕсли;
	
	РаскрытьГруппыДереваПоУсловию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовРазделыОтчета

&НаКлиенте
Процедура РазделыОтчетаПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено
	 ИЛИ Элемент.ТекущаяСтрока = ТекущаяСтрокаРазделовОтчета Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаРазделовОтчета = Элемент.ТекущаяСтрока;
	
	ВывестиРезультатВТабДокНаСервере(
		НазваниеРазделаСокр(Элемент.ТекущиеДанные),
		Элемент.ТекущиеДанные.КодСтраницы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовРезультатСравненияТабличныйДокумент

&НаКлиенте
Процедура РезультатСравненияТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатСравненияТабличныйДокументПриАктивизацииОбласти(Элемент)
	
	Элементы.ТабличныйДокументКонтекстноеМенюПерейтиКЯчейкеОтчета.Доступность = Ложь;
	
	Если ТипЗнч(Элемент.ТекущаяОбласть.Расшифровка) = Тип("Структура") Тогда
		Элементы.ТабличныйДокументКонтекстноеМенюПерейтиКЯчейкеОтчета.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьОтменитьТолькоРазличия(Команда)
	
	ПоказатьТолькоРазличия = НЕ ПоказатьТолькоРазличия;
	
	Элементы.Различия.Пометка = ПоказатьТолькоРазличия;
	
	Если Элементы.РазделыОтчета.ТекущиеДанные = Неопределено Тогда
		ПоказатьОтменитьТолькоРазличияНаСервере("", "");
	Иначе
		ПоказатьОтменитьТолькоРазличияНаСервере(
			НазваниеРазделаСокр(Элементы.РазделыОтчета.ТекущиеДанные),
			Элементы.РазделыОтчета.ТекущиеДанные.КодСтраницы);
	КонецЕсли;
	
	РаскрытьГруппыДереваПоУсловию();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект);
	
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЯчейкеОтчета(Команда)
	
	Если ТипЗнч(Элементы.РезультатСравненияТабличныйДокумент.ТекущаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента")
	 ИЛИ ТипЗнч(Элементы.РезультатСравненияТабличныйДокумент.ТекущаяОбласть.Расшифровка) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаРасшифровки(Элементы.РезультатСравненияТабличныйДокумент,
		Элементы.РезультатСравненияТабличныйДокумент.ТекущаяОбласть.Расшифровка,
		Истина, Новый Структура());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьПослеПодключенияРасширенияРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		
		ПоказатьДиалогВыбораФайла();
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("СохранитьПослеУстановкиРасширенияЗавершение", ЭтотОбъект);
		
		НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПослеОтображенияДиалогаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Попытка
		РезультатТабличныйДокумент.Записать(ВыбранныеФайлы[0], ТипФайлаТабличногоДокумента.MXL);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не удалось записать файл на диск. Возможно, диск защищен от записи или недостаточно места на диске.'");
		Сообщение.Сообщить();
	КонецПопытки;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПослеУстановкиРасширенияЗавершение(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьПослеУстановкиРасширенияЗавершениеПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект);
	
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПослеУстановкиРасширенияЗавершениеПослеПодключенияРасширенияРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		Возврат;
	КонецЕсли;
		
	ПоказатьДиалогВыбораФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.РазделыОтчета.ТекущиеДанные <> Неопределено
	   И Элементы.РазделыОтчета.ТекущиеДанные.СтатусСтраницы > 0
	   И Элемент.ТекущаяОбласть.Текст = "-" Тогда
		ПоказатьПредупреждение( ,
			НСтр("ru='Текущая страница отсутствует в соответствующем разделе сравниваемого отчета.
					 |Переход на нее невозможен.'"));
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		Если Расшифровка.ДополнительныеВозможности <> Неопределено Тогда
			Если СтрНайти(Расшифровка.ДополнительныеВозможности, "ВывестиТекстОтчетНеОткрывать:") > 0 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = Сред(Расшифровка.ДополнительныеВозможности, 30);
				Сообщение.Сообщить();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если Элементы.РазделыОтчета.ТекущиеДанные <> Неопределено Тогда
			Расшифровка.ИмяСтраницы = Элементы.РазделыОтчета.ТекущиеДанные.КолонкаРазделыОтчетаСокрНаим;
		КонецЕсли;
		
		АктивизироватьЯчейкуОтчета(Расшифровка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогВыбораФайла()
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.Расширение = "mxl";
	Диалог.Фильтр = "Табличные документы (*.mxl)|*.mxl";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьПослеОтображенияДиалогаВыбораФайла", ЭтотОбъект);
	
	Диалог.Показать(ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьЯчейкуОтчета(Расшифровка)
	
	ТекДок = Расшифровка.СсылкаНаОтчет;
	
	Если ТекДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ячейка = Новый Структура;
	Ячейка.Вставить("Раздел", Расшифровка.ИмяСтраницы);
	Ячейка.Вставить("Страница", Расшифровка.Страница); // номер листа в многостраничном разделе, если не многостр. раздел, то - "".
	Ячейка.Вставить("Строка", "");
	Ячейка.Вставить("Графа", "");
	Ячейка.Вставить("СтрокаПП", "");
	Ячейка.Вставить("ИмяЯчейки", Расшифровка.ИмяПоказателя);
	Ячейка.Вставить("Описание", "");
	
	Если ЭтотОбъект.ВладелецФормы = Неопределено ИЛИ ТекДок <> ЭтотОбъект.ВладелецФормы.КлючУникальности Тогда
		
		ПараметрыФормы = Новый Структура;
		
		ЗаполнитьПараметрыФормыНаСервере(ПараметрыФормы, ТекДок);
		
		ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
			РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
		ПараметрыФормы.Вставить("НеОтображатьПредупреждение", Истина);
		
		Попытка
			
			ПараметрыФормы.Вставить("мСохраненныйДок", ТекДок);
			ВариантОтчета = ?(ПараметрыФормы.ЭтоВнешнийОтчет, "ВнешнийОтчет.", "Отчет.");
			ПараметрыФормы.Удалить("ЭтоВнешнийОтчет");
			
			ФормаОтчета = ОткрытьФорму(ВариантОтчета + ПараметрыФормы.ИсточникОтчета + ".Форма." + ПараметрыФормы.мВыбраннаяФорма,
				ПараметрыФормы, , ТекДок);
			
		Исключение
			
			СтрокаОписания = ОписаниеОшибки();
			ПоказатьПредупреждение( ,
				НСтр("ru='Внимание! Устаревшая редакция формы отчета не поддерживается текущей версией конфигурации.'"));
			
			Возврат;
			
		КонецПопытки;
		
	Иначе
		
		ФормаОтчета = ЭтаФорма.ВладелецФормы;
		
		ФормаОтчета.Открыть();
		
	КонецЕсли;
	
	ФормаОтчета.Активизировать();
	ФормаОтчета.АктивизироватьЯчейку(Ячейка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыФормыНаСервере(ПараметрыФормы, ТекДок)
	
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоДня(ТекДок.ДатаНачала));
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  КонецДня(ТекДок.ДатаОкончания));
	ПараметрыФормы.Вставить("мПериодичность",           ТекДок.Периодичность);
	ПараметрыФормы.Вставить("Организация",              ТекДок.Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          ТекДок.ВыбраннаяФорма);
	ПараметрыФормы.Вставить("ИсточникОтчета",           ТекДок.ИсточникОтчета);
	ПараметрыФормы.Вставить("ЭтоВнешнийОтчет",          РегламентированнаяОтчетность.ЭтоВнешнийОтчет(ТекДок.ИсточникОтчета));
	
КонецПроцедуры

&НаСервере
Функция ОписаниеРезультатаСравнения(ДанныеДляСравнения)
	
	ДокументОтчетаЛевыйПредставление  = ДанныеДляСравнения.ДокументОтчетаЛевыйПредставление;
	ДокументОтчетаПравыйПредставление = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(
		ДанныеДляСравнения.ДокументОтчетаПравый);
		
	Возврат "1  " + ДокументОтчетаЛевыйПредставление + Символы.ПС + "2  " + ДокументОтчетаПравыйПредставление;
	
КонецФункции

&НаСервере
Процедура ПоказатьОтменитьТолькоРазличияНаСервере(ИмяРаздела, КодСтраницы)
	
	РазделыОтчета.ПолучитьЭлементы().Очистить();
	ТабличныйДокументУстановитьСтатус("");
	
	Если НЕ ПоказатьТолькоРазличия Тогда
		Команды.ПоказатьОтменитьТолькоРазличия.Подсказка = НСтр("ru='Показать только разделы и строки, содержащие различия'");
		КопироватьДанныеФормы(РазделыОтчетаВсе, РазделыОтчета);
	Иначе
		Команды.ПоказатьОтменитьТолькоРазличия.Подсказка = НСтр("ru='Показать все разделы и строки'");
		КопироватьДанныеФормы(РазделыОтчетаРазличия, РазделыОтчета);
		Если РазделыОтчета.ПолучитьЭлементы().Количество() = 0 Тогда
			ТабличныйДокументУстановитьСтатус("НетДанных");
		КонецЕсли;
	КонецЕсли;
	
	ИдентификаторСтроки = ИдентификаторНайденнойСтрокиДерева(РазделыОтчета, ИмяРаздела, КодСтраницы);
	Если ИдентификаторСтроки = Неопределено Тогда
		ИдентификаторСтроки = 0;
	КонецЕсли;
	
	РезультатТабличныйДокумент.Очистить();
	
	Элементы.РазделыОтчета.ТекущаяСтрока = ИдентификаторСтроки; // Инициируем событие "ПриАктивацииСтроки"
	
	ТекущаяСтрокаРазделовОтчета = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультатВТабДокНаСервере(ИмяРаздела, КодСтраницы)
	
	НайденныеСтроки = СтраницыРезультатовСравнения.НайтиСтроки(
		Новый Структура("ИмяРаздела,КодСтраницы", ИмяРаздела, КодСтраницы));
		
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
	
		РезультатТабличныйДокумент.Очистить();
		
		Если ПоказатьТолькоРазличия Тогда
			РезультатТабличныйДокумент.Вывести(НайденныеСтроки[0].ТабДокРазличия);
		Иначе
			РезультатТабличныйДокумент.Вывести(НайденныеСтроки[0].ТабДокВсе);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТабличныйДокументУстановитьСтатус(Статус)
	
	ОтображениеСостояния = Элементы.РезультатСравненияТабличныйДокумент.ОтображениеСостояния;
	
	Если Статус = "" Тогда
		ОтображениеСостояния.Видимость = Ложь;
		ОтображениеСостояния.Картинка  = Новый Картинка;
		ОтображениеСостояния.Текст     = "";
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	ИначеЕсли Статус = "НетДанных" Тогда
		ОтображениеСостояния.Видимость = Истина;
		ОтображениеСостояния.Картинка  = БиблиотекаКартинок.Информация32;
		ОтображениеСостояния.Текст = НСтр("ru = 'Нет данных о различиях.'");
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура КопироватьРазделыСодержащиеРазличия(ЭлементДереваИсточник, ЭлементДереваПриемник, ЕстьРазличия = Ложь)
	
	Перем ЕстьРазличияВПодчиненных;
	
	ЕстьРазличия = Ложь;
	
	СтрокиИсточника = ЭлементДереваИсточник.ПолучитьЭлементы();
	
	СтрокиПриемника = ЭлементДереваПриемник.ПолучитьЭлементы();
	
	Для Каждого СтрокаИсточника Из СтрокиИсточника Цикл
		
		НоваяСтрокаПриемника = СтрокиПриемника.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПриемника, СтрокаИсточника);
		
		КопироватьРазделыСодержащиеРазличия(СтрокаИсточника, НоваяСтрокаПриемника, ЕстьРазличияВПодчиненных);
		
		Если НЕ СтрокаИсточника.ЕстьРазличия И НЕ ЕстьРазличияВПодчиненных Тогда
			СтрокиПриемника.Удалить(НоваяСтрокаПриемника);
			Продолжить;
		КонецЕсли;
		
		ЕстьРазличия = Истина;
		
		Если НоваяСтрокаПриемника.ПолучитьРодителя() = Неопределено Тогда // элемент первого уровня
			ЭлементыВторогоУровня = НоваяСтрокаПриемника.ПолучитьЭлементы();
			Если ЭлементыВторогоУровня.Количество() > 0 Тогда
				НоваяСтрокаПриемника.КодСтраницы = ЭлементыВторогоУровня[0].КодСтраницы;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьГруппыДереваПоУсловию()
	
	ЭлементыПервогоУровня = РазделыОтчета.ПолучитьЭлементы();
	Если ЭлементыПервогоУровня.Количество() <= 5 Тогда
		Для Каждого ЭлементПервогоУровня Из ЭлементыПервогоУровня Цикл
			Если ЭлементПервогоУровня.ПолучитьЭлементы().Количество() > 0 Тогда
				Элементы.РазделыОтчета.Развернуть(ЭлементПервогоУровня.ПолучитьИдентификатор(), Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИдентификаторНайденнойСтрокиДерева(СтрокаДереваРазделов, ИмяРаздела, КодСтраницы)
	
	СтрокиДерева = СтрокаДереваРазделов.ПолучитьЭлементы();
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если НазваниеРазделаСокр(СтрокаДерева) = ИмяРаздела
		   И СтрокаДерева.КодСтраницы = КодСтраницы Тогда
			Возврат СтрокаДерева.ПолучитьИдентификатор();
		КонецЕсли;
		
		ИдентификаторСтроки = ИдентификаторНайденнойСтрокиДерева(СтрокаДерева, ИмяРаздела, КодСтраницы);
		
		Если ИдентификаторСтроки <> Неопределено Тогда
			Возврат ИдентификаторСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НазваниеРазделаСокр(СтрокаДереваРазделов)
	
	НазваниеРаздела = СтрокаДереваРазделов.КолонкаРазделыОтчетаСокрНаим;
	
	РодительЭлемента = СтрокаДереваРазделов.ПолучитьРодителя();
	
	Пока РодительЭлемента <> Неопределено Цикл
		
		НазваниеРаздела = РодительЭлемента.КолонкаРазделыОтчетаСокрНаим;
		
		РодительЭлемента = РодительЭлемента.ПолучитьРодителя();
		
	КонецЦикла;
	
	Возврат НазваниеРаздела;
	
КонецФункции

#КонецОбласти