void Send_to_Processing()
{
  Serial.write(START_BYTE);
  Serial.print(DELIMITER);Serial.print(kalman_roll);        
  Serial.print(DELIMITER);Serial.print(kalman_pitch); 
  Serial.print(DELIMITER);Serial.print(heading); 
  Serial.print(DELIMITER);Serial.write(END_BYTE);
  Serial.println();//send a carriage return
}


//void Read_serial()
//{
//  if (Serial.available())
//  {
//    incomingValue=Serial.read();  
//  }
//  Serial.flush();
//
//}

