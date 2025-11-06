using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace TBOI
{
    internal class Boss
    {
        Random rnd = new Random();

        private TRect body;
        private bool alive;
        private double health;
        private int eyes;

        public Boss ()
        {
            this.body = new TRect(60, 12, 15, 5, ConsoleColor.DarkRed);
            this.alive = true;
            this.health = 50;
            this.eyes = 0;
        }

        public void Draw()
        {
            if (alive)
            {
                this.body.Draw();
                int x = 1;
                if (this.eyes == 1)
                    x = 5;
                else if (this.eyes == 2)
                    x = 9;
                Console.ForegroundColor = ConsoleColor.DarkMagenta;
                Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 1);
                Console.Write("\\   /");
                Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 2);
                Console.Write("¤   ¤");
                Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 3);
                Console.Write(" ┌─┐ ");
            }
         
            Console.ForegroundColor = ConsoleColor.Red;
            Console.SetCursorPosition(14, 22);
            for (double i = 0.0; i < health; i++)
                Console.Write("▀");

        }
        public void Undraw()
        {
            this.body.Undraw();
            int x = 1;
            if (this.eyes == 1)
                x = 5;
            else if (this.eyes == 2)
                x = 9;
            Console.ForegroundColor = Console.BackgroundColor;
            Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 1);
            Console.Write("     ");
            Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 2);
            Console.Write("     ");
            Console.SetCursorPosition(this.body.GetX() + x, this.body.GetY() + 3);
            Console.Write("     ");

            Console.ForegroundColor = Console.BackgroundColor;
            Console.SetCursorPosition(14, 22);
            for (double i = 0.0; i < health; i++)
                Console.Write(" ");
        }

        public void Move(Character p)
        {
            int pX = p.GetP().GetX();
            int pY = p.GetP().GetY();
            int bX = body.GetX()+7;
            int bY = body.GetY()+2;
            int xChange = body.GetX();
            int yChange = body.GetY();

            int mDir = 0;

            if (bX < pX)
            {
                if (bY > pY)
                    mDir = 1;
                else if (bY == pY)
                    mDir = 2;
                else
                    mDir = 3;
            }
            else if (bX == pX)
            {
                if (bY > pY)
                    mDir = 0;
                else
                    mDir = 4;
            }
            else
            {
                if (bY < pY)
                    mDir = 5;
                else if (bY == pY)
                    mDir = 6;
                else
                    mDir = 7;
            }

            if (mDir == 0)
            {
                body.SetY(yChange - 1);
                eyes = 1;
            }
            else if (mDir == 1)
            {
                body.SetX(xChange + 1);
                body.SetY(yChange - 1);
                eyes = 2;
            }
            else if (mDir == 2)
            {
                body.SetX(xChange + 1);
                eyes = 2;
            }
            else if (mDir == 3)
            {
                body.SetX(xChange + 1);
                body.SetY(yChange + 1);
                eyes = 2;
            }
            else if (mDir == 4)
            {
                body.SetY(yChange + 1);
                eyes = 1;
            }
            else if (mDir == 5)
            {
                body.SetX(xChange - 1);
                body.SetY(yChange + 1);
                eyes = 0;
            }
            else if (mDir == 6)
            {
                body.SetX(xChange - 1);
                eyes = 0;
            }
            else if (mDir == 7)
            {
                body.SetX(xChange - 1);
                body.SetY(yChange - 1);
                eyes = 0;
            }

            if (body.GetX() == 0)
                body.SetX(1);
            else if (body.GetX() + 14 == 78)
                body.SetX(63);

            if (body.GetY() == 0)
                body.SetY(1);
            else if (body.GetY() + 4 == 23)
                body.SetY(18);

        }

        public void CmpPos(Character c)
        {
            MTP p = c.GetP();
            MTP t1 = c.GetT1();
            MTP t2 = c.GetT2();
            MTP t3 = c.GetT3();

            if (t1.GetX() >= body.GetX() && t1.GetX() <= body.GetX() + 14)
                if (t1.GetY() >= body.GetY() && t1.GetY() <= body.GetY() + 4)
                {
                    SetHealth(GetHealth() - c.GetDamage());
                    t1.SetX(1);
                }

            if (t2.GetX() >= body.GetX() && t2.GetX() <= body.GetX() + 14)
                if (t2.GetY() >= body.GetY() && t2.GetY() <= body.GetY() + 4)
                {
                    SetHealth(GetHealth() - c.GetDamage());
                    t2.SetX(1);
                }

            if (t3.GetX() >= body.GetX() && t3.GetX() <= body.GetX() + 14)
                if (t3.GetY() >= body.GetY() && t3.GetY() <= body.GetY() + 4)
                {
                    SetHealth(GetHealth() - c.GetDamage());
                    t3.SetX(1);
                }
            c.CheckDel();

            if (p.GetX() >= body.GetX() && p.GetX() <= body.GetX() + 14)
                if (p.GetY() >= body.GetY() && p.GetY() <= body.GetY() + 4)
                    c.SetHealth(c.GetHealth() - 1);
            

            if (health <= 0.0)
            {
                alive = false;
                body.SetX(1);
            }

            if (c.GetHealth() == 0.0)
            {
                p.SetCh(' ');
                p.SetX(100);
                p.SetY(0);
                c.SetAlive(false);
                c.CheckDel();
            }
        }

        public void Jump(int x, int y)
        {
            body.SetX(x-7);
            body.SetY(y-2);

            if (body.GetX() <= 0)
                body.SetX(1);
            else if (body.GetX() + 14 >= 78)
                body.SetX(63);

            if (body.GetY() <= 0)
                body.SetY(1);
            else if (body.GetY() + 4 >= 23)
                body.SetY(18);
        }


        public void Flash(int x, int y, ConsoleColor F)
        {
            int xF = x - 7;
            int yF = y - 2;

            if (xF <= 0)
                xF = 1;
            if (yF <= 0)
                yF = 1;

            double xEnd = xF + body.GetWidth();
            double yEnd = yF + body.Getheight();

            if (xEnd >= 78)
            {
                xF = xF - ((int)xEnd - 78);
                xEnd = 77;

            }
            if (yEnd >= 23)
            {
                yF = yF - ((int)yEnd - 23);
                yEnd = 22;
            }

            ConsoleColor b = Console.BackgroundColor;

            Console.BackgroundColor = F;
            for (int i = xF; i < xEnd ; i++)
            {
                for (int j = yF; j < yEnd; j++)
                {
                    Console.SetCursorPosition(i, j);
                    Console.Write(" ");
                }
            }
            Console.BackgroundColor = b;
        }
        #region SetGet
        public void SetAlive(bool alive)
        {
            this.alive = alive;
        }
        public bool GetAlive()
        {
            return this.alive;
        }
        public void SetHealth(double health)
        {
            this.health = health;
        }
        public double GetHealth()
        {
            return this.health;
        }
        #endregion
    }
}
