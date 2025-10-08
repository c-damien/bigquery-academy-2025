/*
* Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.


 * This UDF is used to insert a new field into the message data.
 * 
 * @param {Object} message - The message to insert the field into.
 * @param {Object} metadata - The metadata of the message.
 * @returns {Object} The message with the inserted field.
 *created by cdamien
 */

function data_preprocessing(message, metadata) {
  const msg = JSON.parse(message.data);

//processing time
msg.processing_time = Math.floor(Date.now() / 1000);

//userid
 if (typeof msg.user?.userId !== 'string') {
    msg.user.userId = "[INVALID]"
 }

 //IP validation
  if (typeof msg.user.ipAddress == 'string'){ 
    const ipRegex = new RegExp(
    /^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$/
  );
   if(!ipRegex.test(msg.user.ipAddress)){
    msg.user.ipAddress = "[INVALID]"
   }
  }else{
     msg.ipAddress = "[INVALID]"
  }

  if(msg.user.email.length > 0) { msg.user.email = "[REDACTED]"
  }else{
    msg.user.email = "[UNKNOWN]"
  }

  msg.credit_card_number = "********"

  message.data = JSON.stringify(msg);

  return message;
}