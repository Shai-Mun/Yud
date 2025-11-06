using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;

namespace TBOI
{

    internal class Program
    {

        static void Main(string[] args)
        {
            Console.SetCursorPosition(39, 12);
            Console.WriteLine("Ready to start? (press any key)");
            Console.ReadKey(true);
            Console.SetCursorPosition(39, 12);
            Console.WriteLine("                               ");
            Console.CursorVisible = false;
            Character p = new Character();

            Rooms.ChooseRoom(4, p);
            
        }
    }
}
