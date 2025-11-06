using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;

namespace Brackets
{
    internal class Program
    {
        static void Main(string[] args)
        {
            char c = ' ';
            char head = ' ';
            string str = "";
            bool ret = true;
            int index = -1;
            using (StreamReader sr = new StreamReader("a2.txt"))
            {
                str = sr.ReadLine();
            }

            StackA<char> s = new StackA<char>(300);

            for (int i = 0; i < str.Length; i+=2)
            {
                c = str[i];

                if (c == '(' || c == '{' || c == '[')
                    s.Push(c);
                else if (c == ')' || c == '}' || c == ']')
                {
                    head = s.Pop();
                    if ((char)(c-2) != head && (char)(c-1) != head)
                    {
                        index = i;
                        ret = false;
                        i = str.Length;
                    }

                }
            }

            Console.WriteLine(ret + ", " + index);
        }
    }
}
