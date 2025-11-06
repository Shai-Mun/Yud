using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace my2048
{
    internal class Program
    {
        static void Main(string[] args)
        {
            my2048 a = new my2048(7);
            a.PrintArray();

            while (a.canPlay())
            {

                if (Console.KeyAvailable)
                {
                    ConsoleKeyInfo k = Console.ReadKey(true);

                    if (k.Key == ConsoleKey.LeftArrow)
                        a.Left2048();
                    else if (k.Key == ConsoleKey.RightArrow)
                        a.Right2048();
                       
                }
                Thread.Sleep(200);
            }

        }
    }
}
