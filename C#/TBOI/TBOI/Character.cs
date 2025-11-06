using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;

namespace TBOI
{
    internal class Character
    {
        Random rnd = new Random();

        private MTP c;
        private MTP t1;
        private MTP t2;
        private MTP t3;
        private string name;
        private double health;
        private double damage;
        private bool alive;
        private int money;
        private bool pen;
        private bool spread;
        private int cool;
        private bool spec;
        // Summary:
        //     A construction method for when you want to create a
        //     "player" character (controlled by a keyboard).
        public Character()
        {
            this.c = new MTP(38, 10, '¡', ConsoleColor.White, Console.BackgroundColor, 1);
            this.t1 = new MTP(1, 1, ' ', ConsoleColor.Blue, Console.BackgroundColor, 1);
            this.t2 = new MTP(1, 1, ' ', ConsoleColor.Blue, Console.BackgroundColor, 1);
            this.t3 = new MTP(1, 1, ' ', ConsoleColor.Blue, Console.BackgroundColor, 1);
            this.name = "Player";
            this.health = 5;
            this.damage = 1;
            this.alive = true;
            this.money = 0;
            this.pen = false;
            this.spread = false;
            this.cool = 20;
            this.spec = false;
        }
        
        // Summary:
        //     A construction method for when you want to create an
        //     "enemy" character (controlled by random int generator).
        public Character(int x, int y, int mSpeed, int sSpeed, double health, double damage)
        {
            this.c = new MTP(x, y, '¥', (ConsoleColor)rnd.Next(1,15), Console.BackgroundColor, mSpeed);
            this.t1 = new MTP(1, 1, ' ', ConsoleColor.Red, Console.BackgroundColor, sSpeed);
            this.t2 = null;
            this.t3 = null;
            this.name = "Enemy";
            this.health = health;
            this.damage = damage;
            this.alive = true;
            this.money = 0;
            this.pen = false;
            this.spread = false;
            this.cool = -1;
            this.spec = false;
        }

        // Summary:
        //     A method used for all keyboard inputs, controls
        //     what will happen based on every key pressed.

        public void EMove(Character p)
        {
            int pX = p.GetP().GetX();
            int pY = p.GetP().GetY();
            int eX = c.GetX();
            int eY = c.GetY();
            int mDir = 0;

            if (eX < pX)
            {
                if (eY > pY)
                    mDir = 1;
                else if (eY == pY)
                    mDir = 2;
                else
                    mDir = 3;
            }
            else if (eX == pX)
            {
                if (eY > pY)
                    mDir = 0;
                else
                    mDir = 4;
            }
            else
            {
                if (eY < pY)
                    mDir = 5;
                else if (eY == pY)
                    mDir = 6;
                else
                    mDir = 7;
            }
            c.SetDirection(mDir);
            c.MoveOneStep();
        }

