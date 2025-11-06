using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace CloseAgents
{
    internal class Program
    {
        static void Main(string[] args)
        {
            AllAgents ag1 = new AllAgents(400);

            Agent a1 = new Agent("4632", 25.86001, 28.212, 10, "Egypt");
            Agent a2 = new Agent("993", -17.976001, 32.816, 7, "Mozambique");
            Agent a3 = new Agent("666", 25.1271, 29.8815, 3, "Morocco");
            Agent a4 = new Agent("876", 20.976001, 12.0016, 7, "Arab S");
            Agent a5 = new Agent("855", 24.3433, 43.5454, 3, "Yaman");
            Agent a6 = new Agent("007", -17.8976001, 32.8316, 2, "Mozambique");
            Agent a7 = new Agent("744", 32.115543, 41.1241, 2, "Iraq");
            Agent a8 = new Agent("145", 30.147559, 11.1199975, 9, "Jorden");
            Agent a9 = new Agent("146", 20.9761, 11.999675, 8, "Jorden");
            Agent a10 = new Agent("121", 28.924074, 53.219117, 7, "Iran");
            Agent a11 = new Agent("484", 33.139952, 47.590673, 4, "Iran");
            Agent a12 = new Agent("101", 28.615904, 52.867339, 7, "Iran");
            Agent a13 = new Agent("321", 29.22765, 51.460228, 7, "Iran");
            Agent a14 = new Agent("560", 32.7121, 50.44721, 2, "Iran");

            ag1.AddAgent(a1);
            ag1.AddAgent(a2);
            ag1.AddAgent(a3);
            ag1.RemoveAgent("993");
            Console.WriteLine(ag1);

            ag1.AddAgent(a4);
            ag1.AddAgent(a5);
            ag1.AddAgent(a6);
            ag1.AddAgent(a7);
            ag1.AddAgent(a8);
            ag1.AddAgent(a9);
            ag1.AddAgent(a10);
            ag1.AddAgent(a11);
            ag1.AddAgent(a12);
            ag1.AddAgent(a13);
            ag1.AddAgent(a14);
            ag1.AddAgent(a2);
            Console.WriteLine(ag1);
            Console.WriteLine("Avg rate =" + ag1.AvgRate());

            int cnt = 0;
            for (int i = 0; i < ag1.CurrentAgents(); i++)
            {
                if (ag1.GetAgent(i).rating >= 5)
                    cnt++;
            }
            Console.WriteLine("There are " + cnt + " Agents with rate 5 or more");

            GetClosestAgents(ag1);
            GetClosestAgentsC(ag1);
            AllAgents ag2 = GetAttackGroup(ag1, 5);

            string msg = "";
            for (int i = 0; i < 5; i++)
            {
                msg += ag2.GetAgent(i).id;
            }
            Console.WriteLine(msg);
        }

        public static void GetClosestAgents(AllAgents ag)
        {
            Agent a1 = null;
            Agent a2 = null;
            double minD = double.MaxValue;

            for (int i = 0; i < ag.CurrentAgents(); i++)
            {
                for (int j = i + 1;  j < ag.CurrentAgents(); j++)
                {
                    if (ag.GetAgent(i).DistanceTo(ag.GetAgent(j)) < minD)
                    {
                        a1 = ag.GetAgent(i);
                        a2 = ag.GetAgent(j);
                        minD = a1.DistanceTo(a2);
                    }
                }
            }

            Console.WriteLine(a1);
            Console.WriteLine(a2);

        }

        public static void GetClosestAgentsC(AllAgents ag)
        {
            Agent a1 = null;
            Agent a2 = null;
            double minD = double.MaxValue;

            for (int i = 0; i < ag.CurrentAgents(); i++)
            {
                for (int j = i + 1; j < ag.CurrentAgents(); j++)
                {
                    if (ag.GetAgent(i).DistanceTo(ag.GetAgent(j)) < minD && ag.GetAgent(i).country.Equals(ag.GetAgent(j).country))
                    {
                        a1 = ag.GetAgent(i);
                        a2 = ag.GetAgent(j);
                        minD = a1.DistanceTo(a2);
                    }
                }
            }

            Console.WriteLine(a1);
            Console.WriteLine(a2);

        }

        public static AllAgents GetAttackGroup(AllAgents ag, int size)
        {
            if (ag.CurrentAgents() < size)
                return null;

            AllAgents ag2 = new AllAgents(size);
            Agent fake = new Agent("fake", 32.177070, 35.006902, 1, "Fake");
            double[] d = new double[ag.CurrentAgents()];

            for (int i = 0; i < d.Length; i++)
            {
                d[i] = fake.DistanceTo(ag.GetAgent(i));
            }

            for (int i = 0; i < size; i++)
            {
                int minI = 0;

                for (int j = 1; j < ag.CurrentAgents(); j++)
                {
                    if (d[j] < d[minI])
                        minI = j;
                }

                ag2.AddAgent(ag.GetAgent(minI));
                d[minI] = double.MaxValue;
            }

            return ag2;
        }

        //public static void run_Iter(AllAgents ag)
        //{
        //    foreach (Agent agent in ag)
        //    {
        //        Console.WriteLine(agent);
        //    }
        //}
    }
}
