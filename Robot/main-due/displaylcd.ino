#include <LiquidCrystal.h>
const int rs = 52, en = 50, d4 = 48, d5 = 46, d6 = 44, d7 = 42;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setupLcd() {
  lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.print("AGV");
  lcd.setCursor(0, 1);
  lcd.print("wait 5 second");
  delay(1000);
  lcd.setCursor(0, 1);
  lcd.print("wait 4 second");
  delay(1000);
  lcd.setCursor(0, 1);
  lcd.print("wait 3 second");
  delay(1000);
  lcd.setCursor(0, 1);
  lcd.print("wait 2 second");
  delay(1000);
  lcd.setCursor(0, 1);
  lcd.print("wait 1 second");
  delay(1000);
}

void displayDatetime() {
  lcd_print(0, 0,"                ");
  lcd_print(0, 1,"                ");
  lcd_print(0, 0, "%2d:%2d:%2d", gpsHour, gpsMinute, gpsSecond);
  lcd_print(0, 1, "%2d/%2d/%4d", gpsDay, gpsMonth, gpsYear);
}

void displaySerial() {
  lcd_print(0, 0,"                ");
  lcd_print(0, 1,"                ");
  lcd_print(0, 0, "%2d | %2d | %2d", point, targetDegree, headingDegrees);
  //lcd_print(0, 1, "%2d/%2d/%4d", gpsDay, gpsMonth, gpsYear);
}

void displayBattery() {
  lcd_print(0, 0,"                ");
  lcd_print(0, 1,"                ");
  lcd_print(0, 0, "%2f volts", batteryOne);
  lcd_print(0, 1, "%2f volts", batteryTwo);
}


void displayCheckOne() {
  lcd_print(0, 0,"                ");
  lcd_print(0, 1,"                ");
  lcd_print(0, 0, "%16s", "Check 1");
  lcd_print(0, 1, "%16s", "Rotate CW");
}

void displayCheckTwo() {
  lcd_print(0, 0,"                ");
  lcd_print(0, 1,"                ");
  lcd_print(0, 0, "%16s", "Check 2");
  lcd_print(0, 1, "%16s", "Rotate CCW");
}

//    lcd.setCursor(0, 0);
//    lcd.print("                ");
//    lcd.setCursor(0, 0);
//    lcd.print("Check 1");
//    lcd.setCursor(12, 0);
//    lcd.print(targetDegree);
//    lcd.setCursor(0, 1);
//    lcd.print("                ");
//    lcd.setCursor(0, 1);
//    lcd.print("Rotate CW");
//    lcd.setCursor(12, 1);
//    lcd.print(headingCorrectionPID);

void lcd_print(uint8_t x, uint8_t y, const char* fmtstr, ...)
{
  char lcd_string[21];
  va_list ap;

  va_start(ap, fmtstr);
  vsprintf(lcd_string, fmtstr, ap);
  va_end(ap);

  lcd.setCursor(x, y);
  lcd.print(lcd_string);
}