        // Summary:
        //     A method used for controlling the direction of the tear shot
        //     based on a direction given (the null check is used for saftey
        //     so we won't operate on tears 2 and 3 which the enemy doesn't have).
        public void Shoot (Character p, int dir)
        {
            int sDir = 0;

            if (dir == -1)
            {
                int pX = p.GetP().GetX();
                int pY = p.GetP().GetY();
                int eX = c.GetX();
                int eY = c.GetY();

                if (eX <= pX)
                {
                    if (eY >= pY)
                    {
                        sDir = rnd.Next(4);

                    }
                    else
                    {
                        sDir = rnd.Next(2, 5);
                    }
                }
                else
                {
                    if (eY <= pY)
                    {
                        sDir = rnd.Next(4, 7);
                    }
                    else
                    {
                        sDir = rnd.Next(6, 9) % 8;
                    }
                }
            }
            else
                sDir = dir;

            
            if (spread)
            {
                cool = 20;
                if (dir == 0 || dir == 4)
                {
                    if (!t1.GetAppear())
                    {
                        t1 = new MTP(c.GetX() - 1, c.GetY(), '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t1.SetDirection(sDir);
                        t1.SetAppear(true);
                    }
                    if (!t2.GetAppear())
                    {
                        t2 = new MTP(c.GetX(), c.GetY(), '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t2.SetDirection(sDir);
                        t2.SetAppear(true);
                    }
                    if (!t3.GetAppear())
                    {
                        t3 = new MTP(c.GetX() + 1, c.GetY(), '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t3.SetDirection(sDir);
                        t3.SetAppear(true);
                    }        
                }
                else
                {
                    if (!t1.GetAppear())
                    {
                        t1 = new MTP(c.GetX(), c.GetY() - 1, '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t1.SetDirection(sDir);
                        t1.SetAppear(true);
                    }
                    if (!t2.GetAppear())
                    {
                        t2 = new MTP(c.GetX(), c.GetY(), '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t2.SetDirection(sDir);
                        t2.SetAppear(true);
                    }
                    if (!t3.GetAppear())
                    {
                        t3 = new MTP(c.GetX(), c.GetY() + 1, '°', ConsoleColor.Cyan, Console.BackgroundColor, 1);
                        t3.SetDirection(sDir);
                        t3.SetAppear(true);
                    }
                }
                
            }
            else
            {
                if (alive && !t1.GetAppear())
                {
                    t1 = new MTP(c.GetX(), c.GetY(), '°', t1.GetFcolor(), Console.BackgroundColor, 1);
                    t1.SetDirection(sDir);
                    t1.SetAppear(true);
                }
                else if (t2 != null && !t2.GetAppear())
                {
                    t2 = new MTP(c.GetX(), c.GetY(), '°', ConsoleColor.Blue, Console.BackgroundColor, 1);
                    t2.SetDirection(sDir);
                    t2.SetAppear(true);
                }
                else if (t3 != null && !t3.GetAppear())
                {
                    t3 = new MTP(c.GetX(), c.GetY(), '°', ConsoleColor.Blue, Console.BackgroundColor, 1);
                    t3.SetDirection(sDir);
                    t3.SetAppear(true);
                }
            }
            
            
            
        }

        // Summary:
        //     Checks the positions of the tears shot by the player
        //     player's position compared to the enemy and it's tears.
        public void CheckDel()
        {
            if (!alive || (t1.GetX() <= 1 || t1.GetX() >= 77 || t1.GetY() <= 1 || t1.GetY() >= 22) || cool == 0)
            {
                t1.SetAppear(false);
                t1.SetCh(' ');
                t1.SetX(100);
                t1.SetY(0);
                t1.SetDirection(2);
                if (spread)
                    cool = 0;
            }
            if (t2 != null && ((!alive) || (t2.GetX() <= 1 || t2.GetX() >= 77 || t2.GetY() <= 1 || t2.GetY() >= 22 || cool == 0)))
            {
                t2.SetAppear(false);
                t2.SetCh(' ');
                t2.SetX(100);
                t2.SetY(0);
                t2.SetDirection(2);
                if (spread)
                    cool = 0;
            }
            if (t3 != null && ((!alive) || (t3.GetX() <= 1 || t3.GetX() >= 77 || t3.GetY() <= 1 || t3.GetY() >= 22) || cool == 0))
            {
                t3.SetAppear(false);
                t3.SetCh(' ');
                t3.SetX(100);
                t3.SetY(0);
                t3.SetDirection(2);
                if (spread)
                    cool = 0;
            }
            cool--;
        }

        // Summary:
        //     Compares the position of the enemy to the player's tears, and also the
        //     player's position compared to the enemy, and it's tears. (in order)
        public void CmpPos (Character e)
        {
            if (e.alive && e.GetP().GetX() == t1.GetX() && e.GetP().GetY() == t1.GetY())
            {
                e.SetHealth(e.GetHealth() - this.damage);
                if (!pen)
                {
                    t1.SetX(1);
                    CheckDel();
                }
                
            }
            else if (e.alive && e.GetP().GetX() == t2.GetX() && e.GetP().GetY() == t2.GetY())
            {
                e.SetHealth(e.GetHealth() - this.damage);
                if (!pen)
                {
                    t2.SetX(1);
                    CheckDel();
                }
                
            }
            else if (e.alive && e.GetP().GetX() == t3.GetX() && e.GetP().GetY() == t3.GetY())
            {
                e.SetHealth(e.GetHealth() - this.damage);
                if (!pen)
                {
                    t3.SetX(1);
                    CheckDel();
                }
                
            }

            if (c.GetX() == e.GetT1().GetX() && c.GetY() == e.GetT1().GetY())
            {
                SetHealth(this.health - e.GetDamage());
            }

            if (c.GetX() == e.GetP().GetX() && c.GetY() == e.GetP().GetY())
            {
                SetHealth(this.health - e.GetDamage());
            }

            if (this.health <= 0.0)
            {
                c.SetCh(' ');
                c.SetX(100);
                c.SetY(0);
                this.alive = false;
                CheckDel();
            }
        }

        public void MoveT()
        {
            t1.MoveOneStep();
            t2.MoveOneStep();
            t3.MoveOneStep();
        }

        public void Draw ()
        {
            t1.Draw();
            if (t2!=null)
                t2.Draw();
            if (t3!=null)
                t3.Draw();
            c.Draw();
            
        }

        public void Undraw ()
        {
            t1.Undraw();
            if (t2 != null)
                t2.Undraw();
            if (t3 != null)
                t3.Undraw();
            c.Undraw();
            
        }

        public void Death(Character p)
        {
            if (this.health <= 0 && this.health != 101)
            {
                p.SetMoney(p.GetMoney() + rnd.Next(1, 6));
                this.SetHealth(101);
            }
            else if (this.health == 101)
            {
                c.SetCh(' ');
                c.SetX(100);
                c.SetY(0);
                this.alive = false;
                CheckDel();
            }
        }

        public void Info(int xStart, int yStart, ConsoleColor c)
        {
            Console.ForegroundColor = c;
            Console.SetCursorPosition(xStart, yStart);
            for (double i = 0.0; i < health; i++)
            {
                Console.Write('♥');
            }
            if (this.name.Equals("Player"))
            {
                Console.SetCursorPosition(xStart, yStart + 1);
                Console.Write("$: " + this.money);
                Console.SetCursorPosition(xStart, yStart + 2);
                Console.Write("»: " + this.c.GetSpeed());
                Console.SetCursorPosition(xStart, yStart + 3);
                Console.Write("*: " + this.damage);
            }
            
        }
        
        public void DeleteInfo(int xStar, int yStart)
        {
            Console.SetCursorPosition(xStar, yStart);
            Console.Write("          ");
            if (this.name.Equals("Player"))
            {
                Console.SetCursorPosition(xStar, yStart + 1);
                Console.Write("          ");
                Console.SetCursorPosition(xStar, yStart + 2);
                Console.Write("          ");
                Console.SetCursorPosition(xStar, yStart + 3);
                Console.Write("          ");
            }
            
        }

        public void Item(int I, int t)
        {
            int add = 0;

            if (t == 1)
                add = 1;
            else if (t == 2)
                add = 2;
            else if (t == 3)
                add = 3;

            if (I == 0)
            {
                SetDamage(GetDamage() + add);
            }
            else if (I == 1)
            {
                spread = true;
            }
            else if (I == 2)
            {
                pen = true;
            }
            else if (I == 3)
            {
                c.SetSpeed(c.GetSpeed() + add);
            }
            else if (I == 4)
            {
                spec = true;
            }
            else if (I == 5)
            {
                SetHealth(GetHealth() + add);
            }
        }
        #region SetGet
        public MTP GetP()
        {
            return this.c;
        }
        public MTP GetT1()
        {
            return this.t1;
        }
        public MTP GetT2()
        {
            return this.t2;
        }
        public MTP GetT3()
        {
            return this.t3;
        }
        public string GetName()
        {
            return this.name;
        }
        public void SetHealth(double health)
        { 
            this.health = health;
        }
        public double GetHealth()
        {
            return this.health;
        }
        public void SetDamage(double damage)
        {
            this.damage = damage;
        }
        public double GetDamage()
        {
            return this.damage;
        }
        public void SetAlive(bool alive)
        {
            this.alive = alive;
        }
        public bool GetAlive()
        {
            return this.alive;
        }
        public void SetMoney(int money)
        {
            this.money = money;
        }
        public int GetMoney()
        {
            return this.money;
        }
        public bool GetSpec()
        {
            return this.spec;
        }
        #endregion
    }
}
