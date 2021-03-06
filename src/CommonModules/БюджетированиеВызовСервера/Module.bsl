////////////////////////////////////////////////////////////////////////////////
//  БюджетированиеВызовСервера
//
//Серверный фунционал, необходимый для работы на клиенте
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру, заполненную датами начала/окончания бюджетного периода, которому соответствует переданная в параетрах дата
//
//Параметры:
//	Дата - Дата, по которой требуется определить бюджетный период
//	ВариантБюджета - СправочникСсылка.ВариантыБюджета - вариант, период которого определяется
//
//Возвращаемое значение:
//	Структура - подробное описание см. в БюджетированиеКлиентСервер.НовыйПериодБюджета();
//
Функция БюджетныйПериодПоКалендарнойДате(Дата = Неопределено, ВариантБюджета = Неопределено) Экспорт

	Если Не ЗначениеЗаполнено(ВариантБюджета) Тогда
		ВариантБюджета = Константы.ОсновнойВариантБюджета.Получить();
	КонецЕсли;

	Результат = Новый Структура("ВариантБюджета", ВариантБюджета);
	
	ПериодПланирования = БюджетированиеСервер.НоваяСтрукрураБюджетногоПериода(ВариантБюджета, Дата);
	Результат.Вставить("НачалоПериодаБюджета", ПериодПланирования.Начало);
	Результат.Вставить("КонецПериодаБюджета",  ПериодПланирования.Окончание);
	Результат.Вставить("КалендарноеНачалоПериодаБюджета", ПериодПланирования.КалендарноеНачало);
	Результат.Вставить("КалендарныйКонецПериодаБюджета",  ПериодПланирования.КалендарноеОкончание);
	
	Возврат Результат;
	
КонецФункции
 

#КонецОбласти


#Область СлужебныеПроцедурыИФункции



#КонецОбласти