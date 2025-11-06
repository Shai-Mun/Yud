using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TBOI
{
    internal class Rooms
    {
        static TRect rect = new TRect(0, 0, 79, 24, ConsoleColor.Yellow);
        static TRect map = new TRect(64, 0, 15, 3, ConsoleColor.White);
        static Line lR = new Line(0, 9, 6, true, ConsoleColor.Yellow);
        static Line rR = new Line(78, 9, 6, true, ConsoleColor.Yellow);
        static Random rnd = new Random();
        static MTP path = new MTP(0, 1, '■', ConsoleColor.White, Console.BackgroundColor, 1);
        static int rL = 0;
        static int rI = 0;
        static int r1 = 0;
        static int r2 = 0;
        static int r3 = 0;
        static int rS = 0;
        static int rB = 0;

        static int i1 = rnd.Next(6);
        static int i2 = rnd.Next(6);
        static int iT1 = rnd.Next(1, 4);
        static int iT2 = rnd.Next(1, 4);

        static int s1 = rnd.Next(6);
        static int s2 = rnd.Next(6);
        static int s3 = rnd.Next(6);
        static int sT1 = rnd.Next(1, 4);
        static int sT2 = rnd.Next(1, 4);
        static int sT3 = rnd.Next(1, 4);

        public static void ChooseRoom(int R, Character p)
        {
            rect.Draw();
            map.Draw();
            lR.Draw();
            rR.Draw();

            if (R == 0)
                RL(p);
            else if (R == 1)
                R1(p);
            else if (R == 2)
                R2(p);
            else if (R == 3)
                R3(p);
            else if (R == 4)
                RS(p);
            else if (R == 5)
                RB(p);
        }

        public static void RL(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Yellow);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Green);
            rR.Draw();
            
            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(2, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(rB, start += 2);

                p.Info(1, 1, p.GetP().GetFcolor());

                Console.SetCursorPosition(12, 1);
                Console.Write("< Health");
                Console.SetCursorPosition(12, 2);
                Console.Write("< Money");
                Console.SetCursorPosition(12, 3);
                Console.Write("< Move Speed");
                Console.SetCursorPosition(12, 4);
                Console.Write("< Damage");

                Console.SetCursorPosition(30, 18);
                Console.Write("Move:");
                Console.SetCursorPosition(30, 19);
                Console.Write("W A S D");
                Console.SetCursorPosition(40, 18);
                Console.Write("Shoot:");
                Console.SetCursorPosition(40, 19);
                Console.Write("^ < v >");

                if (Console.KeyAvailable)
                {
                    p.Undraw();
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                        p.GetP().MoveUp();
                    else if (k.Key == ConsoleKey.S)
                        p.GetP().MoveDown();
                    else if (k.Key == ConsoleKey.A)
                        p.GetP().MoveLeft();
                    else if (k.Key == ConsoleKey.D)
                        p.GetP().MoveRight();

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p,4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }

                if (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15))
                {
                    Console.SetCursorPosition(12, 1);
                    Console.Write("        ");
                    Console.SetCursorPosition(12, 2);
                    Console.Write("       ");
                    Console.SetCursorPosition(12, 3);
                    Console.Write("            ");
                    Console.SetCursorPosition(12, 4);
                    Console.Write("        ");

                    Console.SetCursorPosition(30, 18);
                    Console.Write("     ");
                    Console.SetCursorPosition(30, 19);
                    Console.Write("       ");
                    Console.SetCursorPosition(40, 18);
                    Console.Write("      ");
                    Console.SetCursorPosition(40, 19);
                    Console.Write("       ");
                    p.Undraw();
                    p.GetP().SetX(1);
                    rL = 1;
                    RI(p);
                }

                p.Undraw();
                p.CheckDel();
                p.MoveT();
                p.Draw();

                Thread.Sleep(20);

            }

        }

        public static void RI(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Green);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Green);
            rR.Draw();

            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(2, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(rB, start += 2);

                p.Info(1, 1, p.GetP().GetFcolor());

                if (Console.KeyAvailable)
                {
                    p.Undraw();
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                        p.GetP().MoveUp();
                    else if (k.Key == ConsoleKey.S)
                        p.GetP().MoveDown();
                    else if (k.Key == ConsoleKey.A)
                        p.GetP().MoveLeft();
                    else if (k.Key == ConsoleKey.D)
                        p.GetP().MoveRight();

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }

                Console.SetCursorPosition(35, 13);
                Console.Write('Â');
                Console.SetCursorPosition(45, 13);
                Console.Write('Â');
                if (i1 == 101 || i2 == 101)
                {
                    i1 = 101;
                    i2 = 101;
                }
                DisplayItem(i1, 35, 13, iT1);
                DisplayItem(i2, 45, 13, iT2);


                if (p.GetP().GetX() == 35 && p.GetP().GetY() == 12 && i1 != 101 && i2 != 101)
                {
                    p.Item(i1, iT1);
                    i1 = 101;
                }
                else if (p.GetP().GetX() == 45 && p.GetP().GetY() == 12 && i1 != 101 && i2 != 101)
                {
                    p.Item(i2, iT2);
                    i2 = 101;
                }
                else if (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15))
                {
                    Console.SetCursorPosition(35, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(45, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(35, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(45, 12);
                    Console.Write(' ');
                    p.Undraw();
                    p.GetP().SetX(77);
                    rI = 1;
                    RL(p);
                }
                else if (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15))
                {
                    Console.SetCursorPosition(35, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(45, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(35, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(45, 12);
                    Console.Write(' ');
                    p.Undraw();
                    p.GetP().SetX(1);
                    rI = 1;
                    R1(p);
                }

                p.Undraw();
                p.CheckDel();
                p.MoveT();
                p.Draw();

                Thread.Sleep(20);
            }
        }

        public static void R1(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Yellow);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Yellow);
            rR.Draw();

            Character e1 = new Character(rnd.Next(77), rnd.Next(22), 1, 1, 3, 0.5);
            Thread.Sleep(10);
            Character e2 = new Character(rnd.Next(77), rnd.Next(22), 1, 1, 3, 0.5);
            Thread.Sleep(10);
            Character e3 = new Character(rnd.Next(77), rnd.Next(22), 1, 1, 3, 0.5);
            if (r1 == 0)
            {
                e1.Draw();
                e2.Draw();
                e3.Draw();
            }
            

            int eMove = 0; //enemyMove

            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(2, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(rB, start += 2);

                lR.Draw();
                rR.Draw();

                p.DeleteInfo(1, 1);
                p.Info(1, 1, p.GetP().GetFcolor());

                if (Console.KeyAvailable)
                {
                    p.Undraw();
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                        p.GetP().MoveUp();
                    else if (k.Key == ConsoleKey.S)
                        p.GetP().MoveDown();
                    else if (k.Key == ConsoleKey.A)
                        p.GetP().MoveLeft();
                    else if (k.Key == ConsoleKey.D)
                        p.GetP().MoveRight();

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }
                p.Undraw();
                p.CheckDel();
                p.MoveT();

                if (r1 == 0)
                {
                    e1.Undraw();
                    e2.Undraw();
                    e3.Undraw();

                    e1.CheckDel();
                    e2.CheckDel();
                    e3.CheckDel();

                    e1.GetT1().MoveOneStep();
                    e2.GetT1().MoveOneStep();
                    e3.GetT1().MoveOneStep();


                    p.CmpPos(e1);
                    p.CmpPos(e2);
                    p.CmpPos(e3);

                    e1.Death(p);
                    e2.Death(p);
                    e3.Death(p);

                    if (eMove % 15 == 0)
                    {
                        e1.EMove(p);
                        e1.Shoot(p, -1);
                        e2.EMove(p);
                        e2.Shoot(p, -1);
                        e3.EMove(p);
                        e3.Shoot(p, -1);
                    }
                    e1.Draw();
                    e2.Draw();
                    e3.Draw();
                }
                else
                {
                    e1.SetAlive(false);
                    e2.SetAlive(false);
                    e3.SetAlive(false);
                }

                p.Draw();

                if (!e1.GetAlive() && !e2.GetAlive() && !e3.GetAlive())
                {
                    lR.SetFcolor(ConsoleColor.Green);
                    rR.SetFcolor(ConsoleColor.Green);
                }

                if (lR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(77);
                    r1 = 1;
                    RI(p);
                }
                else if (rR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(1);
                    r1 = 1;
                    R2(p);
                }
                
                Thread.Sleep(20);
                eMove++;
            }
        }

        public static void R2(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Yellow);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Yellow);
            rR.Draw();

            Line horizontal = new Line(19, 12, 40, false, ConsoleColor.Yellow);
            Line vertical = new Line(39, 6, 12, true, ConsoleColor.Yellow);
            horizontal.Draw();
            vertical.Draw();

            Character e1 = new Character(rnd.Next(77), rnd.Next(22), 1, 1, 3, 0.5);
            int eMove = 0; //enemyMove

            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(rB, start += 2);

                lR.Draw();
                rR.Draw();

                p.DeleteInfo(1, 1);
                p.Info(1, 1, p.GetP().GetFcolor());

                p.Undraw();

                if (Console.KeyAvailable)
                {
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                    {
                        if (!horizontal.MoveCheck(p.GetP(), 1, 1) && !vertical.MoveCheck(p.GetP(), 0, 1))
                            p.GetP().MoveUp();
                    }
                    else if (k.Key == ConsoleKey.S)
                    {
                        if (!horizontal.MoveCheck(p.GetP(), 1, -1) && !vertical.MoveCheck(p.GetP(), 0, 0))
                            p.GetP().MoveDown();
                    }
                    else if (k.Key == ConsoleKey.A)
                    {
                        if (!horizontal.MoveCheck(p.GetP(), -1, 0) && !vertical.MoveCheck(p.GetP(), 1, 1))
                            p.GetP().MoveLeft();
                    }
                    else if (k.Key == ConsoleKey.D)
                    {
                        if (!horizontal.MoveCheck(p.GetP(), -1, 0) && !vertical.MoveCheck(p.GetP(), -1, 1))
                            p.GetP().MoveRight();
                    }

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }

                p.Undraw();
                p.CheckDel();
                p.MoveT();

                if (!p.GetSpec())
                {
                    horizontal.AllCheck(p.GetT1());
                    horizontal.AllCheck(p.GetT2());
                    horizontal.AllCheck(p.GetT3());

                    vertical.AllCheck(p.GetT1());
                    vertical.AllCheck(p.GetT2());
                    vertical.AllCheck(p.GetT3());
                }
                if ((p.GetT1().GetX() >= 19 && p.GetT1().GetX() <= 59 && p.GetT1().GetY() == 12) || (p.GetT1().GetY() >= 6 && p.GetT1().GetY() <= 18 && p.GetT1().GetX() == 39))
                {
                    horizontal.Draw();
                    vertical.Draw();
                }
                if ((p.GetT2().GetX() >= 19 && p.GetT2().GetX() <= 59 && p.GetT2().GetY() == 12) || (p.GetT2().GetY() >= 6 && p.GetT2().GetY() <= 18 && p.GetT2().GetX() == 39))
                {
                    horizontal.Draw();
                    vertical.Draw();
                }
                if ((p.GetT3().GetX() >= 19 && p.GetT3().GetX() <= 59 && p.GetT3().GetY() == 12) || (p.GetT3().GetY() >= 6 && p.GetT3().GetY() <= 18 && p.GetT3().GetX() == 39))
                {
                    horizontal.Draw();
                    vertical.Draw();
                }


                if (r2 == 0)
                {
                    e1.Undraw();
                 

                    horizontal.AllCheck(e1.GetT1());
                    vertical.AllCheck(e1.GetT1());

                    e1.CheckDel();

                    e1.GetT1().MoveOneStep();

                    p.CmpPos(e1);

                    e1.Death(p);
                    e1.Draw();

                    if (eMove % 15 == 0)
                    {
                        e1.Undraw();
                        horizontal.eMove(p, e1, vertical);
                        e1.Shoot(p, -1);
                    }


                }
                else 
                {
                    e1.SetAlive(false);
                }

                p.Draw();

                if (!e1.GetAlive())
                {
                    lR.SetFcolor(ConsoleColor.Green);
                    rR.SetFcolor(ConsoleColor.Green);
                }

                if (lR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(77);
                    horizontal.Undraw();
                    vertical.Undraw();
                    r2 = 1;
                    R1(p);
                }
                else if (rR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(1);
                    horizontal.Undraw();
                    vertical.Undraw();
                    r2 = 1;
                    R3(p);
                }


                Thread.Sleep(20);
                eMove++;
            }
        }

        public static void R3(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Yellow);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Yellow);
            rR.Draw();

            Line horizontal1 = new Line(1, 6, 77, false, ConsoleColor.Gray);
            Line horizontal2 = new Line(1, 19, 77, false, ConsoleColor.Gray);
            horizontal1.Draw();
            horizontal2.Draw();

            Character e1 = new Character(rnd.Next(77), rnd.Next(21,23), 1, 1, 3, 0.5);
            Thread.Sleep(20);
            Character e2 = new Character(rnd.Next(77), rnd.Next(21, 23), 1, 1, 3, 0.5);
            Thread.Sleep(20);
            Character e3 = new Character(rnd.Next(77), rnd.Next(1, 4), 1, 1, 3, 0.5);
            Thread.Sleep(20);
            Character e4 = new Character(rnd.Next(77), rnd.Next(1, 4), 1, 1, 3, 0.5);

            int eMove = 0; //enemyMove

            while (p.GetAlive())
            {
                horizontal1.Draw();
                horizontal2.Draw();
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(2, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(rB, start += 2);

                lR.Draw();
                rR.Draw();

                p.DeleteInfo(1, 1);
                p.Info(1, 1, p.GetP().GetFcolor());

                if (Console.KeyAvailable)
                {
                    p.Undraw();


                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                    {
                        if (p.GetP().GetY() - p.GetP().GetSpeed() >= 6)
                            p.GetP().MoveUp();
                        else
                            p.GetP().SetY(6);
                    }
                    else if (k.Key == ConsoleKey.S)
                    {
                        if (p.GetP().GetY() - p.GetP().GetSpeed() <= 18)
                            p.GetP().MoveDown();
                        else
                            p.GetP().SetY(18);
                    }
                    else if (k.Key == ConsoleKey.A)
                    {
                        p.GetP().MoveLeft();
                    }
                    else if (k.Key == ConsoleKey.D)
                    {
                        p.GetP().MoveRight();
                    }

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }

                p.Undraw();
                p.CheckDel();
                p.MoveT();

                if (r3 == 0)
                {
                    e1.Undraw();
                    e2.Undraw();
                    e3.Undraw();
                    e4.Undraw();

                    e1.CheckDel();
                    e2.CheckDel();
                    e3.CheckDel();
                    e4.CheckDel();

                    e1.GetT1().MoveOneStep();
                    e2.GetT1().MoveOneStep();
                    e3.GetT1().MoveOneStep();
                    e4.GetT1().MoveOneStep();

                    e1.Death(p);
                    e2.Death(p);
                    e3.Death(p);
                    e4.Death(p);

                    p.CmpPos(e1);
                    p.CmpPos(e2);
                    p.CmpPos(e3);
                    p.CmpPos(e4);

                    if (eMove % 15 == 0)
                    {
                        horizontal1.eMove(p, e1, horizontal2);
                        horizontal1.eMove(p, e2, horizontal2);
                        horizontal1.eMove(p, e3, horizontal2);
                        horizontal1.eMove(p, e4, horizontal2);

                        e1.Shoot(p, -1);
                        e2.Shoot(p, -1);
                        e3.Shoot(p, -1);
                        e4.Shoot(p, -1);
                    }

                    e1.Draw();
                    e2.Draw();
                    e3.Draw();
                    e4.Draw();

                    
                }
                else
                {
                    e1.SetAlive(false);
                    e2.SetAlive(false);
                    e3.SetAlive(false);
                    e4.SetAlive(false);
                }

                p.Draw();

                if (!e1.GetAlive() && !e2.GetAlive() && !e3.GetAlive() && !e4.GetAlive())
                {
                    lR.SetFcolor(ConsoleColor.Green);
                    rR.SetFcolor(ConsoleColor.Green);
                }

                if (lR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(77);
                    horizontal1.Undraw();
                    horizontal2.Undraw();
                    r3 = 1;
                    R2(p);
                }
                else if (rR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(1);
                    horizontal1.Undraw();
                    horizontal2.Undraw();
                    r3 = 1;
                    RS(p);
                }

                Thread.Sleep(20);
                eMove++;
            }
        }

        public static void RS(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Green);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Green);
            rR.Draw();

            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(2, start += 2);
                PrintRoom(rB, start += 2);

                p.Info(1, 1, p.GetP().GetFcolor());

                if (Console.KeyAvailable)
                {
                    p.Undraw();
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                        p.GetP().MoveUp();
                    else if (k.Key == ConsoleKey.S)
                        p.GetP().MoveDown();
                    else if (k.Key == ConsoleKey.A)
                        p.GetP().MoveLeft();
                    else if (k.Key == ConsoleKey.D)
                        p.GetP().MoveRight();

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }

                Console.SetCursorPosition(30, 13);
                Console.Write('Â');
                Console.SetCursorPosition(40, 13);
                Console.Write('Â');
                Console.SetCursorPosition(50, 13);
                Console.Write('Â');
                

                DisplayItem(s1, 30, 13, sT1);
                int p1 = 0;
                if (s1 == 1 || s1 == 2 || s1 == 4)
                {
                    p1 = 15;
                    DisplayPrice(30, 13, sT1);
                }
                else
                    p1 = DisplayPrice(30, 13, sT1);


                DisplayItem(s2, 40, 13, sT2);
                int p2 = 0;
                if (s2 == 1 || s2 == 2 || s2 == 4)
                {
                    p2 = 15;
                    DisplayPrice(40, 13, sT2);
                }
                else
                    p2 = DisplayPrice(40, 13, sT2);


                DisplayItem(s3, 50, 13, sT3);
                int p3 = 0;
                if (s3 == 1 || s3 == 2 || s3 == 4)
                {
                    p3 = 15;
                    DisplayPrice(50, 13, sT3);
                }
                else
                    p3 = DisplayPrice(50, 13, sT3);


                if (p.GetP().GetX() == 30 && p.GetP().GetY() == 12 && s1 != 101)
                {
                    if (p.GetMoney() >= p1)
                    {
                        p.Item(s1, sT1);
                        s1 = 101;
                        p.SetMoney(p.GetMoney() - p1);
                    }
                }
                else if (p.GetP().GetX() == 40 && p.GetP().GetY() == 12 && s2 != 101)
                {
                    if (p.GetMoney() >= p2)
                    {
                        p.Item(s2, sT2);
                        s2 = 101;
                        p.SetMoney(p.GetMoney() - p2);
                    }
                    
                }
                else if (p.GetP().GetX() == 50 && p.GetP().GetY() == 12 && s3 != 101)
                {
                    if (p.GetMoney() >= p3)
                    {
                        p.Item(s3, sT3);
                        s3 = 101;
                        p.SetMoney(p.GetMoney() - p3);
                    }
                    
                }

                else if (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15))
                {
                    Console.SetCursorPosition(30, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(40, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(50, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(30, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(40, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(50, 12);
                    Console.Write(' ');
                    DisplayPrice(30, 13, 0);
                    DisplayPrice(40, 13, 0);
                    DisplayPrice(50, 13, 0);
                    p.Undraw();
                    p.GetP().SetX(77);
                    rS = 1;
                    R3(p);
                }
                else if (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15))
                {
                    Console.SetCursorPosition(30, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(40, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(50, 13);
                    Console.Write(' ');
                    Console.SetCursorPosition(30, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(40, 12);
                    Console.Write(' ');
                    Console.SetCursorPosition(50, 12);
                    Console.Write(' ');
                    DisplayPrice(30, 13, 0);
                    DisplayPrice(40, 13, 0);
                    DisplayPrice(50, 13, 0);
                    p.Undraw();
                    p.GetP().SetX(1);
                    rS = 1;
                    RB(p);
                }

                p.Undraw();
                p.CheckDel();
                p.MoveT();
                p.Draw();

                Thread.Sleep(20);
            }
        }

        public static void RB(Character p)
        {
            rect.Draw();
            lR.SetFcolor(ConsoleColor.Yellow);
            lR.Draw();
            rR.SetFcolor(ConsoleColor.Yellow);
            rR.Draw();

            int eMove = 0; //enemyMove
            int jCnt = 0;
            int jump = 30;
            int jX = 0;
            int jY = 0;
            Boss b = new Boss();

            while (p.GetAlive())
            {
                map.Draw();
                int start = 63;
                PrintRoom(rL, start += 2);
                PrintRoom(rI, start += 2);
                PrintRoom(r1, start += 2);
                PrintRoom(r2, start += 2);
                PrintRoom(r3, start += 2);
                PrintRoom(rS, start += 2);
                PrintRoom(2, start += 2);

                lR.Draw();
                rR.Draw();

                p.DeleteInfo(1, 1);
                p.Info(1, 1, p.GetP().GetFcolor());

                if (Console.KeyAvailable)
                {
                    p.Undraw();
                    ConsoleKeyInfo k = Console.ReadKey(true);
                    if (k.Key == ConsoleKey.W)
                        p.GetP().MoveUp();
                    else if (k.Key == ConsoleKey.S)
                        p.GetP().MoveDown();
                    else if (k.Key == ConsoleKey.A)
                        p.GetP().MoveLeft();
                    else if (k.Key == ConsoleKey.D)
                        p.GetP().MoveRight();

                    else if (k.Key == ConsoleKey.UpArrow)
                        p.Shoot(p, 0);
                    else if (k.Key == ConsoleKey.DownArrow)
                        p.Shoot(p, 4);
                    else if (k.Key == ConsoleKey.LeftArrow)
                        p.Shoot(p, 6);
                    else if (k.Key == ConsoleKey.RightArrow)
                        p.Shoot(p, 2);
                    p.Draw();
                }
                p.Undraw();
                p.CheckDel();
                p.MoveT();

                
                if (rB == 0)
                {
                    
                    b.Undraw();

                    b.CmpPos(p);

                    if (eMove % 10 == 0)
                    {
                        b.Move(p);
                        if (jCnt < 10)
                            jCnt++;
                    }

                    if (jCnt == 10)
                    {
                        if (jump == 30)
                        {
                            jX = p.GetP().GetX();
                            jY = p.GetP().GetY();
                        }
                        else if (jump == 0)
                        {
                            b.Jump(jX, jY);
                            jCnt = 0;
                            jump = 31;
                        }
                        jump--;
                        if (eMove % 20 == 0)
                        {
                            b.Flash(jX, jY, ConsoleColor.Yellow);
                            Thread.Sleep(10);
                            b.Flash(jX, jY, Console.BackgroundColor);
                        }
                        

                    }
                    
                    b.Draw();
                }
                else
                {
                    b.SetAlive(false);
                }
                
                p.Draw();

                if (!b.GetAlive())
                {
                    lR.SetFcolor(ConsoleColor.Green);
                    rR.SetFcolor(ConsoleColor.Green);
                    Console.SetCursorPosition(30, 12);
                    Console.Write("Congratulations! You won!");
                }
                
                if (lR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 1 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(77);
                    r1 = 1;
                    RS(p);
                }
                else if (rR.GetFcolor() == ConsoleColor.Green && (p.GetP().GetX() == 77 && (p.GetP().GetY() >= 9 && p.GetP().GetY() <= 15)))
                {
                    p.Undraw();
                    p.GetP().SetX(1);
                    r1 = 1;
                    RL(p);
                }

                Thread.Sleep(20);
                eMove++;
            }
        }

        public static void PrintRoom(int r, int s)
        {
            path.SetX(s);
            if (r == 0)
                path.SetFcolor(ConsoleColor.White);
            else if (r == 1)
                path.SetFcolor(ConsoleColor.Green);
            else
                path.SetFcolor(ConsoleColor.Yellow);
            path.Draw();
            path.SetX(++s);
            path.SetFcolor(ConsoleColor.Red);
            if (s != 78)
            {
                path.SetCh('-');
                path.Draw();
            }
            path.SetCh('■');
         
        }

        public static void DisplayItem(int Item, int x, int y, int t)
        {
            if (t == 1)
                Console.ForegroundColor = ConsoleColor.Red;
            else if (t == 2)
                Console.ForegroundColor = ConsoleColor.Yellow;
            else
                Console.ForegroundColor = ConsoleColor.Green;

            Console.SetCursorPosition(x, y - 1);

            if (Item == 101)
                Console.Write(' ');
            else if (Item == 0)
                Console.Write('*');
            else if (Item == 1)
            {
                Console.ForegroundColor = ConsoleColor.White;
                Console.Write('E');
            }
            else if (Item == 2)
            {
                Console.ForegroundColor = ConsoleColor.White;
                Console.Write('ø');
            }
            else if (Item == 3)
                Console.Write('»');
            else if (Item == 4)
            {
                Console.ForegroundColor = ConsoleColor.White;
                Console.Write('÷');
            }
            else if (Item == 5)
                Console.Write('♥');
        }

        public static int DisplayPrice(int x, int y, int t)
        {
            Console.SetCursorPosition(x - 1, y + 1);
            Console.ForegroundColor = ConsoleColor.White;

            if (t == 1)
            {
                Console.Write(" 5$");
                return 5;
            }
            else if (t == 2)
            {
                Console.Write("10$");
                return 10;
            }
            else if (t == 3)
            {
                Console.Write("15$");
                return 15;
            }
            else
            {
                Console.Write("   ");
                return 0;
            }
            
        }

    }
}
