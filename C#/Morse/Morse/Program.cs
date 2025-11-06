using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Morse
{
    internal class Program
    {
        static void Main(string[] args)
        {
        }

        public static void ReadBin()
        {
            BinaryReader br;
            br = new BinaryReader(new FileStream(@"test", FileMode.Open));
            byte[] barr = br.ReadBytes(10);
            try
            {
                bool endRead = false;
                while (!endRead)
                {
                    byte myByte = br.ReadByte();
                    int x = Convert.ToInt32(myByte);
                }

            }
            catch (IOException e)
            { 
                Console.WriteLine(e.Message + "\n.");
            }
            br.Close();

        }
    }
}
