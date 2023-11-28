const dia = new Date().getDay();

const msg = 
dia === 0 ? 
'Opção 1': 
dia === 6 ? :
'Opção 2':
'Opção 3'; 
alert(msg);


In the corrected code, 
the ternary operators are structured in a way 
that it first checks if dia is equal to 0 (Sunday), 
and if so, assigns 'Opção 1' to msg. 
If dia is not equal to 0, it then checks if dia is equal to 6 (Saturday), 
and if so, assigns 'Opção 2' to msg. 
If neither of these conditions is met, it assigns 'Opção 3' to msg.