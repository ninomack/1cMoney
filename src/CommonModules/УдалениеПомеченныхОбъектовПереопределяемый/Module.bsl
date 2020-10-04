///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед поиском объектов, помеченных на удаление.
// В этом обработчике можно организовать удаление устаревших ключей аналитик и любых других объектов информационной
// базы, ставших более не нужными.
//
// Параметры:
//   Параметры - Структура - со свойствами:
//     * Интерактивное - Булево - Истина, если удаление помеченных объектов запущено пользователем;
//                                Ложь, если удаление запущено по расписанию регламентного задания.
//
Процедура ПередПоискомПомеченныхНаУдаление(Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
