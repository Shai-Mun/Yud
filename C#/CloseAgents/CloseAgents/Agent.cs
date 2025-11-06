using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace CloseAgents
{
    internal class Agent
    {
        public string id {private set; get; }
        public double lat {private set; get; }
        public double longt {private set; get; }
        public int rating {private set; get; }
        public string country {private set; get; }

        public Agent(string id, double lat, double longt, int rating, string country)
        {
            this.id = id;
            this.lat = lat; 
            this.longt = longt;
            this.country = country;
            this.rating = rating;
        }

        public double GetDistance (double p1Lat,  double p1Longt, double p2Lat, double p2Longt)
        {
            const double EarthRadius = 6371; // Earth's radius in kilometers
            double dLat = Math.PI * (p2Lat - p1Lat) / 180.0;
            double dLon = Math.PI * (p2Longt - p1Longt) / 180.0;
            double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                       Math.Cos(Math.PI * p1Lat / 180.0) *
                       Math.Cos(Math.PI * p2Lat / 180.0) *
                       Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            // Distance in kilometers
            return EarthRadius * 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

        }

        public double DistanceTo(Agent O)
        {
            return GetDistance(lat, longt, O.lat, O.longt);
        }

        public override string ToString()
        {
            return "Agent: id=" + id + ", lat=" + lat + ", longt=" + longt +
               ", rating=" + rating + ", country=" + country;
        }

    }
}
