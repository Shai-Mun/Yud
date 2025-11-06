using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace myArgv
{
    internal class Program
    {
        static int Main(string[] args)
        {
            int len = args.Length;
            if (len <= 1)
            {
                throw new ArgumentException("Not enough parameters");
            }

            int n1;
            int n2;
            

            switch (args[0])
            {
                case "+":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        return Plus(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }


                case "-":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        return Minus(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                case "*":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        return Mul(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                case "/":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        int r = n1 / n2;
                        return (int)Div(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }
                    

                case "//":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        int r = n1 / n2;
                        return IntDiv(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                case "**":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        return Expo(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                case "NEG":
                    if (len != 2)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        return Neg(n1);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                case "mod":
                    if (len != 3)
                        throw new ArgumentException("Not enough parameters");

                    try
                    {
                        n1 = int.Parse(args[1]);
                        n2 = int.Parse(args[2]);
                        int r = n1 / n2;
                        return Mod(n1, n2);
                    }
                    catch
                    {
                        throw new ArgumentException("Value cannot be converted");
                    }

                default:
                    throw new ArgumentException("myArgv Parameter not supported");
            }



        }

        public static int Plus (int n1, int n2)
        {
             return n1 + n2;
        }

        public static int Minus (int n1, int n2)
        {
            return n1 - n2;
        }

        public static int Mul(int n1, int n2)
        {
            return n1 * n2;
        }

        public static double Div(int n1, int n2)
        {
            return (double)n1 / n2;
        }

        public static int IntDiv(int n1, int n2)
        {
            return n1 / n2;
        }

        public static int Expo(int n1, int n2)
        {
            return (int)Math.Pow(n1, n2);
        }

        public static int Neg(int n)
        {
            return -1 * n;
        }

        public static int Mod(int n1, int n2)
        {
            return n1 % n2;
        }


    }
}
