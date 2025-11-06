using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace my2048
{
    internal class my2048
    {
        Random rnd = new Random();

        private int[] arr;
        private int Score;

        public my2048(int len)
        {
            this.arr = new int[len];
            for (int i = 0; i < len; i++)
            {
                arr[i] = 0;
            }

            this.Score = 0;
        }

        private void AddNum()
        {
            int add = 2;

            int ran = rnd.Next(1, 101);
            if (ran > 85)
                add = 4;

            int emptySpaces = EmptySpace();
            int space = rnd.Next(1, emptySpaces);

            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == 0)
                {
                    space--;
                    if (space == 0)
                    {
                        arr[i] = add;
                        return;
                    }
                }
            }
        }

        private int EmptySpace()
        {
            int cnt = 0;

            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == 0)
                    cnt++;
            }

            return cnt;
        }

        public bool Right2048()
        {
            PrintArray();
            bool ret = false;
            int temp = 0;

            for (int i = arr.Length - 2; i >= 0; i--)
            {
                if (arr[i] != 0)
                {
                    temp = i + 1;
                    while (arr[temp] == 0 && temp < arr.Length - 2)
                    {
                        arr[temp] = arr[temp - 1];
                        arr[temp - 1] = 0;
                        temp++;
                        ret = true;
                    }

                }
            }

            for (int i = arr.Length - 2; i >= 0; i--)
            {
                if (arr[i] == arr[i + 1])
                {
                    arr[i + 1] *= 2;
                    arr[i] = 0;
                    ret = true;
                }
            }

            for (int i = arr.Length - 2; i >= 0; i--)
            {
                if (arr[i] != 0)
                {
                    temp = i + 1;
                    while (arr[temp] == 0 && temp < arr.Length - 2)
                    {
                        arr[temp] = arr[temp - 1];
                        arr[temp - 1] = 0;
                        temp++;
                        ret = true;
                    }

                }
            }

            PrintArray();
            AddNum();
            Thread.Sleep(500);
            PrintArray();
            return ret;
        }

        public bool Left2048()
        {
            PrintArray();

            bool ret = false;
            int temp = 0;

            for (int i = 1; i < arr.Length; i++)
            {
                if (arr[i] != 0)
                {
                    temp = i - 1;
                    while (arr[temp] == 0 && temp > 0)
                    {
                        arr[temp] = arr[temp + 1];
                        arr[temp + 1] = 0;
                        temp--;
                        ret = true;
                    }

                }
            }

            for (int i = 1; i < arr.Length; i++)
            {
                if (arr[i] == arr[i - 1])
                {
                    arr[i - 1] *= 2;
                    arr[i] = 0;
                    ret = true;
                }
            }

            for (int i = 1; i < arr.Length; i++)
            {
                if (arr[i] != 0)
                {
                    temp = i - 1;
                    while (arr[temp] == 0 && temp > 0)
                    {
                        arr[temp] = arr[temp + 1];
                        arr[temp + 1] = 0;
                        temp--;
                        ret = true;
                    }

                }
            }

            PrintArray();
            AddNum();
            Thread.Sleep(500);
            PrintArray();
            return ret;
        }

        public void PrintArray()
        {
            Console.Clear();

            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == 0)
                    Console.ForegroundColor = ConsoleColor.Black;
                else if (arr[i] == 2)
                    Console.ForegroundColor = ConsoleColor.Green;
                else if (arr[i] == 4)
                    Console.ForegroundColor = ConsoleColor.DarkBlue;
                else if (arr[i] == 8)
                    Console.ForegroundColor = ConsoleColor.Red;
                else if (arr[i] == 16)
                    Console.ForegroundColor = ConsoleColor.DarkGreen;
                else if (arr[i] == 32)
                    Console.ForegroundColor = ConsoleColor.Blue;
                else if (arr[i] == 64)
                    Console.ForegroundColor = ConsoleColor.Cyan;
                else if (arr[i] == 128)
                    Console.ForegroundColor = ConsoleColor.DarkGray;
                else if (arr[i] == 256)
                    Console.ForegroundColor = ConsoleColor.Magenta;
                else if (arr[i] == 512)
                    Console.ForegroundColor = ConsoleColor.DarkYellow;
                else if (arr[i] == 1024)
                    Console.ForegroundColor = ConsoleColor.DarkCyan;
                else if (arr[i] == 2048)
                    Console.ForegroundColor = ConsoleColor.DarkRed;

                Console.Write(" " + arr[i] + " ");

            }

            Thread.Sleep(100);
        }

        public bool same()
        {
            for (int i = 0; i < arr.Length-1; i++)
            {
                if (arr[i] == arr[i+1])
                    return true;
            }

            return false;
        }

        public bool canPlay()
        {
            if (EmptySpace() == 0 && !same())
                return false;


            return true;
        }


    }
}
