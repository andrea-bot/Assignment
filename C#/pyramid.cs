// See https://aka.ms/new-console-template for more information

int numberoflayer = 6, Space, Number;
Console.WriteLine("Print paramid");
for (int i = 1; i <= numberoflayer; i++)   
{
    for (Space = 1; Space <= (numberoflayer - i); Space++) 
        Console.Write(" ");
    for (Number = 1; Number <= i; Number++) 
        Console.Write('*');
    for (Number = (i - 1); Number >= 1; Number--)  
        Console.Write('*');
    Console.WriteLine();
}