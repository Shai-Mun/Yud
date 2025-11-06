using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CloseAgents
{
    internal class AllAgents
    {
        private Agent[] agents;
        private int current;
        private int Iter;

        public AllAgents(int length)
        {
            agents = new Agent[length];
            current = 0;
            Iter = 0;
        }

        public Agent Next()
        {
            return agents[Iter++];
        }
        public void Reset()
        {
            Iter = 0;
        }

        public int CurrentAgents()
        {
            return current;
        }

        public Agent GetAgent(int i)
        {
            if (i < 0 || i >= current)
            {
                return null;
            }

            return agents[i];
        }

        public bool AddAgent(Agent a) 
        {
            if (a == null)
            {
                return false;
            }

            if (current < agents.Length)
            {
                agents[current++] = a;
                return true;
            }

            return false;
        }

        public Agent RemoveAgent(string id)
        {
            Agent ret = null;
            bool move = false;

            for (int i = 0; i < current; i++)
            {
                if (move)
                    agents[i - 1] = agents[i];

                if (agents[i].id.Equals(id)) 
                {
                    ret = agents[i];
                    move = true;
                }


            }

            if (move)
                current--;

            return ret;

        }

        public Agent GetClosest(double lat, double longt)
        {
            if (current == 0)
                return null;

            Agent ret = agents[0];
            double closestD = int.MaxValue;

            for (int i = 1; i < current; i++) 
            {
                double currD = agents[i].GetDistance(lat, longt, agents[i].lat, agents[i].longt);

                if (currD < closestD) 
                {
                    closestD = currD;
                    ret = agents[i];
                }
            }

            return ret;
        }

        public double AvgRate()
        {
            int sum = 0;

            for (int i = 0; i < current; i++)
            {
                sum += agents[i].rating;
            }

            return (double)sum/current;
        }

        public override string ToString()
        {
            string s = "----\nAll Agents (" + current + ")\n";
            for (int i = 0; i < current; i++)
            {
                s += "    " + agents[i] + "\n";
            }
            s += "----\n";
            return s;
        }
        
    }
}
