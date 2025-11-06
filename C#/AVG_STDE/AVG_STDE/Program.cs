using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AVG_STDE
{
    internal class Program
    {
        static void Main(string[] args)
        {

        }


        public static double[] proc (int numPlayers, int rounds)
        {
            int[] points = new int[numPlayers];
            double[] ret = new double[5];

            for (int i = 0; i < rounds; i++)
            {
                Console.WriteLine("Who won first place?");
                points[int.Parse(Console.ReadLine())] += 7;

                Console.WriteLine("Who won second place?");
                points[int.Parse(Console.ReadLine())] += 3;

                Console.WriteLine("Who got last place?");
                points[int.Parse(Console.ReadLine())] -= 4;


            }

            int max = int.MinValue;
            int maxI = 0;

            for (int i = 0; i < numPlayers;i++)
            { 
                if (points[i] > max)
                {
                    maxI = i;
                    max = points[i];
                }
            }

            ret[0] += max;
            
            for (int i = 0; i < numPlayers;i++)
            {
                if (points[i] == max)
                {
                    Console.Write(i + ", ");
                }
                ret[1] += points[i];
            }

            ret[1] /= (double)numPlayers;

            double sum = 0;
            for (int i = 0;i < numPlayers; i++)
            {
                sum += Math.Pow((double)points[i] - ret[1], 2);
            }
            sum /= (double)numPlayers;
            sum = Math.Sqrt(sum);

            ret[2] = sum;

            int cntMax = 0;
            int cntI = 0;

            for (int i = 0; i < numPlayers; i++)
            {
                int cnt = 0;

                for (int j = i+1; j < numPlayers-1; i++)
                {
                    if (points[i] == points[j])
                    {
                        cnt++;
                    }    
                }

                if (cnt > cntMax)
                {
                    cntMax = cnt;
                    cntI = i;
                }
                   
            }

            ret[3] = points[cntI];

            int[] copy = new int[numPlayers];
            for (int i = 0; i < numPlayers; i++)
            {
                copy[i] = points[i];
            }
            Array.Sort(copy);

            if (numPlayers%2 == 1)
                ret[4] = points[numPlayers/2];
            else
            {
                ret[4] = (points[numPlayers/2] + points[numPlayers/2-1])/2;
            }

        }
    }
}
